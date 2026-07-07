# Task 6M: No-Quartus Genesis Runtime Static Integration Sprint

## Why this task exists
Quartus is still unavailable in this host, so this task advances Genesis runtime integration safely without launching Quartus. It replaces the previous tiny document-only pass with concrete static inspection artifacts, candidate source manifests, and a static lint-probe workflow.

## Scope (satisfying requested 6M objectives)
1. Inspect `third_party/Genesis_MiSTer/rtl/system.sv` and collect static interface metadata.
2. Compare APF wrapper/runtime interfaces (`apf/apf_genesis_base.sv`, `apf/src/fpga/core/core_top.v`) and capture mismatches in report form.
3. Run dependency scan for static transitive evidence.
4. Build candidate source manifests for one-pass future activation.
5. Add a no-Quartus lint probe script.
6. Keep all runtime activation candidate-only.

## What changed
- Created static artifact set:
  - `docs/TASK6M_NO_QUARTUS_GENESIS_RUNTIME_INTEGRATION_SPRINT.md`
  - `docs/NO_QUARTUS_GENESIS_RUNTIME_STATIC_REPORT.md`
  - `docs/GENESIS_RUNTIME_CANDIDATE_SOURCES.md`
  - `docs/APF_TO_GENESIS_INTERFACE_REVIEW.md`
  - `docs/NO_QUARTUS_LINT_PROBE_RESULT.md`
- Created candidate artifacts:
  - `quartus/files_genesis_runtime.candidate.qsf`
  - `apf/src/fpga/filelists/genesis_runtime_candidate.f`
- Created no-Quartus probe helper:
  - `tools/run_no_quartus_runtime_lint_probe.sh`
- Updated planning/status documents:
  - `docs/REPO_STATUS.md`
  - `docs/NEXT_ACTIVATION_PATH.md`
  - `docs/APF_PROJECT_VALIDATION_STEPS.md`
  - `docs/QUARTUS_ANALYSIS_BLOCKER_CLASSIFICATION.md`

## Runtime and APF constraints retained
- Candidate artifacts are planning only; no files are active in Quartus compile paths yet.
- Imported runtime remains read-only in `third_party/Genesis_MiSTer`.
- No real runtime code changes are introduced in `apf_genesis_base` or `core_top`.
- No Sega CD, no 32X, no APF packaging outputs.
- No Quartus compile, synthesis, fitter, timing, or assembler invocation.

## Current outcome
- `system.sv` was inspected for ports and assumptions.
- Static scan executed and captured into report.
- No supported lint/simulation tools (`verilator` or `iverilog`) are available in this environment, so lint remains advisory.
- Quartus remains unavailable; runtime compile activation remains paused.

## Why candidates are not active
- There is no verified toolchain proof (`quartus_map`) yet.
- Candidate manifests require compile-time confirmation before activation.
- Mixed-language and APF runtime integration correctness still need a controlled Quartus-capable compile loop.

## Next task
Task 6N should implement first real wrapper cleanup items from interface review, without activating Quartus runtime sources.
