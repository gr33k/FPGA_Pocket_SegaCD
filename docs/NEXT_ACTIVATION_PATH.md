# Next activation path after Task 7R

## Current milestone status

- Task 7R completed: post-fitter checker false-negative and warning-class fixes are in place.
- Current fitter smoke check: `docs/OPENFPGA_GENESIS_FITTER_SMOKE_CHECK.md` -> `Status: pass`, `Result: PASS`, `FITTER_SMOKE_PASS`.
- Current post-fitter review check: `docs/OPENFPGA_GENESIS_POST_FITTER_REVIEW_CHECK.md` -> `Status: pass`, `Result: PASS`.
- Current gate decision: `REVIEW_FITTER_WARNINGS_FIRST`.
- Host-per-read ROM streaming is still explicitly forbidden.
- No fitter/assembler/timing/bitstream task was run in this milestone.
- This still does not prove Pocket boot or runtime correctness.

## Disposition snapshot

- Warning summary totals now show:
  - `needs review before timing gate: 119`
  - `safe / known inherited: 76`
  - `accepted smoke-only risk: 14`
  - `unknown: 0`
- `Task 7R` normalized `RST port on the PLL...` warnings into `PLL_RESET_NOT_CONNECTED` for explicit review.
- `docs/OPENFPGA_GENESIS_TIMING_REVIEW_BLOCKER_ORDER.md` captures the prioritized timing-review closure list.
- No hard map/fitter or analyzer exit blockers are active.

## Next task (timing-review closure prep)

- Continue `REVIEW_FITTER_WARNINGS_FIRST` by addressing highest-priority classes first in:
  - `docs/OPENFPGA_GENESIS_TIMING_REVIEW_BLOCKER_ORDER.md`
  - `docs/OPENFPGA_GENESIS_FITTER_UNKNOWN_WARNING_REVIEW.md`
  - `docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md`
  - `docs/OPENFPGA_GENESIS_POST_FITTER_GATE.md`
- Re-run `tools/review_openfpga_genesis_fitter_unknown_warnings.sh` and `tools/classify_openfpga_genesis_fitter_smoke_warnings.sh` after any source/port assignment edits.

Constraints for next task:

- Do not run assembler, timing analysis, or bitstream generation.
- Do not claim runtime correctness or Pocket boot at the end of the task.
- Capture fitter logs and cleanup artifacts after any script updates.
- Continue to avoid Sega-CD, 32X, save-state, and host-per-read ROM streaming paths.

## Blockers now removed

- No hard Quartus assembler/timing/bitstream blockers remain from fit/tool exit status.
- Timing-review caution classes remain active and must be resolved or justified before timing-focused gate movement.
