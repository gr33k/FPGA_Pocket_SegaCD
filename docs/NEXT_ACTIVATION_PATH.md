# Next Activation Path (Task 6G-6H)

This document defines the safe next-step branch after the current analysis blocker classification.

## Selected branch

### Branch A: TOOLCHAIN_UNAVAILABLE

- **Condition:** `quartus_map` not discoverable; analysis-only not run.
- **Decision:** Do not activate runtime source lists yet. Do not claim synthesis readiness.
- **Why this branch:** The latest result file shows no `quartus_map` command execution; only advisory preflight reporting is available.
- **Next action:** document local Quartus installation/path setup and keep project activation paused at current skeleton state.

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

## Task 6I should be

- Toolchain-local setup and validation documentation, plus a re-run strategy for `tools/run_quartus_analysis_only_if_available.sh` once `quartus_map` is discoverable.
