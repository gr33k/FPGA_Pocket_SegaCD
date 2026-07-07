# APF project validation steps (Task 6C-6D milestone)

Before any real Quartus/openFPGA synthesis or packaging, run these checks.

## 1) Confirm required Quartus files exist

- `test -f quartus/FPGA_Pocket_SegaCD.qpf`
- `test -f quartus/FPGA_Pocket_SegaCD.qsf`
- `test -f quartus/FPGA_Pocket_SegaCD.sdc`
- `test -f quartus/files_apf_scaffold.qsf`
- `test -f quartus/files_genesis_runtime.qsf`
- `test -f quartus/files_constraints.qsf`

## 2) Confirm top-level active skeleton markers

For `quartus/FPGA_Pocket_SegaCD.qpf` and `quartus/FPGA_Pocket_SegaCD.qsf`, confirm they include:

- `ACTIVE SKELETON`
- `DO NOT RUN SYNTHESIS YET`
- `PROJECT STRUCTURE ONLY`
- `SOURCE LISTS ARE NOT ACTIVE YET`
- `NO BUILD OUTPUTS SHOULD BE GENERATED`

## 3) Confirm APF scaffold source list activation

For `quartus/files_apf_scaffold.qsf`, confirm:

- It includes only APF-owned files:
  - `../apf/src/fpga/core/core_top.v`
  - `../apf/src/fpga/core/rom_preload_ingress_stub.v`
  - `../apf/src/fpga/core/rom_local_service_stub.v`
  - `../apf/src/fpga/core/rom_tiny_local_ram_stub.v`
  - `../apf/apf_genesis_base.sv`
- It includes the markers:
  - `ACTIVE SCAFFOLD SOURCE LIST`
  - `DO NOT RUN SYNTHESIS YET`
  - `APF SCAFFOLD ONLY`
  - `GENESIS RUNTIME NOT ACTIVE YET`
- It does **not** include any third_party Genesis runtime files, simulation-only test files, or packaging targets.

## 4) Run preflight script before any future analysis attempt

- `chmod +x tools/preflight_quartus_analysis_only.sh`
- `tools/preflight_quartus_analysis_only.sh`
- Review [docs/QUARTUS_PREFLIGHT_CHECK_REPORT.md](docs/QUARTUS_PREFLIGHT_CHECK_REPORT.md).
- This preflight is advisory and does not run Quartus.

## 4a) Validate local Quartus toolchain

- `chmod +x tools/validate_local_quartus_toolchain.sh`
- `tools/validate_local_quartus_toolchain.sh`
- Review [docs/QUARTUS_TOOLCHAIN_VALIDATION_RESULT.md](docs/QUARTUS_TOOLCHAIN_VALIDATION_RESULT.md).
- Continue only if status is PASS.

## 5) Confirm runtime source lists are controlled

- `quartus/files_genesis_runtime.qsf` now contains a controlled Genesis-only active-start source list with clear include/defer markers.
- It includes `SEGA CD EXCLUDED`, `32X EXCLUDED`, and mixed-language dependencies as comments.

## 5a) Confirm Task 6M static-prep artifacts

- Review [docs/NO_QUARTUS_GENESIS_RUNTIME_STATIC_REPORT.md](docs/NO_QUARTUS_GENESIS_RUNTIME_STATIC_REPORT.md).
- Review [docs/GENESIS_RUNTIME_CANDIDATE_SOURCES.md](docs/GENESIS_RUNTIME_CANDIDATE_SOURCES.md) for ordered advisory entries.
- Review [docs/TASK6M_NO_QUARTUS_GENESIS_RUNTIME_INTEGRATION_SPRINT.md](docs/TASK6M_NO_QUARTUS_GENESIS_RUNTIME_INTEGRATION_SPRINT.md) for static-lane rules.
- Review [docs/GENESIS_ONLY_ACTIVE_BUILD_PATH_STATUS.md](docs/GENESIS_ONLY_ACTIVE_BUILD_PATH_STATUS.md) and [docs/GENESIS_ONLY_SOURCE_CLOSURE_REPORT.md](docs/GENESIS_ONLY_SOURCE_CLOSURE_REPORT.md) for current source-state and deferred blockers.
- Confirm `python3 tools/scan_verilog_deps.py --root . --entry third_party/Genesis_MiSTer/rtl/system.sv` is captured as static-only and succeeds.

## 6) Confirm constraint placeholder status

- `quartus/files_constraints.qsf` and `quartus/FPGA_Pocket_SegaCD.sdc` remain placeholders.
- Neither file contains active output/timing constraints for synthesis.

## 7) Confirm no forbidden synthesis families/features are present

- `grep -nE "Genesis.sv|sys/sys_top.v|ioctl|SegaCD|MegaCD|32X|save|psram|sdram|sram" quartus/*.qsf quartus/*.qpf quartus/*.sdc || true`

Expected: no prohibited features in active regions.

## 8) Confirm no generated outputs before and after any future Quartus command

