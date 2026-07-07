# Task 6I: Local Quartus Toolchain Setup

## Why this task exists

- Task 6G-6H found the blocker as `TOOLCHAIN_UNAVAILABLE`.
- Quartus analysis has not run because `quartus_map` was not discoverable by the analysis flow.
- This task introduces a safe local discovery validation path before changing active source behavior.

## Why the blocker is `TOOLCHAIN_UNAVAILABLE`

- The current result file shows no executable `quartus_map` candidate was found.
- Without toolchain discovery, `analysis_and_elaboration` cannot execute.
- This is an environment/tooling issue, not a verified design bug.

## Why no runtime activation happens yet

- Runtime activation is intentionally deferred until toolchain discovery succeeds.
- Advancing runtime activation without discovery would create false compile signals.
- The APF scaffold stays active-only and advisory.

## Why this task validates path only

- Validation does **not** run Quartus analysis, synthesis, fitter, assembler, timing, or packaging.
- It only confirms whether `quartus_map` can be found and whether `quartus_map --version` succeeds.
- This keeps the milestone deterministic and low risk.

## Read-only and feature constraints

- `third_party/Genesis_MiSTer` remains read-only.
- Sega-CD and 32X remain intentionally excluded.
- No memory-controller integration is activated in this task.

## Expected validation outputs

- `docs/QUARTUS_TOOLCHAIN_VALIDATION_RESULT.md` is produced.
- Existing advisory statuses are updated (`QUARTUS_TOOLCHAIN_DISCOVERY_NOTES`, `QUARTUS_ANALYSIS_BLOCKER_CLASSIFICATION`, `NEXT_ACTIVATION_PATH`, validation workflow docs).
- `docs/QUARTUS_ANALYSIS_ONLY_RESULT.md` may be updated only for known validation context.

## What Task 6J should do next

- If validation **fails**, stop source activation and document exact local install/path action.
- If validation **passes**, run `tools/run_quartus_analysis_only_if_available.sh` and classify first real analysis results in Task 6J.
