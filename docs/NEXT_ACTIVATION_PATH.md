# Next Activation Path (Task 6M onwards)

This document defines the safe next-step branch after the current analysis blocker classification.

## Selected branch

### Branch A: TOOLCHAIN_UNAVAILABLE (Quartus lane)

- **Condition:** `quartus_map` not discoverable; analysis-only not run.
- **Decision:** Do not activate runtime source lists yet. Do not claim synthesis readiness.
- **Why this branch:** The latest result file shows no `quartus_map` command execution; only advisory preflight reporting is available.
- **Current action:** Task 6J re-ran local Quartus validation and still did not discover `quartus_map`; keep project activation paused at current skeleton state.
- **Next action:** run local Quartus toolchain validation via `tools/validate_local_quartus_toolchain.sh` after installing/updating Quartus and keep project activation paused while blocked.

### Validation gate for Branch A

- If validation returns **PASS**, the safe next step is to rerun `tools/run_quartus_analysis_only_if_available.sh`.
- If validation returns **FAIL**, keep Branch A and document the exact path/install fix.

### Branch A2: NO_QUARTUS_STATIC_PREP

- **Condition:** `quartus_map` unavailable and no local path available for analysis runs.
- **Purpose:** continue static preparation with dependency reports/candidate lists only.
- **Decision:** keep compile-unsafe runtime expansion paused, while allowing controlled source-pool promotion and status tracking.
- **Allowed:** manifest drafts, source scans, status updates, and static gating notes.
- **Disallowed:** adding `files_genesis_runtime.candidate.qsf` to active project paths; no runtime compile or synthesis attempts.

## Branch A2 execution rules
- `quartus/files_genesis_runtime.qsf` remains non-authoritative until Quartus validation, but now contains a first active-style Genesis-only source start set.
- `quartus/files_genesis_runtime.candidate.qsf` is allowed as planning-only artifact.
- `Task 6O`: promote only high-confidence Genesis-only sources, keep VHDL/mixed-language and excluded stacks deferred.

## Alternative branches (deferred until preconditions change)

### Branch B: EXPECTED_NOT_YET_ACTIVE_RUNTIME_ERROR
- Activate only `third_party/Genesis_MiSTer/rtl/system.sv` in runtime source list, then rerun analysis-only later.

### Branch C: MISSING_GENESIS_RUNTIME_DEPENDENCY
- Add only confirmed first-pass dependency files to `files_genesis_runtime.qsf`.

### Branch D: CONSTRAINT_OR_PROJECT_SETUP_ERROR
- Add minimal project/device/constraint planning only, without synthesis.

### Branch E: MIXED_LANGUAGE_OR_VHDL_FLOW_ERROR
- Plan required mixed-language/VHDL handling before runtime activation expansion.

## Safe milestone rule

- This branch is **documentation and status only** and does not modify runtime behavior.
- Genesis_MiSTer remains imported/read-only for now.
- No Sega-CD / no 32X / no memory-controller / no APF packaging generation is introduced.

## Task 6P should be

- Toolchain-local setup and validation documentation, plus a re-run strategy for `tools/run_quartus_analysis_only_if_available.sh` once `quartus_map` is discoverable.
- Branch A documents that this is a local toolchain setup and validation task; runtime activation is still paused until the validation and a rerun are completed.
- Task 6O added the controlled Genesis-only runtime source promotion and created `GENESIS_ONLY` tracking docs.
- On PASS of local toolchain+analysis, Task 6P should classify first errors and promote only by evidence.
