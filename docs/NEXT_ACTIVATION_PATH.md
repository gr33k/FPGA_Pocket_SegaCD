# Next activation path after Task 6Q

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

## Hard constraints

- No Sega-CD/32X at this stage.
- No save state support yet.
- No host-per-read ROM streaming.
