# FPGA_Pocket_SegaCD repository status

Date: 2026-07-06

## Task 6Q status

- Added Genesis-only openFPGA package skeleton under:
  - `openfpga/FPGA_Pocket_SegaCD/`
- Added package skeleton checker script:
  - `tools/check_openfpga_package_skeleton.sh`
- Added supporting layout/test planning docs:
  - `docs/TASK6Q_OPENFPGA_PACKAGE_SKELETON.md`
  - `docs/POCKET_FILE_LAYOUT_GENESIS_ONLY.md`
  - `docs/OPENFPGA_PACKAGE_SKELETON_STATUS.md`
  - `docs/GENESIS_ONLY_SMOKE_TEST_PLAN.md`

## Global blockers

- Quartus toolchain still not available in local build host path.
- No third_party runtime import is activated for real synthesis in this milestone.
- No binary payload files committed.

## Safety constraints still in effect

- Genesis-only APF behavior only.
- No Sega-CD, 32X, save states, BIOS/CD image slots.
- No real ROM host-per-read runtime streaming.

## Next milestones

- Task 6R and beyond should wire packaging output and/or Quartus handoff once
  toolchain is available.

