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
- Source review report: `docs/OPENFPGA_GENESIS_WARNING_SOURCE_REVIEW.md`
- Connectivity evidence file: `docs/OPENFPGA_GENESIS_CONNECTIVITY_WARNINGS.txt`
- Fitter-readiness recommendation from classifier + source review: `REVIEW_WARNINGS_FIRST`

## Current gate decision

- **No fitter run yet**
- **No assembler run yet**
- **No timing analysis run yet**
- **No bitstream generated yet**
- `tools/classify_openfpga_genesis_analysis_warnings.sh` and
  `tools/review_openfpga_genesis_warning_sources.sh` mark warning classes 10030/10858 as placeholder-like,
  but 10259 and 12241 remain **needs-more-review** until connectivity evidence is available and
  SDRAM constant-width intent is explicitly confirmed.
- Gate is therefore **not yet ready** for the controlled fitter-only gate: **REVIEW_WARNINGS_FIRST**.

## Conditions to run a controlled fitter-only gate next

1. `tools/classify_openfpga_genesis_analysis_warnings.sh` classification becomes `READY_FOR_FITTER_GATE`.
2. `tools/review_openfpga_genesis_warning_sources.sh` source evidence confirms:
   - warning code 12241 does not indicate a connectivity blocker
   - warning code 10259 is not a real fitter-blocking parameter-width issue for the target gate.
3. Warning set does not include any class marked as blocked.
4. No warning category is re-classified as blocking runtime semantics before fitter.
5. `third_party/` stays unchanged and not used as the active scaffold edit path.
6. Analyzer output is still fresh for the same source set in `docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt`.

## Operational constraints

- Keep generated fitter outputs in non-tracked paths.
- Capture fitter logs and outputs in the project docs/checker path when a fitter gate is intentionally run.
- If fitter emits new warnings, classification must be re-run before continuing.
- This gate applies only to analysis safety and does not imply emulation correctness.

## Explicit safety reminder

- This milestone remains Genesis-only.
- Sega-CD, 32X, save states, and host-per-read ROM streaming remain deferred.
