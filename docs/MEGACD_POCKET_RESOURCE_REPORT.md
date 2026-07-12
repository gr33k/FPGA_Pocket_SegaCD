# MegaCD Pocket resource report

- classification: BIOS_PROBE_V2_ARTIFACT_READY
- logic utilization (ALMs): 14,008 / 18,480 (76%)
- total registers: 14,717
- total block memory bits: 2,343,914 / 3,153,920 (74%)
- M10K count: 308 / 308
- MLAB note: fitter reported 20 RAMs implemented using MLAB locations
- worst setup slack: 1.464 ns
- worst hold slack: 0.281 ns
- artifact size: 2073804 bytes
- artifact sha256: 9edb12cb9753e167225af01207ae3069277e28957dfe48e6ab30910c24357fac

## First important warnings

### Map warnings
15934:Warning (10036): Verilog HDL or VHDL warning at core_top.sv(371): object "gen_mem_addr_data" assigned a value but never read File: /work/build/megacd_pocket_fit_probe/core/core_top.sv Line: 371
15935:Warning (10762): Verilog HDL Case Statement warning at core_top.sv(570): can't check case statement for completeness because the case expression has too many possible states File: /work/build/megacd_pocket_fit_probe/core/core_top.sv Line: 570
16003:Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(109): object "host_24" assigned a value but never read File: /work/build/megacd_pocket_fit_probe/core/core_bridge_cmd.v Line: 109
16004:Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(110): object "host_28" assigned a value but never read File: /work/build/megacd_pocket_fit_probe/core/core_bridge_cmd.v Line: 110
16005:Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(111): object "host_2C" assigned a value but never read File: /work/build/megacd_pocket_fit_probe/core/core_bridge_cmd.v Line: 111

### Fit warnings
6082:Warning: RST port on the PLL is not properly connected on instance core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|general[0].gpll. The reset port on the PLL should be connected. If the PLL loses lock for any reason, you might need to manually reset the PLL in order to re-establish lock to the reference clock. File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/altera_pll.v Line: 749
6085:Warning (292013): Feature LogicLock is only available with a valid subscription license. You can purchase a software subscription to gain full access to this feature.
6086:Warning (15714): Some pins have incomplete I/O assignments. Refer to the I/O Assignment Warnings report for details
6102:Warning (16406): 1 global input pin(s) will use non-dedicated clock routing
6103:    Warning (16407): Source REFCLK I/O is not placed onto a dedicated REFCLK input pin for global clock driver bridge_spiclk~inputCLKENA0, placed at CLKCTRL_G6

### BIOS truncation warning search
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:7386:* Table truncated at 5000 items. To change the number of removed registers reported, set the "Number of Removed Registers Reported" option under Assignments->Settings->Analysis and Synthesis Settings->More Settings
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:7798:* Table truncated at 100 items. To change the number of inverted registers reported, set the "Number of Inverted Registers Reported" option under Assignments->Settings->Analysis and Synthesis Settings->More Settings
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16015:Warning (10230): Verilog HDL assignment warning at core_bridge_cmd.v(182): truncated value with size 32 to match size of target (10) File: /work/build/megacd_pocket_fit_probe/core/core_bridge_cmd.v Line: 182
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16060:Warning (10230): Verilog HDL assignment warning at data_loader.sv(140): truncated value with size 32 to match size of target (28) File: /work/build/megacd_pocket_fit_probe/core/data_loader.sv Line: 140
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16061:Warning (10230): Verilog HDL assignment warning at data_loader.sv(142): truncated value with size 32 to match size of target (3) File: /work/build/megacd_pocket_fit_probe/core/data_loader.sv Line: 142
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16063:Warning (10230): Verilog HDL assignment warning at data_loader.sv(169): truncated value with size 32 to match size of target (6) File: /work/build/megacd_pocket_fit_probe/core/data_loader.sv Line: 169
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16064:Warning (10230): Verilog HDL assignment warning at data_loader.sv(172): truncated value with size 32 to match size of target (6) File: /work/build/megacd_pocket_fit_probe/core/data_loader.sv Line: 172
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16065:Warning (10230): Verilog HDL assignment warning at data_loader.sv(186): truncated value with size 28 to match size of target (25) File: /work/build/megacd_pocket_fit_probe/core/data_loader.sv Line: 186
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16115:Warning (10230): Verilog HDL assignment warning at data_loader.sv(140): truncated value with size 32 to match size of target (28) File: /work/build/megacd_pocket_fit_probe/core/data_loader.sv Line: 140
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16116:Warning (10230): Verilog HDL assignment warning at data_loader.sv(142): truncated value with size 32 to match size of target (3) File: /work/build/megacd_pocket_fit_probe/core/data_loader.sv Line: 142
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16118:Warning (10230): Verilog HDL assignment warning at data_loader.sv(169): truncated value with size 32 to match size of target (6) File: /work/build/megacd_pocket_fit_probe/core/data_loader.sv Line: 169
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16119:Warning (10230): Verilog HDL assignment warning at data_loader.sv(172): truncated value with size 32 to match size of target (6) File: /work/build/megacd_pocket_fit_probe/core/data_loader.sv Line: 172
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16120:Warning (10230): Verilog HDL assignment warning at data_loader.sv(186): truncated value with size 28 to match size of target (18) File: /work/build/megacd_pocket_fit_probe/core/data_loader.sv Line: 186
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16122:Warning (10230): Verilog HDL assignment warning at common.v(74): truncated value with size 32 to match size of target (1) File: /work/build/megacd_pocket_fit_probe/apf/common.v Line: 74
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16123:Warning (10230): Verilog HDL assignment warning at common.v(75): truncated value with size 32 to match size of target (1) File: /work/build/megacd_pocket_fit_probe/apf/common.v Line: 75
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16755:Warning (10230): Verilog HDL assignment warning at jt12_pcm_interpol.v(55): truncated value with size 32 to match size of target (11) File: /work/build/megacd_pocket_fit_probe/core/rtl/GEN/jt12/jt12_pcm_interpol.v Line: 55
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16756:Warning (10230): Verilog HDL assignment warning at jt12_pcm_interpol.v(61): truncated value with size 32 to match size of target (5) File: /work/build/megacd_pocket_fit_probe/core/rtl/GEN/jt12/jt12_pcm_interpol.v Line: 61
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16758:Warning (10230): Verilog HDL assignment warning at jt10_adpcm_div.v(47): truncated value with size 16 to match size of target (11) File: /work/build/megacd_pocket_fit_probe/core/rtl/GEN/jt12/adpcm/jt10_adpcm_div.v Line: 47
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:16759:Warning (10230): Verilog HDL assignment warning at jt10_adpcm_div.v(48): truncated value with size 16 to match size of target (11) File: /work/build/megacd_pocket_fit_probe/core/rtl/GEN/jt12/adpcm/jt10_adpcm_div.v Line: 48
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:17030:Warning (10230): Verilog HDL assignment warning at sound_i2s.sv(49): truncated value with size 32 to match size of target (21) File: /work/build/megacd_pocket_fit_probe/core/sound_i2s.sv Line: 49
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:17067:Warning (10230): Verilog HDL assignment warning at common.v(74): truncated value with size 2 to match size of target (1) File: /work/build/megacd_pocket_fit_probe/apf/common.v Line: 74
build/megacd_pocket_fit_probe/output_files/ap_core.map.rpt:17068:Warning (10230): Verilog HDL assignment warning at common.v(75): truncated value with size 2 to match size of target (1) File: /work/build/megacd_pocket_fit_probe/apf/common.v Line: 75
