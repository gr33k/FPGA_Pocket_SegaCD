# Next activation path after Task 7K

## Current task status

- Task 7K is complete: warning sources were reviewed against upstream openFPGA-Genesis source text with connectivity-capture/runner check updates in place.
- Current gate decision remains: `REVIEW_WARNINGS_FIRST`.
- Current blocker: warning class `12241` (connectivity summary class) and class `10259` (SDRAM constant-width/default math) remain needs-more-review without local Quartus connectivity details.

## Why this branch stays blocked

- `tools/review_openfpga_genesis_warning_sources.sh` confirms many high-volume warnings are intentional placeholders in the current scaffold lane.
- The lane still needs a real analysis run in a Quartus-capable environment to capture connectivity details and confirm `12241` context before fitter transition.

## Action before moving on

- Run connectivity-capable analysis in an environment with Quartus (`tools/docker_run_openfpga_genesis_analysis_prebuilt.sh` or local Quartus path).
- Confirm `docs/OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt` contains parseable connectivity/driver evidence instead of the placeholder fallback message.
- Re-run:
  - `tools/classify_openfpga_genesis_analysis_warnings.sh`
  - `tools/review_openfpga_genesis_warning_sources.sh`
  - `tools/check_openfpga_genesis_analysis_runner.sh`
- Only after `OPENFPGA_GENESIS_FITTER_READINESS_GATE.md` becomes `READY_FOR_FITTER_GATE` should a controlled fitter-only task be scheduled.
