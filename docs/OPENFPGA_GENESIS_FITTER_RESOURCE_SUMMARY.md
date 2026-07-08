# openFPGA Genesis fitter resource summary
Generated: 2026-07-08 16:57:02 UTC

## Source files
- Map log: docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt
- Fit log: docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt

## Selected device context
    Info (12134): Parameter "intended_device_family" = "Cyclone V"

## Promoted/global clocks
37:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[0]~CLKENA0 with 11541 fanout uses global clock CLKCTRL_G10
38:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[1]~CLKENA0 with 113 fanout uses global clock CLKCTRL_G9
39:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[5]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G11
40:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[3]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G4
41:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[2]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G7
42:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[4]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G6
43:Info (11191): Automatically promoted 2 clocks (2 global)
44:    Info (11162): clk_74a~inputCLKENA0 with 1651 fanout uses global clock CLKCTRL_G5
45:    Info (11162): bridge_spiclk~inputCLKENA0 with 19 fanout uses global clock CLKCTRL_G8
47:Warning (16406): 1 global input pin(s) will use non-dedicated clock routing
48:    Warning (16407): Source REFCLK I/O is not placed onto a dedicated REFCLK input pin for global clock driver bridge_spiclk~inputCLKENA0, placed at CLKCTRL_G8

## Global clocks and I/O routing notes
47:Warning (16406): 1 global input pin(s) will use non-dedicated clock routing

## Memory block notes
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:29:Warning: RST port on the PLL is not properly connected on instance core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|general[1].gpll. The reset port on the PLL should be connected. If the PLL loses lock for any reason, you might need to manually reset the PLL in order to re-establish lock to the reference clock. File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/altera_pll.v Line: 749
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:34:Info (176045): Design uses memory blocks. Violating setup or hold times of memory block address registers for either read or write operations could cause memory contents to be corrupted. Make sure that all memory block address registers meet the setup and hold time requirements.
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:37:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[0]~CLKENA0 with 11541 fanout uses global clock CLKCTRL_G10
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:38:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[1]~CLKENA0 with 113 fanout uses global clock CLKCTRL_G9
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:39:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[5]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G11
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:40:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[3]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G4
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:41:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[2]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G7
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:42:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[4]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G6
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:68:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin} -divide_by 11 -multiply_by 175 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:69:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 22 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:70:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 11 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:71:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[5].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 220 -phase 90.00 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[5].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[5].gpll~PLL_OUTPUT_COUNTER|divclk}
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:72:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 176 -phase 90.00 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:73:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 176 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:74:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 220 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER|divclk}
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:80:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL  from: refclkin  to: fbclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:81:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:82:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_REFCLK_SELECT  from: clkin[0]  to: clkout
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:83:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:84:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:85:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:86:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:87:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[5].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:97:    Info (332111):    0.846 ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:98:    Info (332111):   18.624 ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:99:    Info (332111):    9.312 ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:100:    Info (332111):  148.994 ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:101:    Info (332111):  148.994 ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:102:    Info (332111):  186.243 ic|mp1|mf_pllbase_inst|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER|divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:103:    Info (332111):  186.243 ic|mp1|mf_pllbase_inst|altera_pll_i|general[5].gpll~PLL_OUTPUT_COUNTER|divclk
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:108:    Extra Info (176218): Packed 17 registers into blocks of type Block RAM
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:223:    Info (169065): Pin sram_dq[0] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:224:    Info (169065): Pin sram_dq[1] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:225:    Info (169065): Pin sram_dq[2] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:226:    Info (169065): Pin sram_dq[3] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:227:    Info (169065): Pin sram_dq[4] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:228:    Info (169065): Pin sram_dq[5] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:229:    Info (169065): Pin sram_dq[6] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:230:    Info (169065): Pin sram_dq[7] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:231:    Info (169065): Pin sram_dq[8] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:232:    Info (169065): Pin sram_dq[9] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:233:    Info (169065): Pin sram_dq[10] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:234:    Info (169065): Pin sram_dq[11] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:235:    Info (169065): Pin sram_dq[12] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:236:    Info (169065): Pin sram_dq[13] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:237:    Info (169065): Pin sram_dq[14] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:238:    Info (169065): Pin sram_dq[15] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 176
docs/OPENFPGA_GENESIS_FITTER_SMOKE_FIT_LOG.txt:248:    Info: Peak virtual memory: 3969 megabytes
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:190:Info (12021): Found 1 design units, including 1 entities, in source file core/rtl/sdram.sv
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:191:    Info (12023): Found entity 1: sdram File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/sdram.sv Line: 21
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:220:    Info (12022): Found design unit 3: DualPortRAM-SYN File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/bram.vhd Line: 133
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:226:    Info (12023): Found entity 3: DualPortRAM File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/bram.vhd Line: 111
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:250:Info (12021): Found 1 design units, including 1 entities, in source file core/mf_pllbase.v
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:251:    Info (12023): Found entity 1: mf_pllbase File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/mf_pllbase.v Line: 8
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:252:Info (12021): Found 1 design units, including 1 entities, in source file core/mf_pllbase/mf_pllbase_0002.v
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:253:    Info (12023): Found entity 1: mf_pllbase_0002 File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/mf_pllbase/mf_pllbase_0002.v Line: 2
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:306:Info (12128): Elaborating entity "altsyncram" for hierarchy "core_top:ic|core_bridge_cmd:icb|mf_datatable:idt|altsyncram:altsyncram_component" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/mf_datatable.v Line: 100
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:307:Info (12130): Elaborated megafunction instantiation "core_top:ic|core_bridge_cmd:icb|mf_datatable:idt|altsyncram:altsyncram_component" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/mf_datatable.v Line: 100
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:308:Info (12133): Instantiated megafunction "core_top:ic|core_bridge_cmd:icb|mf_datatable:idt|altsyncram:altsyncram_component" with the following parameter: File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/mf_datatable.v Line: 100
docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:317:    Info (12134): Parameter "lpm_type" = "altsyncram"

