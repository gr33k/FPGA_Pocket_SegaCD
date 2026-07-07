# FPGA_Pocket_SegaCD repository status

Date: 2026-07-06

## Task 6S status

- Added Docker-based Quartus build-host preparation scaffold under `docker/`.
- Added host handoff docs for Fedora NAS via Docker.
- Added workflow checker and dry-run scripts for Docker Quartus preflight.
- Quartus remains unavailable on this local machine; no run-time analysis can proceed here.

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

## Task 6R status

- Added Pocket SD staging workflow and build-host handoff scaffolding:
  - `tools/stage_pocket_sd_skeleton.sh`
  - `tools/check_pocket_sd_staging.sh`
  - `docs/TASK6R_POCKET_SD_STAGING_AND_BUILD_HANDOFF.md`
  - `docs/POCKET_SD_STAGING_WORKFLOW.md`
  - `docs/QUARTUS_BUILD_HOST_HANDOFF.md`
  - `docs/GENESIS_ONLY_PACKAGE_COPY_CHECKLIST.md`

## Global blockers

- Quartus toolchain still not available in local build host path.
- No third_party runtime import is activated for real synthesis in this milestone.
- No binary payload files committed.
- Dockerized Quartus prep is now in place; real execution still requires Quartus-capable host.

## Safety constraints still in effect

- Genesis-only APF behavior only.
- No Sega-CD, 32X, save states, BIOS/CD image slots.
- No real ROM host-per-read runtime streaming.

## Next milestones

- Task 6R and beyond should wire packaging output and/or Quartus handoff once
  toolchain is available.
