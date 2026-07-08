# openFPGA Genesis post-fitter warning summary
Generated: 2026-07-08 09:14:14 UTC
Source status: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docs/OPENFPGA_GENESIS_FITTER_SMOKE_STATUS.md

Map errors: 0
Map warnings: 201
Fitter errors: 0
Fitter warnings: 8

## Warning class summary
- CODE_10030 | count=13 | risk=safe / known inherited
  sample: Warning (10030): Net "rom_data2" at core_top.sv(870) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 870
- CODE_10036 | count=12 | risk=safe / known inherited
  sample: Warning (10036): Verilog HDL or VHDL warning at core_top.sv(454): object "cs_m30_map_enable" assigned a value but never read File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 454
- CODE_10230 | count=32 | risk=safe / known inherited
  sample: Warning (10230): Verilog HDL assignment warning at core_top.sv(460): truncated value with size 32 to match size of target (12) File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 460
- CODE_10259 | count=1 | risk=safe / known inherited
  sample: Warning (10259): Verilog HDL error at sdram.sv(82): constant value overflow File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/sdram.sv Line: 82
- CODE_10762 | count=4 | risk=safe / known inherited
  sample: Warning (10762): Verilog HDL Case Statement warning at core_top.sv(303): can't check case statement for completeness because the case expression has too many possible states File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 303
- CODE_10858 | count=5 | risk=safe / known inherited
  sample: Warning (10858): Verilog HDL warning at core_bridge_cmd.v(116): object host_4C used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 116
- CODE_113027 | count=2 | risk=safe / known inherited
  sample:     Warning (113027): Addresses ranging from 0 to 223 are not initialized File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/build_id.mif Line: 1
- CODE_113028 | count=1 | risk=safe / known inherited
  sample: Warning (113028): 253 out of 256 addresses are uninitialized. The Quartus Prime software will initialize them to "0". There are 2 warnings found, and 2 warnings are reported. File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/build_id.mif Line: 1
- CODE_12241 | count=1 | risk=safe / known inherited
  sample: Warning (12241): 48 hierarchies have connectivity warnings - see the Connectivity Checks report folder
- CODE_13009 | count=1 | risk=unknown
  sample: Warning (13009): TRI or OPNDRN buffers permanently enabled
- CODE_13010 | count=21 | risk=unknown
  sample:     Warning (13010): Node "mf_ddio_bidir_12:iscc|altddio_bidir:ALTDDIO_BIDIR_component|ddio_bidir_euo:auto_generated|tri_buf1a[3]" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/db/ddio_bidir_euo.tdf Line: 59
- CODE_13024 | count=1 | risk=unknown
  sample: Warning (13024): Output pins are stuck at VCC or GND
- CODE_13032 | count=1 | risk=unknown
  sample: Warning (13032): The following tri-state nodes are fed by constants
- CODE_13033 | count=5 | risk=unknown
  sample:     Warning (13033): The pin "cart_tran_bank0[4]" is fed by VCC File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 73
- CODE_13039 | count=1 | risk=unknown
  sample: Warning (13039): The following bidirectional pins have no drivers
- CODE_13040 | count=1 | risk=unknown
  sample:     Warning (13040): bidirectional pin "aux_sda" has no driver File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 208
- CODE_13410 | count=64 | risk=unknown
  sample:     Warning (13410): Pin "cart_tran_bank2_dir" is stuck at GND File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 58
- CODE_14284 | count=2 | risk=unknown
  sample: Warning (14284): Synthesized away the following node(s):
- CODE_14285 | count=2 | risk=unknown
  sample:     Warning (14285): Synthesized away the following RAM node(s):
- CODE_19016 | count=1 | risk=unknown
  sample: Warning (19016): Clock multiplexers are found and protected
- CODE_19017 | count=1 | risk=unknown
  sample:     Warning (19017): Found clock multiplexer core_top:ic|current_pix_clk File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 714
- CODE_21074 | count=1 | risk=unknown
  sample: Warning (21074): Design contains 8 input pin(s) that do not drive logic
- CODE_287013 | count=1 | risk=unknown
  sample: Warning (287013): Variable or input pin "outclock" is defined but never used. File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/db/dpram_f092.tdf Line: 34
- IGNORED_FAST_IO_WILDCARD | count=1 | risk=needs review before timing gate
  sample: Warning (176251): Ignoring some wildcard destinations of fast I/O register assignments
- INCOMPLETE_IO_ASSIGNMENTS | count=1 | risk=needs review before timing gate
  sample: Warning (15714): Some pins have incomplete I/O assignments. Refer to the I/O Assignment Warnings report for details
- IP_PLL_MEMORY_WARNING | count=13 | risk=safe / known inherited
  sample:         Warning (14320): Synthesized away node "core_top:ic|system:system|vdp:vdp|obj_cache:obj_cache|dpram_dif:ram3|altsyncram:altsyncram_component|altsyncram_o534:auto_generated|q_a[4]" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/db/altsyncram_o534.tdf Line: 184
- LOGICLOCK_LICENSE | count=1 | risk=accepted smoke-only risk
  sample: Warning (292013): Feature LogicLock is only available with a valid subscription license. You can purchase a software subscription to gain full access to this feature.
- NON_DEDICATED_CLOCK_ROUTING | count=1 | risk=needs review before timing gate
  sample: Warning (16406): 1 global input pin(s) will use non-dedicated clock routing
- NO_CODE_WARNING | count=2 | risk=unknown
  sample: Info: Quartus Prime Analysis & Synthesis was successful. 0 errors, 201 warnings
- NO_OUTPUT_ENABLE | count=1 | risk=needs review before timing gate
  sample: Warning (169064): Following 101 pins have no output enable or a GND or VCC output enable - later changes to this connectivity may change fitting results
- PIN_ASSIGNMENT_WARNING | count=9 | risk=needs review before timing gate
  sample:     Warning (15610): No output dependent on input pin "clk_74b" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 49
- PLACEMENT_ROUTING_WARNING | count=1 | risk=needs review before timing gate
  sample: Warning (170136): Design uses Placement Effort Multiplier = 4.0.  Using a Placement Effort Multiplier > 1.0 can increase processing time, especially when used during a second or third fitting attempt.
- PLL_RESET_NOT_CONNECTED | count=7 | risk=needs review before timing gate
  sample: Warning: RST port on the PLL is not properly connected on instance core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|general[1].gpll. The reset port on the PLL should be connected. If the PLL loses lock for any reason, you might need to manually reset the PLL in order to re-establish lock to the reference clock. File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/altera_pll.v Line: 749

## Risk totals
- blocks timing/assembler gate: 0
- needs review before timing gate: 21
- accepted smoke-only risk / safe inherited: 85
- unknown: 105

## Decision
decision=REVIEW_FITTER_WARNINGS_FIRST

- map errors: 0
- fitter errors: 0
- no Quartus run by this script; log-parsing only
