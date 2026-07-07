# Task 5K: Dependency scan usage

Run from repo root.

## Basic scan

```bash
python3 tools/scan_verilog_deps.py
```

- Uses default root `.`.
- Scans `apf/`, `apf/src/fpga/core/`, `apf/src/fpga/sim/`, plus discovered `rtl/` folders.

## Scan with explicit root

```bash
python3 tools/scan_verilog_deps.py --root .
```

- Explicit equivalent of the default in this repo.
- Useful in scripted CI/doc workflows.

## Scan with entry file/module seed

```bash
python3 tools/scan_verilog_deps.py --root . --entry apf/apf_genesis_base.sv
```

- Uses `apf/apf_genesis_base.sv` as the entry hint.
- Produces the same advisory categories and an entry-aware section.

## Expected read-only behavior

- No files are modified.
- No synthesis/build is performed.
- Reports are text only.

## Interpretation notes

- Any `missing` module in output means the script did not find its declaration
  in scanned `.v/.sv` files.
- `system` may still appear as missing until imported runtime is present.
- Excluded groups (e.g., `Genesis.sv`, `sys/sys_top.v`, Sega-CD/32X areas, HPS/IOCTL-related paths) are only advisory exclusions for this milestone.
