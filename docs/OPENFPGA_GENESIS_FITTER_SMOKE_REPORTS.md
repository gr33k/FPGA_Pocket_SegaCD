# openFPGA Genesis fitter smoke reports
Generated: 2026-07-08 08:00:24 UTC
Source work dir: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga

## Map exit summary
Map exit code: 0
Map first error: none
Map first warning: 275:Warning (10036): Verilog HDL or VHDL warning at core_top.sv(454): object "cs_m30_map_enable" assigned a value but never read File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 454

## Fitter exit summary
Fitter attempted: yes
Fitter exit code: 0
Fitter first error: none
Fitter first warning: 29:Warning: RST port on the PLL is not properly connected on instance core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|general[1].gpll. The reset port on the PLL should be connected. If the PLL loses lock for any reason, you might need to manually reset the PLL in order to re-establish lock to the reference clock. File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/altera_pll.v Line: 749

## Fitter smoke resource/warning snippets

### Map first 30 error lines

### Map first 30 warning lines
275:Warning (10036): Verilog HDL or VHDL warning at core_top.sv(454): object "cs_m30_map_enable" assigned a value but never read File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 454
276:Warning (10762): Verilog HDL Case Statement warning at core_top.sv(303): can't check case statement for completeness because the case expression has too many possible states File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 303
277:Warning (10230): Verilog HDL assignment warning at core_top.sv(460): truncated value with size 32 to match size of target (12) File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 460
278:Warning (10230): Verilog HDL assignment warning at core_top.sv(462): truncated value with size 32 to match size of target (16) File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 462
279:Warning (10762): Verilog HDL Case Statement warning at core_top.sv(466): can't check case statement for completeness because the case expression has too many possible states File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 466
280:Warning (10230): Verilog HDL assignment warning at core_top.sv(525): truncated value with size 32 to match size of target (10) File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 525
281:Warning (10230): Verilog HDL assignment warning at core_top.sv(536): truncated value with size 32 to match size of target (3) File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 536
282:Warning (10030): Net "rom_data2" at core_top.sv(870) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 870
283:Warning (10030): Net "rom_rdack2" at core_top.sv(872) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 872
285:Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(109): object "host_24" assigned a value but never read File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 109
286:Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(110): object "host_28" assigned a value but never read File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 110
287:Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(111): object "host_2C" assigned a value but never read File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 111
288:Warning (10858): Verilog HDL warning at core_bridge_cmd.v(116): object host_4C used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 116
289:Warning (10858): Verilog HDL warning at core_bridge_cmd.v(137): object target_20 used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 137
290:Warning (10858): Verilog HDL warning at core_bridge_cmd.v(138): object target_24 used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 138
291:Warning (10858): Verilog HDL warning at core_bridge_cmd.v(139): object target_28 used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 139
292:Warning (10858): Verilog HDL warning at core_bridge_cmd.v(140): object target_2C used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 140
293:Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(142): object "target_40" assigned a value but never read File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 142
294:Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(143): object "target_44" assigned a value but never read File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 143
295:Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(144): object "target_48" assigned a value but never read File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 144
296:Warning (10036): Verilog HDL or VHDL warning at core_bridge_cmd.v(145): object "target_4C" assigned a value but never read File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 145
297:Warning (10230): Verilog HDL assignment warning at core_bridge_cmd.v(182): truncated value with size 32 to match size of target (10) File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 182
298:Warning (10762): Verilog HDL Case Statement warning at core_bridge_cmd.v(185): can't check case statement for completeness because the case expression has too many possible states File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 185
299:Warning (10762): Verilog HDL Case Statement warning at core_bridge_cmd.v(220): can't check case statement for completeness because the case expression has too many possible states File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 220
300:Warning (10030): Net "host_4C" at core_bridge_cmd.v(116) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 116
301:Warning (10030): Net "target_20" at core_bridge_cmd.v(137) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 137
302:Warning (10030): Net "target_24" at core_bridge_cmd.v(138) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 138
303:Warning (10030): Net "target_28" at core_bridge_cmd.v(139) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 139
304:Warning (10030): Net "target_2C" at core_bridge_cmd.v(140) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 140
338:Warning (113028): 253 out of 256 addresses are uninitialized. The Quartus Prime software will initialize them to "0". There are 2 warnings found, and 2 warnings are reported. File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/build_id.mif Line: 1

