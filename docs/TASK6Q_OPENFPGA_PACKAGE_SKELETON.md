# Task 6Q: Genesis-only openFPGA package skeleton and Pocket file layout

Scope:
- Keep Milestone 6Q strictly Genesis-only and scaffolding-only.
- Do not introduce Sega-CD/32X.
- Do not include any runtime bitstream or generated Quartus outputs.
- Keep package layout explicit and verifiable for future Quartus activation.

## OpenFPGA package scaffold created

- Added `openfpga/FPGA_Pocket_SegaCD/` package root.
- Added placeholder package subtrees:
  - `openfpga/FPGA_Pocket_SegaCD/apf/`
  - `openfpga/FPGA_Pocket_SegaCD/quartus/`
  - `openfpga/FPGA_Pocket_SegaCD/build/`
  - `openfpga/FPGA_Pocket_SegaCD/docs/`
- Added `openfpga/README.md` and package root `README.md` describing deferred
  packaging and deferred runtime wiring.

## What stays non-active in this task

- No APF bitstream (`*.sof`, `*.pof`, `*.rbf`, `*.jic`, etc.).
- No Sega-CD BIOS/ISO slots.
- No save-state payload.
- No real APF host-per-read ROM streaming.

## Validation

- Added non-blocking checker: `tools/check_openfpga_package_skeleton.sh`.
- Checker writes a summary report to `docs/OPENFPGA_PACKAGE_SKELETON_STATUS.md`.
- Checker performs:
  - package-root/skeleton directory checks
  - placeholder README/file existence checks
  - prohibited-file hygiene checks for known fake payloads

## Immediate next milestone

- Keep this structure as long-lived layout documentation.
- Activate packaging copy/sync step only after a Quartus-capable validation path
  confirms the core can reach elaboration and the project scripts are ready.

