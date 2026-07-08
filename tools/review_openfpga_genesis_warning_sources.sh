#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUMMARY_FILE="${1:-$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_WARNING_SUMMARY.md}"
LOG_FILE="${2:-$ROOT_DIR/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt}"
SOURCE_ROOT="$ROOT_DIR/third_party/openFPGA-Genesis/src/fpga"
REPORT_FILE="$ROOT_DIR/docs/OPENFPGA_GENESIS_WARNING_SOURCE_REVIEW.md"

if [[ ! -f "$SUMMARY_FILE" ]]; then
  echo "ERROR: warning summary missing: $SUMMARY_FILE" >&2
  exit 1
fi

if [[ ! -f "$LOG_FILE" ]]; then
  echo "ERROR: analysis log missing: $LOG_FILE" >&2
  exit 1
fi

if [[ ! -d "$SOURCE_ROOT" ]]; then
  echo "ERROR: source root missing: $SOURCE_ROOT" >&2
  exit 1
fi

python3 - "$SUMMARY_FILE" "$LOG_FILE" "$SOURCE_ROOT" "$REPORT_FILE" <<'PY'
import os
import re
import sys
from pathlib import Path

summary_path, log_path, source_root, report_path = sys.argv[1:5]
summary_path = Path(summary_path)
log_path = Path(log_path)
source_root = Path(source_root)
report_path = Path(report_path)

def normalize_source_path(path_text):
    if not path_text:
        return None
    p = path_text.strip()
    if not p:
        return None
    candidates = []
    if p.startswith('/work/'):
        parts = p.split('/src/fpga/', 1)
        if len(parts) == 2:
            candidates.append((source_root / parts[1]))
    if '/src/fpga/' in p:
        candidates.append(Path(p[p.find('/src/fpga/') + 1 :]))
        candidates.append(Path(p[p.find('src/fpga/') + 0 :]))
    if p.startswith(source_root.as_posix()):
        candidates.append(Path(p))

    for candidate in candidates:
        try:
            c = candidate if candidate.is_absolute() else Path(candidate)
            if c.exists() and c.is_file():
                return c
        except Exception:
            continue

    # fallback: search by basename under source_root
    base = Path(p).name
    if base:
        for f in source_root.rglob(base):
            if f.is_file():
                return f
    return None


def get_excerpt(file_path: Path, line_no: int, context: int = 8):
    if not file_path or not file_path.exists():
        return ""
    text = file_path.read_text(encoding='utf-8', errors='replace').splitlines()
    if line_no <= 0:
        line_no = 1
    start = max(1, line_no - context)
    end = min(len(text), line_no + context)
    lines = []
    for i in range(start, end + 1):
        if 1 <= i <= len(text):
            lines.append(f"{i:05d}: {text[i-1]}")
    return "\n".join(lines)

warn_line_re = re.compile(r"Warning \((\d+)\):\s*(.*?)\s*File:\s*([^\s]+)\s+Line:\s*(\d+)", re.IGNORECASE)
code_classes = {
    "10030": "ROM/loader path placeholder",
    "10858": "APF bridge/register placeholder",
    "10259": "SDRAM/default-constant issue",
    "12241": "connectivity warning class requiring report follow-up",
    "10036": "intentional unused/stub/interface placeholder",
    "10230": "intentional unused/stub/interface placeholder",
    "10762": "intentional unused/stub/interface placeholder",
    "113027": "ROM/loader path placeholder",
    "113028": "ROM/loader path placeholder",
    "287013": "intentional unused/stub/interface placeholder",
}

code_dispositions = {
    "ROM/loader path placeholder": "yes",
    "APF bridge/register placeholder": "yes",
    "intentional unused/stub/interface placeholder": "needs more evidence",
    "SDRAM/default-constant issue": "needs more evidence",
    "connectivity warning class requiring report follow-up": "needs more evidence",
}

code_reason = {
    "ROM/loader path placeholder": "Signal/module appears intentionally unused or present as a ROM-related stub in upstream openFPGA baseline. Safe for this scaffold-only gate as long as behavior is still inactive/not used for gameplay path.",
    "APF bridge/register placeholder": "Signal appears tied to bridge/debug command scaffolding and is unused in this milestone. Expected for an APF-shell-only analysis lane.",
    "intentional unused/stub/interface placeholder": "No deterministic runtime semantics currently expected from this path in this scaffold pass; does not directly indicate a fitter blocker by itself.",
    "SDRAM/default-constant issue": "Constant-width arithmetic/implementation detail in SDRAM helper logic; needs review against intended memory model before fitter/ROM pathway integration.",
    "connectivity warning class requiring report follow-up": "No direct file/line witness in log for this class. Connectivity report evidence is required before changing gate status.",
}

entries = {}
seen = set()
for line in summary_path.read_text(encoding='utf-8', errors='replace').splitlines():
    m = warn_line_re.search(line)
    if not m:
        continue
    code, msg, file_text, line_text = m.groups()
    key = (code, file_text, int(line_text))
    if key in seen:
        continue
    seen.add(key)
    try:
        resolved = normalize_source_path(file_text)
    except Exception:
        resolved = None
    entries.setdefault(code, []).append({
        "message": msg.strip(),
        "file": file_text,
        "resolved_file": resolved,
        "line": int(line_text),
    })

# Also try to capture any connectivity warnings by line if present
for line in log_path.read_text(encoding='utf-8', errors='replace').splitlines():
    m = warn_line_re.search(line)
    if not m:
        continue
    code = m.group(1)
    msg = m.group(2).strip()
    if code != "12241":
        continue
    file_text = m.group(3)
    lnum = int(m.group(4))
    key = (code, file_text, lnum)
    if key in seen:
        continue
    try:
        resolved = normalize_source_path(file_text)
    except Exception:
        resolved = None
    entries.setdefault(code, []).append({
        "message": msg,
        "file": file_text,
        "resolved_file": resolved,
        "line": lnum,
    })
    seen.add(key)

