# Genesis-only active build-path status

## Current status

- APF runtime wrapper and ROM preload scaffold remain active boundaries.
- **Implementation strategy now selected:** submodule-backed `openFPGA-Genesis` path for the Genesis-only lane.
- No Sega-CD and no 32X integration.
- No real memory controller or runtime host-per-read ROM streaming.
- No package build outputs or Quartus synthesis artifacts are committed.

## Milestone 6Q status

- Added Genesis-only openFPGA package skeleton at:
  - `openfpga/FPGA_Pocket_SegaCD/`
- Added package layout status/check tooling:
  - `tools/check_openfpga_package_skeleton.sh`
  - `docs/OPENFPGA_PACKAGE_SKELETON_STATUS.md`
- Added layout/docs:
  - `docs/TASK6Q_OPENFPGA_PACKAGE_SKELETON.md`
  - `docs/POCKET_FILE_LAYOUT_GENESIS_ONLY.md`
  - `docs/GENESIS_ONLY_SMOKE_TEST_PLAN.md`

## Milestone 6V status

- Chosen source integration strategy is **C: submodule-based `openFPGA-Genesis`.**
- `third_party/Genesis_MiSTer` remains in planning/reference state and is no longer the active implementation lane.
- Active implementation direction now points to the Pocket/openFPGA-Genesis submodule integration path.
- No submodule checkout for `third_party/openFPGA-Genesis` is enforced in this host session yet.

## Remaining blockers

- Quartus toolchain still absent for real synthesis/elaboration automation.
- No active package copy step from repo APF sources into package payload.
- No imported Genesis_MiSTer runtime source set activated yet.