- `test ! -e quartus/output_files`
- `test ! -e quartus/db`
- `test ! -e quartus/incremental_db`
- `test ! -e quartus/greybox_tmp`
- `test ! -e quartus/simulation`
- `test ! -e quartus/build`
- `test "$(find quartus -maxdepth 2 -type f \( -name '*.sof' -o -name '*.pof' -o -name '*.jic' -o -name '*.rpd' -o -name '*.rbf' -o -name '*.rbf_r' \) | wc -l)" = "0"`

## 8a) Confirm candidate vs active runtime filelist split

- Confirm `quartus/files_genesis_runtime.candidate.qsf` exists as static artifact:
  - `test -f quartus/files_genesis_runtime.candidate.qsf`
- Confirm active/runtime promotion is not mixed with the candidate file:
  - `grep -R "files_genesis_runtime.candidate.qsf" quartus/*.qsf quartus/*.qpf || true`
- Confirm planning header in candidate file:
  - `CANDIDATE ONLY - NOT ACTIVE`
  - `NO QUARTUS RUN REQUIRED`
  - `GENESIS RUNTIME STATIC PREP ONLY`
  - `DO NOT INCLUDE FROM ACTIVE PROJECT YET`
- Confirm `quartus/FPGA_Pocket_SegaCD.qsf` documents how to promote runtime list activation only from a Quartus-capable flow.

## 9) Confirm imported runtime remains read-only

- Imported `third_party/Genesis_MiSTer` is present and unchanged.
- `git status --short third_party/Genesis_MiSTer` remains clean.

## 10) Confirm task progression

- Task 6C-6D preflight and analysis command plan are in place.
- Task 6C-6E adds [tools/run_quartus_analysis_only_if_available.sh](tools/run_quartus_analysis_only_if_available.sh), which executes preflight and then analysis-only under tool availability checks.
- Review [docs/QUARTUS_ANALYSIS_ONLY_RESULT.md](docs/QUARTUS_ANALYSIS_ONLY_RESULT.md) after any attempt.
- Confirm generated outputs were cleaned and not committed.

## 11) Quartus analysis-only execution

- `chmod +x tools/run_quartus_analysis_only_if_available.sh`
- `tools/run_quartus_analysis_only_if_available.sh`
- Re-check output cleanliness:
  - `test ! -e quartus/output_files`
  - `test ! -e quartus/db`
  - `test ! -e quartus/incremental_db`
  - `test ! -e quartus/greybox_tmp`
  - `test ! -e quartus/simulation`
  - `test ! -e quartus/build`
  - `test ! -e quartus/output_files` (post-run)

- If `quartus_map` is not in PATH, set one of:
  - `export QUARTUS_MAP=/path/to/quartus_map`
  - `export QUARTUS_ROOTDIR=/path/to/quartus`
  - then run: `tools/run_quartus_analysis_only_if_available.sh`
- If validation and setup were completed, then rerun `tools/run_quartus_analysis_only_if_available.sh`.

- Review [docs/QUARTUS_ANALYSIS_ONLY_RESULT.md](docs/QUARTUS_ANALYSIS_ONLY_RESULT.md) after the run.

- Confirm generated outputs were not committed.

## 12) Confirm blocker classification before source activation

- Read [docs/QUARTUS_ANALYSIS_BLOCKER_CLASSIFICATION.md](docs/QUARTUS_ANALYSIS_BLOCKER_CLASSIFICATION.md) before deciding any runtime activation branch.

## 14) No-Quartus static integration checks

- Confirm static prep docs before any source activation:
  - [docs/NO_QUARTUS_GENESIS_RUNTIME_STATIC_REPORT.md](docs/NO_QUARTUS_GENESIS_RUNTIME_STATIC_REPORT.md)
  - [docs/APF_TO_GENESIS_INTERFACE_REVIEW.md](docs/APF_TO_GENESIS_INTERFACE_REVIEW.md)
  - [docs/NO_QUARTUS_LINT_PROBE_RESULT.md](docs/NO_QUARTUS_LINT_PROBE_RESULT.md)
- Confirm candidate-only files stay planning-only:
  - `apf/src/fpga/filelists/genesis_runtime_candidate.f`
  - `docs/GENESIS_RUNTIME_CANDIDATE_SOURCES.md`
  - `quartus/files_genesis_runtime.candidate.qsf`
- Confirm candidate source list is not active in Quartus skeleton files:
  - `grep -R "files_genesis_runtime.candidate.qsf" quartus/*.qsf quartus/*.qpf`
- Confirm no generated outputs are committed by this lane:
  - `find quartus -maxdepth 2 -type f \( -name '*.sof' -o -name '*.pof' -o -name '*.jic' -o -name '*.rpd' -o -name '*.rbf' -o -name '*.rbf_r' \) -print`
  - `test ! -e quartus/output_files`
  - `test ! -e quartus/db`
  - `test ! -e quartus/incremental_db`
  - `test ! -e quartus/greybox_tmp`
  - `test ! -e quartus/simulation`

## 13) Confirm selected next branch

- Read [docs/NEXT_ACTIVATION_PATH.md](docs/NEXT_ACTIVATION_PATH.md) and apply only the selected branch.
- Keep all non-Branch-A activations paused when Branch A (TOOLCHAIN_UNAVAILABLE) is in force.