# Ensure required review classes exist even if no examples were parsed.
for required_code in ["10030", "10858", "10259", "12241", "10036", "10230", "10762"]:
    entries.setdefault(required_code, [])

reviewed_codes = sorted(entries.keys(), key=lambda c: int(c))

def classify(code, item):
    file_text = item.get("file", "")
    line_no = item.get("line", 0)
    msg = item.get("message", "")

    if any(flag in file_text for flag in ["core_bridge_cmd.v"]) or any(flag in msg for flag in ["host_", "target_"]):
        return "APF bridge/register placeholder"
    if any(token in msg.lower() for token in ["rom_data2", "rom_rdack2", "rom2", "build_id"]):
        return "ROM/loader path placeholder"
    if code == "10259" or "sdram.sv" in file_text or line_no == 82:
        return "SDRAM/default-constant issue"
    return code_classes.get(code, "unknown")

report = []
report.append("# openFPGA Genesis warning source review")
report.append("")
report.append(f"Generated: {__import__('datetime').datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')}")
report.append(f"Source warning summary: {summary_path}")
report.append(f"Source analysis log: {log_path}")
report.append(f"Source tree reviewed: {source_root}")
report.append("")

overall_disposition = "needs more review"
class_counts = {"safe": 0, "needs_more_review": 0, "blocked": 0}

for code in reviewed_codes:
    items = entries[code]
    report.append(f"## Warning code {code}")
    if not items:
        report.append("- No parsed file/line examples were available in summary/log.")
        class_counts["needs_more_review"] += 1
        report.append("- Overall disposition: needs more evidence")
        report.append("- Reason: no source witness currently available for this code in the captured summary entries.")
        report.append("")
        continue

    code_class = None
    code_dispo = None
    report.append(f"- Total reviewed examples: {len(items)}")

    for idx, item in enumerate(items, start=1):
        resolved_file = item["resolved_file"]
        file_display = str(resolved_file) if resolved_file is not None else item["file"]
        resolved_line = int(item["line"])
        item_class = classify(code, item)

        if code_class is None:
            code_class = item_class
        if code_class != item_class:
            code_class = "unknown"

        report.append(f"- Example {idx}")
        report.append(f"  - message: {item['message']}")
        report.append(f"  - source: `{file_display}`")
        report.append(f"  - line: {resolved_line}")
        if resolved_file is not None and resolved_file.exists():
            report.append("  - excerpt:")
            report.append("    ```verilog")
            excerpt = get_excerpt(resolved_file, resolved_line)
            if excerpt:
                for ex_line in excerpt.splitlines():
                    report.append(f"    {ex_line}")
            else:
                report.append("    (excerpt unavailable)")
            report.append("    ```")
        else:
            report.append("  - excerpt: missing source file in docs-only review path")

        if item_class == "ROM/loader path placeholder":
            reason = code_reason[item_class]
        elif item_class == "APF bridge/register placeholder":
            reason = code_reason[item_class]
        elif item_class == "intentional unused/stub/interface placeholder":
            reason = code_reason[item_class]
        elif item_class == "SDRAM/default-constant issue":
            reason = code_reason[item_class]
        elif item_class == "connectivity warning class requiring report follow-up":
            reason = code_reason[item_class]
        else:
            reason = "Classification not obvious from local witness text; preserve for manual review."

        report.append(f"  - assessment: {item_class}")
        report.append(f"  - reasoning: {reason}")
        disposition = code_dispositions.get(item_class, "needs more evidence")
        report.append(f"  - likely safe for first fitter smoke gate: {disposition}")
    
    if code_class is None:
        code_class = "unknown"
    if code_class == "connectivity warning class requiring report follow-up" or code_class == "SDRAM/default-constant issue":
        disp = "needs more review"
    elif code_dispositions.get(code_class, "needs more evidence") == "yes":
        disp = "safe"
    else:
        disp = "needs more review"

    if disp == "safe":
        class_counts["safe"] += 1
    else:
        class_counts["needs_more_review"] += 1

    report.append(f"- Per-code disposition: {disp}")
    report.append(f"- Per-class assessment: {code_class}")
    report.append("")

    if code == "12241":
        report.append("- Note: class 12241 appears as a global connectivity summary warning and should be confirmed from connectivity report evidence captured in docs/OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt.")

    report.append("")

if class_counts["needs_more_review"] == 0 and class_counts["blocked"] == 0:
    overall_disposition = "READY_FOR_FITTER_GATE"
elif class_counts["safe"] > 0:
    overall_disposition = "REVIEW_WARNINGS_FIRST"

report.append("## Gate disposition from source review")
report.append(f"- safe codes: {class_counts['safe']}")
report.append(f"- needs-more-review codes: {class_counts['needs_more_review']}")
report.append(f"- blocked codes: {class_counts['blocked']}")
report.append(f"- decision: **{overall_disposition}**")
report.append("")
report.append("### Open decision notes")
report.append("- This review pass does not edit imported third-party RTL.")
report.append("- No change in Sega CD, 32X, or host-per-read ROM streaming behavior is implied.")
report.append("- Keep runtime stub status as placeholder-only for this task.")

report_path.write_text("\n".join(report) + "\n", encoding='utf-8')
print(f"Wrote review report to {report_path}")
print(f"Overall disposition: {overall_disposition}")
PY
