# FPGA_Pocket_SegaCD openFPGA package skeleton (Genesis-only)

This is a static skeleton for the future openFPGA Pocket package root.

- Scope is strictly Genesis-only for now.
- No runtime ROM loading from host is represented in this layout.
- No Sega-CD, no 32X, no save state containers.
- No binaries or generated outputs are tracked here.
- Quartus build artifacts are staged externally on a Quartus-capable host.
- Staging into a Pocket SD layout is supported via
  `tools/stage_pocket_sd_skeleton.sh`.

## Planned sub-tree

- `apf/` — APF metadata + top-level source references
- `quartus/` — Quartus project skeleton / generated placeholders only
- `build/` — future compile and release outputs (currently placeholder only)
- `docs/` — package-level notes and checks

No files in this directory are considered build-artifacts for this task.

## Staging intent

- Stage-only mode is the first step: copy package metadata and placeholders to
  `/Volumes/POCKET/openfpga/FPGA_Pocket_SegaCD`.
- Real bitstream copy into package release location is deferred until Quartus
  analysis/elaboration succeeds and output exists.
