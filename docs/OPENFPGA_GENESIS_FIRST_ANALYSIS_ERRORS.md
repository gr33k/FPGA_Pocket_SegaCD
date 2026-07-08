# Task 7I / 7J / 7K / 7N: openFPGA Genesis analysis warning disposition and fitter gate

## Status

- Prebuilt-Docker analysis pass remains complete in documentation (last successful elaboration pass recorded in `docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_STATUS.md` where available).
- First-analysis warning classifier pass ran: `tools/classify_openfpga_genesis_analysis_warnings.sh`.
- Source warning review pass ran: `tools/review_openfpga_genesis_warning_sources.sh`.
- Current summary state:
  - Errors: `0`
  - Warnings: `72`
  - Gate: `READY_FOR_FITTER_GATE` (deep-capture-aware, not runtime proof).

## Key findings from source review

- Warning source evidence was reviewed from upstream openFPGA-Genesis files:
  - `third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`
  - `third_party/openFPGA-Genesis/src/fpga/core/core_bridge_cmd.v`
  - `third_party/openFPGA-Genesis/src/fpga/core/rtl/sdram.sv`
  - `third_party/openFPGA-Genesis/src/fpga/apf/build_id.mif`
- Placeholder-class warnings (10030, 10858, 10036, 10230, 10762, 113027, 113028, 287013) are not classified as hard blockers in this milestone.
- Warning class `12241` remains warning-only in this phase; it is classified as pre-fit smoke risk with explicit connectivity-capture caveat.
- Warning class `10259` is localized to SDRAM state math in `sdram.sv` and is accepted for smoke readiness with a later-review caveat if fitter/timing/runtime exposes concrete issues.

## Interpretation

- This is now the warning-disposition milestone; it permits the next controlled fitter-only smoke task only.
- No Sega-CD/32X path, no host-per-read streaming, no save-state path, and no ROM/CD/BIOS payload behavior was changed in this task.

## Next action

- Ready for controlled fitter-only smoke gate: `READY_FOR_FITTER_GATE`.