## Resource utilization
1958:Info (21057): Implemented 25664 device resources after synthesis - the final resource count might be different
1959:    Info (21058): Implemented 13 input pins
1960:    Info (21059): Implemented 94 output pins
1961:    Info (21060): Implemented 121 bidirectional pins
1962:    Info (21061): Implemented 24370 logic cells
1963:    Info (21064): Implemented 1029 RAM segments
1964:    Info (21065): Implemented 6 PLLs
1965:    Info (21062): Implemented 12 DSP elements

## Pin / I/O assignment warnings
33:Warning (15714): Some pins have incomplete I/O assignments. Refer to the I/O Assignment Warnings report for details
47:Warning (16406): 1 global input pin(s) will use non-dedicated clock routing
48:    Warning (16407): Source REFCLK I/O is not placed onto a dedicated REFCLK input pin for global clock driver bridge_spiclk~inputCLKENA0, placed at CLKCTRL_G8
49:        Info (179012): Refclk input I/O pad bridge_spiclk is placed onto PIN_T17
68:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin} -divide_by 11 -multiply_by 175 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}
80:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL  from: refclkin  to: fbclk
97:    Info (332111):    0.846 ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]
105:Warning (176251): Ignoring some wildcard destinations of fast I/O register assignments
106:    Info (176252): Wildcard assignment "Fast Output Register=ON" to "dram_*" matches multiple destination nodes -- some destinations are not valid targets for this assignment
110:    Extra Info (176218): Packed 16 registers into blocks of type I/O input buffer
111:    Extra Info (176218): Packed 52 registers into blocks of type I/O output buffer
144:Warning (169064): Following 101 pins have no output enable or a GND or VCC output enable - later changes to this connectivity may change fitting results
145:    Info (169065): Pin scal_vs has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 112
146:    Info (169065): Pin scal_hs has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 113
147:    Info (169065): Pin scal_vid[0] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
148:    Info (169065): Pin scal_vid[1] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
149:    Info (169065): Pin scal_vid[2] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
150:    Info (169065): Pin scal_vid[3] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
151:    Info (169065): Pin scal_vid[4] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
152:    Info (169065): Pin scal_vid[5] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
153:    Info (169065): Pin scal_vid[6] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
154:    Info (169065): Pin scal_vid[7] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
155:    Info (169065): Pin scal_vid[8] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
156:    Info (169065): Pin scal_vid[9] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
157:    Info (169065): Pin scal_vid[10] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
158:    Info (169065): Pin scal_vid[11] has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 108
159:    Info (169065): Pin scal_clk has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 109
160:    Info (169065): Pin scal_de has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 110
161:    Info (169065): Pin scal_skip has a permanently enabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 111
162:    Info (169065): Pin cart_tran_bank2[0] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 57
163:    Info (169065): Pin cart_tran_bank2[1] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 57
164:    Info (169065): Pin cart_tran_bank2[2] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 57
165:    Info (169065): Pin cart_tran_bank2[3] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 57
166:    Info (169065): Pin cart_tran_bank2[4] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 57
167:    Info (169065): Pin cart_tran_bank2[5] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 57
168:    Info (169065): Pin cart_tran_bank2[6] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 57
169:    Info (169065): Pin cart_tran_bank2[7] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 57
170:    Info (169065): Pin cart_tran_bank3[0] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 61
171:    Info (169065): Pin cart_tran_bank3[1] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 61
172:    Info (169065): Pin cart_tran_bank3[2] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 61
173:    Info (169065): Pin cart_tran_bank3[3] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 61
174:    Info (169065): Pin cart_tran_bank3[4] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 61
175:    Info (169065): Pin cart_tran_bank3[5] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 61
176:    Info (169065): Pin cart_tran_bank3[6] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 61
177:    Info (169065): Pin cart_tran_bank3[7] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 61
178:    Info (169065): Pin cart_tran_bank1[0] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 65
179:    Info (169065): Pin cart_tran_bank1[1] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 65
180:    Info (169065): Pin cart_tran_bank1[2] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 65
181:    Info (169065): Pin cart_tran_bank1[3] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 65
182:    Info (169065): Pin cart_tran_bank1[4] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 65
183:    Info (169065): Pin cart_tran_bank1[5] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 65
184:    Info (169065): Pin cart_tran_bank1[6] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 65
185:    Info (169065): Pin cart_tran_bank1[7] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 65
186:    Info (169065): Pin cart_tran_pin31 has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 86
187:    Info (169065): Pin port_tran_si has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 96
188:    Info (169065): Pin port_tran_so has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 98
189:    Info (169065): Pin port_tran_sck has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 100
190:    Info (169065): Pin port_tran_sd has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 102
191:    Info (169065): Pin cram0_dq[0] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
192:    Info (169065): Pin cram0_dq[1] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
193:    Info (169065): Pin cram0_dq[2] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
194:    Info (169065): Pin cram0_dq[3] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
195:    Info (169065): Pin cram0_dq[4] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
196:    Info (169065): Pin cram0_dq[5] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
197:    Info (169065): Pin cram0_dq[6] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
198:    Info (169065): Pin cram0_dq[7] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
199:    Info (169065): Pin cram0_dq[8] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
200:    Info (169065): Pin cram0_dq[9] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
201:    Info (169065): Pin cram0_dq[10] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
202:    Info (169065): Pin cram0_dq[11] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
203:    Info (169065): Pin cram0_dq[12] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
204:    Info (169065): Pin cram0_dq[13] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
205:    Info (169065): Pin cram0_dq[14] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
206:    Info (169065): Pin cram0_dq[15] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 134
207:    Info (169065): Pin cram1_dq[0] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 147
208:    Info (169065): Pin cram1_dq[1] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 147
209:    Info (169065): Pin cram1_dq[2] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 147
210:    Info (169065): Pin cram1_dq[3] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 147
211:    Info (169065): Pin cram1_dq[4] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 147
212:    Info (169065): Pin cram1_dq[5] has a permanently disabled output enable File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/apf_top.v Line: 147

