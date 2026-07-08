# openFPGA-Genesis fitter-readiness gate (smoke posture)

Generated: 2026-07-08 08:00:00 UTC

## Analysis status

- Status: analysis complete and successful
- Errors: `0`
- Warnings: `72`
- Quartus version: `Quartus Prime Lite Edition 19.1.0`
- Quartus image path used for analysis lane: `theypsilon/quartus-lite-c5:19.1-heavy`

## Current warning triage result

- Warning summary file: `docs/OPENFPGA_GENESIS_ANALYSIS_WARNING_SUMMARY.md`
- Fitter-readiness recommendation from classifier: `REVIEW_WARNINGS_FIRST`

## Current gate decision

- **No fitter run yet**
- **No assembler run yet**
- **No timing analysis run yet**
- **No bitstream generated yet**
- `tools/classify_openfpga_genesis_analysis_warnings.sh` marks remaining warning set as needing review before fitter.
- Gate is therefore: **not yet ready** for the controlled fitter-only gate.

## Conditions to run a controlled fitter-only gate next

1. `tools/classify_openfpga_genesis_analysis_warnings.sh` classification remains `READY_FOR_FITTER_GATE`.
2. Warning set does not include a class marked `likely fitter blocker`.
3. No warning category is re-classified as blocking runtime semantics before fitter.
4. `third_party/` stays unchanged and not used as the active scaffold edit path.
5. Analyzer output is still fresh for the same source set in `docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt`.

## Operational constraints

- Keep generated fitter outputs in non-tracked paths.
- Capture fitter logs and outputs in the project docs/checker path when a fitter gate is intentionally run.
- If fitter emits new warnings, classification must be re-run before continuing.
- This gate applies only to analysis safety and does not imply emulation correctness.

## Explicit safety reminder

- This milestone remains Genesis-only.
- Sega-CD, 32X, save states, and host-per-read ROM streaming remain deferred.
