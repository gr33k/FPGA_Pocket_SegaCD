# Pocket file layout (Genesis-only)

This document is the working layout reference for the openFPGA/FPGA Pocket
package skeleton.

## Intended package root

`openfpga/FPGA_Pocket_SegaCD/`

### apf/

- Holds APF-facing metadata and source references for future copy/sync
- Placeholder only for this task:
  - `README.md`
- Future expected content:
  - `core.json`, `data.json`, `input.json`, `video.json`, `audio.json`,
    `interact.json`, `variants.json`

### quartus/

- Holds Quartus project and constraint scaffolding
- Placeholder only for this task
- Future expected content:
  - `.qpf`, `.qsf`, `.sdc`, timing/constraints

### build/

- Planned output staging directory
- No generated artifacts committed in this milestone

### docs/

- Holds package-level notes and validation notes

## Pocket SD staging target

- Default staging target: `<POCKET_SD_ROOT>/openfpga/FPGA_Pocket_SegaCD`
- Staging script:
  - `tools/stage_pocket_sd_skeleton.sh`
- Staging check:
  - `tools/check_pocket_sd_staging.sh`

## Source-of-truth boundaries

- APF source stays at repo root `/apf`.
- Core-facing wrapper stays at `/apf/src/fpga/core/core_top.v`.
- Runtime service scaffolding (`rom_*`, preload, tiny RAM stub) stays under
  `/apf/src/fpga/core`.
- Imported Genesis runtime is not packaged here yet.

## Pocket fast-path objective

- Keep this layout deterministic for future automation.
- Keep build/release outputs explicit and excluded from this repo until the next
  milestone where Quartus outputs can be generated safely.
