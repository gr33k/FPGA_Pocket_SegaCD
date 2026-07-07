#!/usr/bin/env python3
"""Read-only dependency scan helper for HDL modules.

This tool is advisory only. It performs lightweight static text scanning for
SystemVerilog/Verilog module declarations and suspected module instantiations.

Usage examples:
  python3 tools/scan_verilog_deps.py
  python3 tools/scan_verilog_deps.py --root .
  python3 tools/scan_verilog_deps.py --root . --entry apf/apf_genesis_base.sv
"""

from __future__ import annotations

import argparse
import os
import re
from collections import defaultdict
from pathlib import Path
from typing import Dict, Iterable, List, Set

VERILOG_EXTS = {".sv", ".v"}
VHDL_EXTS = {".vhd", ".vhdl"}

# Conservative exclusion set for this feasibility milestone.
EXCLUDED_FILE_PATTERNS = [
    "Genesis.sv",
    os.path.join("sys", "sys_top.v"),
    "sys_top.v",
    os.path.join("sys", "hps_io.sv"),
    "hps_io.sv",
    "SegaCD",
    "megacd",
    "32x",
    "sdram_controller",
]

EXCLUDED_MODULE_KEYWORDS = {
    "module",
    "endmodule",
    "input",
    "output",
    "inout",
    "wire",
    "reg",
    "logic",
    "integer",
    "time",
    "if",
    "else",
    "for",
    "while",
    "case",
    "function",
    "endfunction",
    "task",
    "endtask",
    "always",
    "always_comb",
    "always_ff",
    "always_latch",
    "initial",
    "assign",
    "generate",
    "genvar",
    "localparam",
    "parameter",
    "typedef",
    "include",
    "import",
    "package",
    "primitive",
}

PRIMITIVE_MODULES = {
    "and",
    "nand",
    "nor",
    "or",
    "xor",
    "xnor",
    "buf",
    "bufif0",
    "bufif1",
    "notif0",
    "notif1",
    "cmos",
    "rnmos",
    "rpmos",
    "rtran",
    "tran",
    "rtranif0",
    "rtranif1",
    "tranif0",
    "tranif1",
}

MODULE_DECL_RE = re.compile(r"^\s*module\s+([A-Za-z_][A-Za-z0-9_]*)\\b", re.MULTILINE)
SUSPECT_INSTANT_RE = re.compile(
    r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s+([A-Za-z_][A-Za-z0-9_]*)\s*(#\s*\()?\s*\\(",
    re.MULTILINE,
)


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Scan HDL files for module declarations and instantiation candidates.")
    p.add_argument("--root", default=".", help="Repository root to scan")
    p.add_argument(
        "--entry",
        default="",
        help="Optional entry module/file (e.g., apf/apf_genesis_base.sv)",
    )
    return p.parse_args()


def collect_scan_roots(root: Path) -> List[Path]:
    explicit = [
        root / "apf",
        root / "apf" / "src" / "fpga" / "core",
        root / "apf" / "src" / "fpga" / "sim",
    ]

    # Include any `rtl` directory found under root for imported runtime work.
    rtl_dirs = [p for p in root.rglob("rtl") if p.is_dir() and p.name == "rtl"]

    roots = []
    for path in explicit + rtl_dirs:
        if path.exists() and path not in roots:
            roots.append(path)
    return roots


def list_files(roots: Iterable[Path]) -> List[Path]:
    files: List[Path] = []
    for root in roots:
        if not root.exists():
            continue
        for ext in ["*.v", "*.sv", "*.vhd", "*.vhdl"]:
            files.extend(root.rglob(ext))
    return sorted(set(files))


def strip_comments(text: str) -> str:
    # Remove block comments first then line comments.
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)
    lines = []
    for raw in text.splitlines():
        line = re.sub(r"//.*", "", raw)
        lines.append(line)
    return "\n".join(lines)


def is_excluded_path(path: Path) -> bool:
    p = str(path)
    return any(pattern in p for pattern in EXCLUDED_FILE_PATTERNS)


def is_excluded_module(module_name: str) -> bool:
    return (
        module_name in EXCLUDED_MODULE_KEYWORDS
        or module_name in PRIMITIVE_MODULES
        or module_name.lower().startswith(("genvar",))
    )


def scan_file(path: Path) -> Dict[str, Set[str]]:
    text = path.read_text(errors="replace")
    clean = strip_comments(text)

    declared = set(MODULE_DECL_RE.findall(clean))

    instantiations = set()
    for line in clean.splitlines():
        m = SUSPECT_INSTANT_RE.match(line)
        if not m:
            continue
        module_name = m.group(1)
        if is_excluded_module(module_name):
            continue
        instantiations.add(module_name)

    return {
        "declared": declared,
        "instantiations": instantiations,
    }


def build_index(files: List[Path]) -> Dict[str, Dict[str, Set[str]]]:
    declared_by_module: Dict[str, Set[str]] = defaultdict(set)
    inst_by_module: Dict[str, Set[str]] = defaultdict(set)

    for f in files:
        result = scan_file(f)
        for mod in result["declared"]:
            declared_by_module[mod].add(str(f))
        for dep in result["instantiations"]:
            inst_by_module[dep].add(str(f))

    return {
        "declared_by_module": declared_by_module,
        "inst_by_module": inst_by_module,
    }