### Fitter first 30 error lines

### Fitter first 50 warning lines
29:Warning: RST port on the PLL is not properly connected on instance core_top:ic|mf_pllbase:mp1|mf_pllbase_0002:mf_pllbase_inst|altera_pll:altera_pll_i|general[1].gpll. The reset port on the PLL should be connected. If the PLL loses lock for any reason, you might need to manually reset the PLL in order to re-establish lock to the reference clock. File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/altera_pll.v Line: 749
32:Warning (292013): Feature LogicLock is only available with a valid subscription license. You can purchase a software subscription to gain full access to this feature.
33:Warning (15714): Some pins have incomplete I/O assignments. Refer to the I/O Assignment Warnings report for details
47:Warning (16406): 1 global input pin(s) will use non-dedicated clock routing
105:Warning (176251): Ignoring some wildcard destinations of fast I/O register assignments
127:Warning (170136): Design uses Placement Effort Multiplier = 4.0.  Using a Placement Effort Multiplier > 1.0 can increase processing time, especially when used during a second or third fitting attempt.
144:Warning (169064): Following 101 pins have no output enable or a GND or VCC output enable - later changes to this connectivity may change fitting results

### Map/device/fitter notable lines
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:7:    Info: functions, and any output files from any of the foregoing 
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:96:Info (12021): Found 1 design units, including 1 entities, in source file core/rtl/jt12/jt12_exprom.v
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:97:    Info (12023): Found entity 1: jt12_exprom File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/jt12/jt12_exprom.v Line: 29
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:256:Info (12128): Elaborating entity "altddio_bidir" for hierarchy "mf_ddio_bidir_12:isco|altddio_bidir:ALTDDIO_BIDIR_component" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/mf_ddio_bidir_12.v Line: 81
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:257:Info (12130): Elaborated megafunction instantiation "mf_ddio_bidir_12:isco|altddio_bidir:ALTDDIO_BIDIR_component" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/mf_ddio_bidir_12.v Line: 81
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:258:Info (12133): Instantiated megafunction "mf_ddio_bidir_12:isco|altddio_bidir:ALTDDIO_BIDIR_component" with the following parameter: File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/mf_ddio_bidir_12.v Line: 81
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:261:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:270:Info (12128): Elaborating entity "ddio_bidir_euo" for hierarchy "mf_ddio_bidir_12:isco|altddio_bidir:ALTDDIO_BIDIR_component|ddio_bidir_euo:auto_generated" File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/altddio_bidir.tdf Line: 116
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:282:Warning (10030): Net "rom_data2" at core_top.sv(870) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 870
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:283:Warning (10030): Net "rom_rdack2" at core_top.sv(872) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 872
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:288:Warning (10858): Verilog HDL warning at core_bridge_cmd.v(116): object host_4C used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 116
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:289:Warning (10858): Verilog HDL warning at core_bridge_cmd.v(137): object target_20 used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 137
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:290:Warning (10858): Verilog HDL warning at core_bridge_cmd.v(138): object target_24 used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 138
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:291:Warning (10858): Verilog HDL warning at core_bridge_cmd.v(139): object target_28 used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 139
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:292:Warning (10858): Verilog HDL warning at core_bridge_cmd.v(140): object target_2C used but never assigned File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 140
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:300:Warning (10030): Net "host_4C" at core_bridge_cmd.v(116) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 116
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:301:Warning (10030): Net "target_20" at core_bridge_cmd.v(137) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 137
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:302:Warning (10030): Net "target_24" at core_bridge_cmd.v(138) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 138
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:303:Warning (10030): Net "target_28" at core_bridge_cmd.v(139) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 139
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:304:Warning (10030): Net "target_2C" at core_bridge_cmd.v(140) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_bridge_cmd.v Line: 140
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:316:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:339:    Warning (113027): Addresses ranging from 0 to 223 are not initialized File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/build_id.mif Line: 1
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:340:    Warning (113027): Addresses ranging from 227 to 255 are not initialized File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/apf/build_id.mif Line: 1
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:356:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:404:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:441:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:467:Info (12128): Elaborating entity "data_loader" for hierarchy "core_top:ic|data_loader:rom_loader" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/core_top.sv Line: 670
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:481:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:515:Warning (10259): Verilog HDL error at sdram.sv(82): constant value overflow File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/sdram.sv Line: 82
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:521:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:582:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:653:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:711:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:769:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:827:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:885:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:943:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1001:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1069:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1118:Info (12128): Elaborating entity "STM95XXX" for hierarchy "core_top:ic|system:system|STM95XXX:pier_eeprom" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/system.sv Line: 684
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1127:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1180:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1223:Info (12128): Elaborating entity "sld_mod_ram_rom" for hierarchy "core_top:ic|system:system|SVP:svp|spram:IRAM|spram_sz:spram_sz|altsyncram:altsyncram_component|altsyncram_r624:auto_generated|sld_mod_ram_rom:mgl_prim2" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/db/altsyncram_r624.tdf Line: 38
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1224:Info (12130): Elaborated megafunction instantiation "core_top:ic|system:system|SVP:svp|spram:IRAM|spram_sz:spram_sz|altsyncram:altsyncram_component|altsyncram_r624:auto_generated|sld_mod_ram_rom:mgl_prim2" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/db/altsyncram_r624.tdf Line: 38
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1225:Info (12133): Instantiated megafunction "core_top:ic|system:system|SVP:svp|spram:IRAM|spram_sz:spram_sz|altsyncram:altsyncram_component|altsyncram_r624:auto_generated|sld_mod_ram_rom:mgl_prim2" with the following parameter: File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/db/altsyncram_r624.tdf Line: 38
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1234:Info (12128): Elaborating entity "sld_jtag_endpoint_adapter" for hierarchy "core_top:ic|system:system|SVP:svp|spram:IRAM|spram_sz:spram_sz|altsyncram:altsyncram_component|altsyncram_r624:auto_generated|sld_mod_ram_rom:mgl_prim2|sld_jtag_endpoint_adapter:jtag_signal_adapter" File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/sld_mod_ram_rom.vhd Line: 302
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1235:Info (12128): Elaborating entity "sld_jtag_endpoint_adapter_impl" for hierarchy "core_top:ic|system:system|SVP:svp|spram:IRAM|spram_sz:spram_sz|altsyncram:altsyncram_component|altsyncram_r624:auto_generated|sld_mod_ram_rom:mgl_prim2|sld_jtag_endpoint_adapter:jtag_signal_adapter|sld_jtag_endpoint_adapter_impl:sld_jtag_endpoint_adapter_impl_inst" File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/sld_jtag_endpoint_adapter.vhd Line: 232
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1236:Info (12128): Elaborating entity "sld_rom_sr" for hierarchy "core_top:ic|system:system|SVP:svp|spram:IRAM|spram_sz:spram_sz|altsyncram:altsyncram_component|altsyncram_r624:auto_generated|sld_mod_ram_rom:mgl_prim2|sld_rom_sr:\ram_rom_logic_gen:name_gen:info_rom_sr" File: /opt/intelFPGA_lite/quartus/libraries/megafunctions/sld_mod_ram_rom.vhd Line: 828
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1255:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1324:    Info (12134): Parameter "intended_device_family" = "Cyclone V"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1387:Warning (10030): Net "lfo_sh1_lut.data_a" at jt12_pm.v(38) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/jt12/jt12_pm.v Line: 38
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1388:Warning (10030): Net "lfo_sh1_lut.waddr_a" at jt12_pm.v(38) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/jt12/jt12_pm.v Line: 38
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1389:Warning (10030): Net "lfo_sh2_lut.data_a" at jt12_pm.v(39) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/jt12/jt12_pm.v Line: 39
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1390:Warning (10030): Net "lfo_sh2_lut.waddr_a" at jt12_pm.v(39) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/jt12/jt12_pm.v Line: 39
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1391:Warning (10030): Net "lfo_sh1_lut.we_a" at jt12_pm.v(38) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/jt12/jt12_pm.v Line: 38
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1392:Warning (10030): Net "lfo_sh2_lut.we_a" at jt12_pm.v(39) has no driver or initial value, using a default initial value '0' File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/jt12/jt12_pm.v Line: 39
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1415:Info (12128): Elaborating entity "jt12_exprom" for hierarchy "core_top:ic|system:system|jt12:fm|jt12_top:u_jt12|jt12_op:u_op|jt12_exprom:u_exprom" File: /work/build/openfpga_genesis_fitter_smoke_work/src/fpga/core/rtl/jt12/jt12_op.v Line: 230
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1553:Info (19000): Inferred 9 megafunctions from design logic
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1554:    Info (276029): Inferred altsyncram megafunction from the following design logic: "core_top:ic|system:system|jt12:fm|jt12_top:u_jt12|jt12_op:u_op|jt12_exprom:u_exprom|explut_jt51_rtl_0" 
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1555:        Info (286033): Parameter OPERATION_MODE set to ROM
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1564:        Info (286033): Parameter INIT_FILE set to db/ap_core.ram0_jt12_exprom_ef3db0f0.hdl.mif
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1565:    Info (276029): Inferred altsyncram megafunction from the following design logic: "core_top:ic|system:system|jt12:fm|jt12_top:u_jt12|jt12_op:u_op|jt12_logsin:u_logsin|sinelut_rtl_0" 
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1566:        Info (286033): Parameter OPERATION_MODE set to ROM
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1576:    Info (276029): Inferred altsyncram megafunction from the following design logic: "core_top:ic|system:system|fx68k:M68K|uRom:uRom|uRam_rtl_0" 
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1577:        Info (286033): Parameter OPERATION_MODE set to ROM
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1587:    Info (276029): Inferred altsyncram megafunction from the following design logic: "core_top:ic|system:system|fx68k:M68K|nanoRom:nanoRom|nRam_rtl_0" 
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1588:        Info (286033): Parameter OPERATION_MODE set to ROM
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1598:    Info (276034): Inferred altshift_taps megafunction from the following design logic: "core_top:ic|system:system|jt12:fm|jt12_top:u_jt12|jt12_eg:u_eg|jt12_sh_rst:u_konsh|bits_rtl_0"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1603:    Info (276034): Inferred altshift_taps megafunction from the following design logic: "core_top:ic|system:system|jt12:fm|jt12_top:u_jt12|jt12_mmr:u_mmr|jt12_reg:u_reg|jt12_csr:u_csr1|jt12_sh_rst:u_regch|bits_rtl_0"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1608:    Info (276034): Inferred altshift_taps megafunction from the following design logic: "core_top:ic|system:system|jt12:fm|jt12_top:u_jt12|jt12_mmr:u_mmr|jt12_reg:u_reg|jt12_csr:u_csr1|jt12_sh_rst:u_regch|bits_rtl_1"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1613:    Info (276034): Inferred altshift_taps megafunction from the following design logic: "core_top:ic|system:system|jt12:fm|jt12_top:u_jt12|jt12_op:u_op|jt12_sh:phasemod_sh|bits_rtl_0"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1618:    Info (276034): Inferred altshift_taps megafunction from the following design logic: "core_top:ic|system:system|jt12:fm|jt12_top:u_jt12|jt12_pg:u_pg|jt12_sh_rst:u_pad|bits_rtl_0"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1623:Info (12130): Elaborated megafunction instantiation "core_top:ic|system:system|jt12:fm|jt12_top:u_jt12|jt12_op:u_op|jt12_exprom:u_exprom|altsyncram:explut_jt51_rtl_0"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1624:Info (12133): Instantiated megafunction "core_top:ic|system:system|jt12:fm|jt12_top:u_jt12|jt12_op:u_op|jt12_exprom:u_exprom|altsyncram:explut_jt51_rtl_0" with the following parameter:
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1625:    Info (12134): Parameter "OPERATION_MODE" = "ROM"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1634:    Info (12134): Parameter "INIT_FILE" = "db/ap_core.ram0_jt12_exprom_ef3db0f0.hdl.mif"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1639:    Info (12134): Parameter "OPERATION_MODE" = "ROM"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1693:    Info (12134): Parameter "OPERATION_MODE" = "ROM"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1707:    Info (12134): Parameter "OPERATION_MODE" = "ROM"
/work/docs/OPENFPGA_GENESIS_FITTER_SMOKE_MAP_LOG.txt:1749:Warning (12241): 48 hierarchies have connectivity warnings - see the Connectivity Checks report folder
# Map/fitter first-error summary
Map first error class: none
Fitter first error class: none
