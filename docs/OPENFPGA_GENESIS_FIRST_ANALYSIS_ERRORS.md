# Task 7I / 7J / 7K: openFPGA Genesis first-analysis findings and warning source review

## Status

- Prebuilt-Docker analysis pass remains complete in documentation (last successful elaboration pass recorded in `docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md` where available).
- First-analysis warning classifier pass ran: `tools/classify_openfpga_genesis_analysis_warnings.sh`.
- Source warning review pass ran: `tools/review_openfpga_genesis_warning_sources.sh`.
- Current summary state:
  - Errors: `0`
  - Warnings: `72`
  - Gate: `REVIEW_WARNINGS_FIRST`.

## Key findings from source review

- Warning source evidence was reviewed from upstream openFPGA-Genesis files:
  - `third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`
  - `third_party/openFPGA-Genesis/src/fpga/core/core_bridge_cmd.v`
  - `third_party/openFPGA-Genesis/src/fpga/core/rtl/sdram.sv`
  - `third_party/openFPGA-Genesis/src/fpga/apf/build_id.mif`
- Placeholder-class warnings (10030, 10858, 10036, 10230, 10762, 113027, 113028, 287013) are not classified as hard blockers in this milestone.
- Warning class `12241` still has no direct line-level witness in current warnings summary and depends on connectivity evidence.
- Warning class `10259` is localized to SDRAM state math in `sdram.sv` and is kept as needs-more-review until memory-parameter intent is explicitly validated against the target build posture.

## Interpretation

- This remains a warning-intent review milestone; it does not claim fitter readiness or runtime readiness.
- No Sega-CD/32X path, no host-per-read streaming, no save-state path, and no ROM/CD/BIOS payload behavior was changed in this task.

## Next action

- Remain in `REVIEW_WARNINGS_FIRST` until connectivity report evidence is available and source-verified by a real Quartus analysis run on a host with Quartus available.