def seed_entry_modules(entry: str, declared_by_module: Dict[str, Set[str]]) -> Set[str]:
    if not entry:
        return set()

    entry_set = {entry}
    seed: Set[str] = set()

    if os.path.isfile(entry):
        path = Path(entry)
        if path.exists():
            result = scan_file(path)
            for mod in result["declared"]:
                seed.add(mod)
        if seed:
            return seed
        # If file did not declare a module, try matching by filename.
        stem = path.stem
        if stem in declared_by_module:
            seed.add(stem)
        return seed

    if entry in declared_by_module:
        seed.add(entry)
    return seed


def expand_reachable(seed: Set[str], index: Dict[str, Set[str]]) -> Set[str]:
    # Conservative one-level closure on instantiated modules. We do not parse
    # which instantiation belongs to which parent declaration, so this is advisory.
    if not seed:
        return set()

    declared_by_module = index["declared_by_module"]
    inst_by_module = index["inst_by_module"]

    reachable = set(seed)
    frontier = list(seed)

    while frontier:
        current = frontier.pop(0)
        for dep in inst_by_module:
            if dep in reachable:
                continue
            # If current appears to be defined, keep exploring; conservative behavior.
            if current in declared_by_module:
                reachable.add(dep)
                frontier.append(dep)

    return reachable


def main() -> int:
    args = parse_args()

    root = Path(args.root).resolve()
    roots = collect_scan_roots(root)

    files = list_files(roots)
    files_scanned = [str(p) for p in files]
    if not files_scanned:
        print("No verilog/sv/vhd files found in requested roots.")
        return 0

    v_files = [p for p in files if p.suffix.lower() in VERILOG_EXTS]
    vhd_files = [p for p in files if p.suffix.lower() in VHDL_EXTS]

    declared_by_module: Dict[str, Set[str]] = defaultdict(set)
    inst_by_module: Dict[str, Set[str]] = defaultdict(set)

    for path in v_files:
        result = scan_file(path)
        for mod in result["declared"]:
            declared_by_module[mod].add(str(path))
        for dep in result["instantiations"]:
            inst_by_module[dep].add(str(path))

    declared = sorted(declared_by_module)
    instantiated = sorted(inst_by_module)

    declared_set = set(declared)
    instantiated_set = set(instantiated)

    excluded_modules = {
        "Genesis",
        "Genesis_s",
        "sys_top",
        "hps_io",
        "SegaCD",
        "MegaCD",
        "megacd",
    }

    missing = sorted(
        m for m in instantiated_set if m not in declared_set and m not in excluded_modules and m not in PRIMITIVE_MODULES
    )

    unknown = []
    for dep in missing:
        low = dep.lower()
        if "sys" in low or "hps" in low or "cd" in low:
            continue
        unknown.append(dep)

    excluded_paths = [str(p) for p in files if is_excluded_path(p)]

    seed_modules = seed_entry_modules(args.entry, declared_by_module)
    reachable = expand_reachable(seed_modules, {
        "declared_by_module": declared_by_module,
        "inst_by_module": inst_by_module,
    }) if seed_modules else set()

    print("Dependency scan report")
    print(f"Root: {root}")
    print(f"Entry: {args.entry or '(none)'}")
    if seed_modules:
        print(f"Entry module seeds: {', '.join(sorted(seed_modules))}")
    print(f"Files scanned (V/.SV): {len(v_files)}")
    print(f"Files scanned (VHDL): {len(vhd_files)}")
    print()

    print("Declared modules:")
    if declared:
        for m in declared:
            print(f"  - {m}")
    else:
        print("  (none)")
    print()

    print("Suspected instantiations:")
    if instantiated:
        for m in instantiated:
            print(f"  - {m}")
    else:
        print("  (none)")
    print()

    print("Missing / external-expected modules:")
    if missing:
        for m in missing:
            print(f"  - {m}")
    else:
        print("  (none)")
    print()

    print("Intentionally excluded notes:")
    print(f"  - Excluded file patterns: {', '.join(EXCLUDED_FILE_PATTERNS)}")
    if excluded_paths:
        for p in excluded_paths:
            print(f"  - path excluded by policy: {p}")
    else:
        print("  - No excluded path matches in scanned files")
    print()

    print("Unknown / advisory-only dependencies:")
    if unknown:
        for m in unknown:
            print(f"  - {m}")
    else:
        print("  (none)")
    print()

    if seed_modules:
        print("Reachable modules from entry (advisory):")
        for mod in sorted(reachable):
            print(f"  - {mod}")
        print()

    print("Files scanned:")
    for f in files_scanned:
        print(f"  - {f}")

    # If this probe detects no declarations for `system`, remind the caller
    # that runtime import is still required.
    if "system" in missing:
        print()
        print("Missing required runtime boundary: system")
        print("  - system is not declared in scanned files and is expected from imported Genesis_MiSTer runtime")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
