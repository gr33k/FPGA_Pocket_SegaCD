# openFPGA Genesis Priority-1 clocking review
Generated: 2026-07-08 16:57:27 UTC
Inputs checked:
- docs/OPENFPGA_GENESIS_FITTER_WARNING_SUMMARY.md
- docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt
- docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt
- third_party/openFPGA-Genesis/src/fpga/ap_core.qsf
- third_party/openFPGA-Genesis/src/fpga/core/core_top.sv
- third_party/openFPGA-Genesis/src/fpga/apf/apf_top.v

Scope: Priority-1 clock/reset/pixel mux warnings only
No Quartus fitter/assembler/timing/bitstream steps are run by this script.

## Priority-1 instances
### NON_DEDICATED_CLOCK_ROUTING
- total instances: 1
- sample: - docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:Warning (16406): 1 global input pin(s) will use non-dedicated clock routing
- source: - 91:set_location_assignment PIN_H16 -to clk_74b
- status: needs review before timing gate
- next action: Review QSF clock assignment and pin plan with bridge/pll timing expectations.

### CODE_16406
- total instances: 1
- sample: - docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:Warning (16406): 1 global input pin(s) will use non-dedicated clock routing
- source: - 91:set_location_assignment PIN_H16 -to clk_74b
- status: needs review before timing gate
- next action: Review PLL/refclk placement for pocket clock intent before timing gate.

### CODE_16407
- total instances: 1
- sample: - docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:    Warning (16407): Source REFCLK I/O is not placed onto a dedicated REFCLK input pin for global clock driver bridge_spiclk~inputCLKENA0, placed at CLKCTRL_G8
- source: - 52:set_location_assignment PIN_T17 -to bridge_spiclk
- status: needs review before timing gate
- next action: Validate REFCLK and clock enable intent from timing review notes.

### CODE_19016
- total instances: 1
- sample: - docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:Warning (19016): Clock multiplexers are found and protected
- source: - 714:reg current_pix_clk;
- status: needs review before timing gate
- next action: Review pixel clock mux intent and gating before next timing step.

### CODE_19017
- total instances: 1
- sample: - docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:    Warning (19017): Found clock multiplexer core_top:ic|current_pix_clk File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 714
- source: - 714:reg current_pix_clk;
- status: needs review before timing gate
- next action: Confirm active pix clock branch and fanout mapping before timing cleanup.

### PLL_RESET_NOT_CONNECTED
- total instances: 7
- sample: - docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:Warning: RST port on the PLL is not properly connected on instance core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|general[1].gpll. The reset port on the PLL should be connected. If the PLL loses lock for any reason, you might need to manually reset the PLL in order to re-establish lock to the reference clock. File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/altera_pll.v Line: 749
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:Warning: RST port on the PLL is not properly connected on instance core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|general[1].gpll. The reset port on the PLL should be connected. If the PLL loses lock for any reason, you might need to manually reset the PLL in order to re-establish lock to the reference clock. File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/altera_pll.v Line: 749
- source: - source not found in checked docs/source snapshots
- status: needs review before timing gate
- next action: Document PLL reset plan and whether deterministic recovery is required for this milestone.

## Priority-1 aggregate
- total priority1 review items: 12
- required action before timing-gate handoff: still-review-required

## Guidance
- This document is clocking-focused and does not authorize fitter/assembler/bitstream.
- Do not claim runtime correctness from this review-only stage.
- Coordinate with source-level QSF/APF edits before any timing gate promotion.