## PLL / IP warning lines
29:Warning: RST port on the PLL is not properly connected on instance core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|general[1].gpll. The reset port on the PLL should be connected. If the PLL loses lock for any reason, you might need to manually reset the PLL in order to re-establish lock to the reference clock. File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/altera_pll.v Line: 749
32:Warning (292013): Feature LogicLock is only available with a valid subscription license. You can purchase a software subscription to gain full access to this feature.
37:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[0]~CLKENA0 with 11541 fanout uses global clock CLKCTRL_G10
38:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[1]~CLKENA0 with 113 fanout uses global clock CLKCTRL_G9
39:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[5]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G11
40:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[3]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G4
41:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[2]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G7
42:    Info (11162): core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|outclk_wire[4]~CLKENA0 with 1 fanout uses global clock CLKCTRL_G6
67:Info (332110): Deriving PLL clocks
68:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin} -divide_by 11 -multiply_by 175 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}
69:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 22 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}
70:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 11 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}
71:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[5].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 220 -phase 90.00 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[5].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[5].gpll~PLL_OUTPUT_COUNTER|divclk}
72:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 176 -phase 90.00 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}
73:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 176 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}
74:    Info (332110): create_generated_clock -source {ic|mp1|mf_pllbase_inst|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]} -divide_by 220 -duty_cycle 50.00 -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER|divclk} {ic|mp1|mf_pllbase_inst|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER|divclk}
80:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL  from: refclkin  to: fbclk
81:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
82:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_REFCLK_SELECT  from: clkin[0]  to: clkout
83:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
84:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
85:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
86:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
87:    Info (332098): Cell: ic|mp1|mf_pllbase_inst|altera_pll_i|general[5].gpll~PLL_OUTPUT_COUNTER  from: vco0ph[0]  to: divclk
97:    Info (332111):    0.846 ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]
98:    Info (332111):   18.624 ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk
99:    Info (332111):    9.312 ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk
100:    Info (332111):  148.994 ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk
101:    Info (332111):  148.994 ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk
102:    Info (332111):  186.243 ic|mp1|mf_pllbase_inst|altera_pll_i|general[4].gpll~PLL_OUTPUT_COUNTER|divclk
103:    Info (332111):  186.243 ic|mp1|mf_pllbase_inst|altera_pll_i|general[5].gpll~PLL_OUTPUT_COUNTER|divclk

## Completion
247:Info: Quartus Prime Fitter was successful. 0 errors, 8 warnings
