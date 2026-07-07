# FPGA_Pocket_SegaCD repository status

Date: 2026-07-07

## Task 6Z status

- Added `openFPGA-Genesis` analysis-only Quartus runner and check:
  - `tools/run_openfpga_genesis_analysis_only.sh`
  - `tools/check_openfpga_genesis_analysis_runner.sh`
- Added status/check outputs:
  - `docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md`
  - `docs/OPENFPGA_GENESIS_ANALYSIS_RUNNER_CHECK.md`
  - `docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt`
- Task 6ZA made the analysis runner submodule-safe:
  - Runner executes in `build/openfpga_genesis_analysis_work/src/fpga`.
  - Source project is copied from `third_party/openFPGA-Genesis/src/fpga` to avoid mutating submodule checkout.
  - No fitter/assembler/timing/bitstream runs are configured.
- Blocker after 6ZA remains Quartus availability.
- Confirmed openFPGA lane assumptions:
  - `PROJECT_REVISION = ap_core`
  - `TOP_LEVEL_ENTITY = apf_top`
  - `DEVICE = 5CEBA4F23C8`
- Runner is gated on Quartus availability and currently reports:
  - `BLOCKED: quartus_map not found`
- `Genesis_MiSTer` remains reference-only.
- `openFPGA-Genesis` remains the active implementation lane for this milestone.
- Sega CD and 32X remain excluded.

## Task 7A status

- Attempted Quartus restoration/run task from both local host and NAS.
- Local Quartus:
  - `command -v quartus_map`: not found.
- NAS (`root@192.168.10.144`) Quartus:
  - `command -v quartus_map`: not found.
- No Quartus installer artifacts found in the checked installer/installer-script locations.
- `tools/run_openfpga_genesis_analysis_only.sh` remained blocked on both hosts due unavailable `quartus_map`.
- No fitter/assembler/timing/bitstream steps were run.
- `third_party/openFPGA-Genesis` remained clean/read-only in this flow.
- `third_party/Genesis_MiSTer` remains reference-only.
- Sega CD/32X remain excluded.
- Added blocker documentation:
  - `docs/TASK7A_QUARTUS_ANALYSIS_RUN_STATUS.md`
  - `docs/OPENFPGA_GENESIS_FIRST_ANALYSIS_ERRORS.md`

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

- Quartus toolchain remains unavailable on the NAS host build path.
- No `Genesis_MiSTer` or Sega-CD/32X runtime activation yet.
- No full Quartus run, fitter, assembler, or timing pass yet.

## Task 6Y status

- Task 6X was sanitized instead of discarded.
- `quartus/files_openfpga_genesis_runtime.candidate.qsf` now uses upstream openFPGA assumptions (`apf_top`, `5CEBA4F23C8`) and keeps planning-only intent.
- Candidate source-plan checks were regenerated and kept non-active.
- OpenFPGA source lane is still planning/inactive: no Quartus run, no host-per-read ROM changes, no Genesis-MiSTer activation.
- Remaining blocker is still toolchain availability on NAS.

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
