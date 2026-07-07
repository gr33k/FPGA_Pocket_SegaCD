# Next activation path after Task 6Q

## Task 7A status (current lane blocker)

Task 7A confirmed the repository is now blocked by Quartus availability, not runner safety.

## Task 6Z status (historical)

Task 6Z added a Quartus-gated analysis-only runner for the `openFPGA-Genesis` lane.

Task 6ZA finished that runner safety cleanup:

- `tools/run_openfpga_genesis_analysis_only.sh` now treats `third_party/openFPGA-Genesis` as read-only input and always runs Quartus in:
  - `build/openfpga_genesis_analysis_work/src/fpga`
- `tools/check_openfpga_genesis_analysis_runner.sh` verifies:
  - no `rm -rf` against `UPSTREAM_DIR`
  - no `cd` into `UPSTREAM_DIR` for Quartus execution
  - no forbidden Quartus invocations (`quartus_fit/asm/sta/cpf`)
  - use of `build/openfpga_genesis_analysis_work`

Current behavior:

- `ap_core` / `apf_top` assumptions are still sourced from `third_party/openFPGA-Genesis/src/fpga/ap_core.qsf`.
- Runner status is tracked in `docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md`.
- Runner check report is tracked in `docs/OPENFPGA_GENESIS_ANALYSIS_RUNNER_CHECK.md`.
- `docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt` is generated if Quartus runs.
- `third_party/openFPGA-Genesis` remains read-only.

Blocking condition remains:

- `quartus_map` is not available on local host or NAS.
- The next run should stay analysis-only and must not run fitter/assembler/timing/bitstream generation.

Next:

1. Install or restore Quartus Lite (or place a verified installer into the documented NAS/docker flow), then export `quartus_map` into PATH.
2. Rerun `./tools/run_openfpga_genesis_analysis_only.sh`.
3. Keep this task at analysis/elaboration only until source closure is clear.
4. If analysis fails, classify first errors under `docs/OPENFPGA_GENESIS_FIRST_ANALYSIS_ERRORS.md`.
5. Continue staged package/SD host workflow only after the first analysis/elaboration pass is complete.

Current milestone target remains blocked by missing local Quartus execution, so we
keep this stage as package/layout scaffolding with an explicit host handoff.

## Immediate next steps (once Quartus-capable host is available)

1. Validate skeleton check remains PASS:
   - `tools/check_openfpga_package_skeleton.sh`
2. Run dry-run Pocket SD staging check:
   - `DRY_RUN=1 tools/stage_pocket_sd_skeleton.sh`
   - `POCKET_SD_ROOT=/Volumes/POCKET DRY_RUN=1 tools/stage_pocket_sd_skeleton.sh`
3. Run deterministic package copy and staged check when ready:
   - `POCKET_SD_ROOT=/Volumes/POCKET DRY_RUN=0 tools/stage_pocket_sd_skeleton.sh`
   - `POCKET_SD_ROOT=/Volumes/POCKET tools/check_pocket_sd_staging.sh`
4. Run external Quartus handoff and capture first analysis/elaboration result:
   - `tools/check_genesis_only_project_flow.sh`
   - `tools/validate_local_quartus_toolchain.sh`
   - `tools/run_quartus_analysis_only_if_available.sh`
   - use `docs/QUARTUS_BUILD_HOST_HANDOFF.md` before host transfer.
5. Add deterministic package copy step from `apf/` sources into
   `openfpga/FPGA_Pocket_SegaCD/apf/` for release packaging.
6. Add Quartus build/project hook to emit expected outputs into
   `openfpga/FPGA_Pocket_SegaCD/build/` (still no generated outputs committed
   until green-lit).
7. Restore/extend source-closure docs with exact manifest after real compile pass.

## Task 6S to 6T handoff

1. Use Docker workflow on Fedora NAS:
   - `tools/check_quartus_docker_workflow.sh`
   - `tools/run_quartus_docker_dryrun.sh`
   - `docs/FEDORA_NAS_DOCKER_QUARTUS_WORKFLOW.md`
2. Validate toolchain path and run analysis/elaboration only from that host.
3. Capture first Quartus analysis errors and resume according to Task 6T/6L guidance.

## Task 6U next activation path

Main implementation path pivots to Pocket-native Genesis.

Next task after 6U:
- decide whether to fork `opengateware/openFPGA-Genesis` directly, vendor a source snapshot with attribution, or wrap it as a submodule build source
- preserve attribution and license notices
- avoid editing upstream submodule files directly
- get Genesis-only building as close to upstream Pocket Genesis as possible
- no Sega CD or 32X until Genesis boots

The NAS Docker/Quartus path remains hard-stopped until a Quartus Lite Linux installer is available.

## Task 6V target follow-on

After this strategy lock:

1. Add/pin `third_party/openFPGA-Genesis` as the single upstream runtime source lane.
2. Keep `third_party/Genesis_MiSTer` as reference-only and non-active.
3. Rebuild the runtime-active source manifest from openFPGA core paths.
4. Run Quartus analysis/elaboration against the new active lane only once toolchain is available.

## Task 6W immediate follow-on

1. Keep `third_party/openFPGA-Genesis` as the active implementation lane.
2. Keep `third_party/Genesis_MiSTer` reference-only.
3. Build the source activation plan using:
   - `docs/OPENFPGA_GENESIS_SOURCE_MANIFEST.md`
   - `docs/OPENFPGA_GENESIS_INTEGRATION_DELTA.md`
4. Do not activate Sega CD or 32X in this lane.
5. After Quartus installer is staged on NAS, run analysis/elaboration only on the
   openFPGA-Genesis path and classify first-pass failures.

## Task 6Y immediate follow-on (sanity-fixed lane only)

1. Keep candidate QSF planning aligned to upstream `ap_core.qsf` assumptions:
   - `TOP_LEVEL_ENTITY apf_top`
   - `DEVICE 5CEBA4F23C8`
2. Keep `files_openfpga_genesis_runtime.candidate.qsf` passive (no synthesis entry).
3. Do not activate `Genesis_MiSTer`, Sega CD, or 32X.
4. Re-run checkers on NAS and confirm no stale environment-specific report paths remain.
5. Next real blocker handling once checks are green: Quartus installer availability and first real analysis/elaboration errors.

## Hard constraints

- No Sega-CD/32X at this stage.
- No save state support yet.
- No host-per-read ROM streaming.
