# FPGA_Pocket_SegaCD openFPGA package skeleton (Genesis-only)

This is a static skeleton for the future openFPGA Pocket package root.

- Scope is strictly Genesis-only for now.
- No runtime ROM loading from host is represented in this layout.
- No Sega-CD, no 32X, no save state containers.
- No binaries or generated outputs are tracked here.

## Planned sub-tree

- `apf/` — APF metadata + top-level source references
- `quartus/` — Quartus project skeleton / generated placeholders only
- `build/` — future compile and release outputs (currently placeholder only)
- `docs/` — package-level notes and checks

No files in this directory are considered build-artifacts for this task.

