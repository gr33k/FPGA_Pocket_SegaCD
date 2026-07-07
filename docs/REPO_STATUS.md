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

## Task 6V status

- Source integration strategy decision is now made: **build around a submodule** using `openFPGA-Genesis`.
- Active implementation lane is no longer the `third_party/Genesis_MiSTer` path for runtime behavior.
- APF-owned scaffolding remains active and unchanged:
  - `apf/src/fpga/core/*`
  - `apf/apf_genesis_base.sv`
- The new active runtime direction is documented in
  `docs/TASK6V_SOURCE_INTEGRATION_STRATEGY.md`.

## Task 6W status

- Added and pinned third-party submodule: `third_party/openFPGA-Genesis`.
- `third_party/openFPGA-Genesis` is now the primary Genesis-only implementation lane.
- `third_party/Genesis_MiSTer` remains reference-only and non-active.
- OpenFPGA submodule status and required file audit are tracked in:
  - `docs/OPENFPGA_GENESIS_SUBMODULE_STATUS.md`
- Source direction and manifest are tracked in:
  - `docs/OPENFPGA_GENESIS_SOURCE_MANIFEST.md`
  - `docs/OPENFPGA_GENESIS_INTEGRATION_DELTA.md`
- Quartus remains blocked on NAS until installer is staged in `/root/fpga/installers`.
- No Quartus, synthesis, fitter, or timing run happened in Task 6W.

## Safety constraints still in effect

- Genesis-only APF behavior only.
- No Sega-CD, 32X, save states, BIOS/CD image slots.
- No real ROM host-per-read runtime streaming.

## Next milestones

- Task 6R and beyond should wire packaging output and/or Quartus handoff once
  toolchain is available.

## Task 6U pivot status

The project is pivoting to a Pocket-native Genesis base.

Primary upstream reference:
- `third_party/openFPGA-Genesis`
- https://github.com/opengateware/openFPGA-Genesis

Secondary reference:
- `third_party/Analogizer_openFPGA-Genesis`
- https://github.com/RndMnkIII/Analogizer_openFPGA-Genesis

The old MiSTer-first APF scaffold remains as research/supporting material but is no longer the main implementation direction.

Immediate target:
- Genesis-only Pocket boot

Deferred:
- Sega CD until Genesis boots
- 32X until Genesis boots and resource/timing cost is evaluated

Quartus remains blocked until a Quartus Lite Linux installer is placed on the NAS.
