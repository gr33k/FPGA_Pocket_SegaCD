# openFPGA Genesis warning source review

Generated: 2026-07-08 02:19:54 UTC
Source warning summary: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docs/OPENFPGA_GENESIS_ANALYSIS_WARNING_SUMMARY.md
Source analysis log: /Users/phassold/Projects/FPGA_Pocket_SegaCD/docs/OPENFPGA_GENESIS_ANALYSIS_ONLY_LOG.txt
Source tree reviewed: /Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga

## Warning code 10030
- Total reviewed examples: 3
- Example 1
  - message: Net "rom_data2" at core_top.sv(870) has no driver or initial value, using a default initial value '0'
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`
  - line: 870
  - excerpt:
    ```verilog
    00862: 	.SDRAM_nWE(dram_we_n),      // write enable
    00863: 	.SDRAM_nRAS(dram_ras_n),    // row address select
    00864: 	.SDRAM_nCAS(dram_cas_n),    // columns address select
    00865: 	.SDRAM_CLK(dram_clk),
    00866: 	.SDRAM_CKE(dram_cke)
    00867: );
    00868: 
    00869: wire [24:1] rom_addr, rom_addr2;
    00870: wire [15:0] sdrom_data, ddrom_data, rom_data2, rom_wdata;
    00871: wire  [1:0] rom_be;
    00872: wire rom_req, sdrom_rdack, ddrom_rdack, rom_rd2, rom_rdack2, rom_we;
    00873: 
    00874: reg sram_quirk = 0;
    00875: reg sram00_quirk = 0;
    00876: reg eeprom_quirk = 0;
    00877: reg fifo_quirk = 0;
    00878: reg noram_quirk = 0;
    ```
  - assessment: ROM/loader path placeholder
  - reasoning: Signal/module appears intentionally unused or present as a ROM-related stub in upstream openFPGA baseline. Safe for this scaffold-only gate as long as behavior is still inactive/not used for gameplay path.
  - likely safe for first fitter smoke gate: yes
- Example 2
  - message: Net "rom_rdack2" at core_top.sv(872) has no driver or initial value, using a default initial value '0'
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`
  - line: 872
  - excerpt:
    ```verilog
    00864: 	.SDRAM_nCAS(dram_cas_n),    // columns address select
    00865: 	.SDRAM_CLK(dram_clk),
    00866: 	.SDRAM_CKE(dram_cke)
    00867: );
    00868: 
    00869: wire [24:1] rom_addr, rom_addr2;
    00870: wire [15:0] sdrom_data, ddrom_data, rom_data2, rom_wdata;
    00871: wire  [1:0] rom_be;
    00872: wire rom_req, sdrom_rdack, ddrom_rdack, rom_rd2, rom_rdack2, rom_we;
    00873: 
    00874: reg sram_quirk = 0;
    00875: reg sram00_quirk = 0;
    00876: reg eeprom_quirk = 0;
    00877: reg fifo_quirk = 0;
    00878: reg noram_quirk = 0;
    00879: reg pier_quirk = 0;
    00880: reg svp_quirk = 0;
    ```
  - assessment: ROM/loader path placeholder
  - reasoning: Signal/module appears intentionally unused or present as a ROM-related stub in upstream openFPGA baseline. Safe for this scaffold-only gate as long as behavior is still inactive/not used for gameplay path.
  - likely safe for first fitter smoke gate: yes
- Example 3
  - message: Net "host_4C" at core_bridge_cmd.v(116) has no driver or initial value, using a default initial value '0'
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_bridge_cmd.v`
  - line: 116
  - excerpt:
    ```verilog
    00108:     reg     [31:0]  host_20; // parameter data
    00109:     reg     [31:0]  host_24;
    00110:     reg     [31:0]  host_28;
    00111:     reg     [31:0]  host_2C;
    00112:     
    00113:     reg     [31:0]  host_40; // response data
    00114:     reg     [31:0]  host_44;
    00115:     reg     [31:0]  host_48;
    00116:     reg     [31:0]  host_4C;    
    00117:     
    00118:     reg             host_cmd_start;
    00119:     reg     [15:0]  host_cmd_startval;
    00120:     reg     [15:0]  host_cmd;
    00121:     reg     [15:0]  host_resultcode;
    00122:     
    00123: localparam  [3:0]   ST_IDLE         = 'd0;
    00124: localparam  [3:0]   ST_PARSE        = 'd1;
    ```
  - assessment: APF bridge/register placeholder
  - reasoning: Signal appears tied to bridge/debug command scaffolding and is unused in this milestone. Expected for an APF-shell-only analysis lane.
  - likely safe for first fitter smoke gate: yes
- Per-code disposition: needs more review
- Per-class assessment: unknown


## Warning code 10036
- Total reviewed examples: 3
- Example 1
  - message: Verilog HDL or VHDL warning at core_top.sv(454): object "cs_m30_map_enable" assigned a value but never read
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`
  - line: 454
  - excerpt:
    ```verilog
    00446: // Audio
    00447: reg cs_fm_enable 			     = 1;
    00448: reg cs_psg_enable             	 = 1;
    00449: reg cs_hifi_pcm_enable	         = 1;
    00450: reg [1:0] cs_audio_filter	 	 = 0;
    00451: reg cs_fm_chip	 		 		 = 0;
    00452: 
    00453: // Input
    00454: reg cs_m30_map_enable            = 0;
    00455: reg lightgun_enabled             = 0;
    00456: reg show_crosshair               = 1;
    00457: reg [7:0] dpad_aim_speed         = 4;
    00458: 
    00459: always @(posedge clk_74a) begin
    00460:     reset_counter = reset_counter + 1;
    00461:     if (~osnotify_inmenu && reset_delay > 0) begin
    00462:       reset_delay <= reset_delay - 1;
    ```
  - assessment: intentional unused/stub/interface placeholder
  - reasoning: No deterministic runtime semantics currently expected from this path in this scaffold pass; does not directly indicate a fitter blocker by itself.
  - likely safe for first fitter smoke gate: needs more evidence
- Example 2
  - message: Verilog HDL or VHDL warning at core_bridge_cmd.v(109): object "host_24" assigned a value but never read
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_bridge_cmd.v`
  - line: 109
  - excerpt:
    ```verilog
    00101: 
    00102: // host
    00103: 
    00104:     reg     [31:0]  host_0;
    00105:     reg     [31:0]  host_4 = 'h20; // host cmd parameter data at 0x20 
    00106:     reg     [31:0]  host_8 = 'h40; // host cmd response data at 0x40 
    00107:     
    00108:     reg     [31:0]  host_20; // parameter data
    00109:     reg     [31:0]  host_24;
    00110:     reg     [31:0]  host_28;
    00111:     reg     [31:0]  host_2C;
    00112:     
    00113:     reg     [31:0]  host_40; // response data
    00114:     reg     [31:0]  host_44;
    00115:     reg     [31:0]  host_48;
    00116:     reg     [31:0]  host_4C;    
    00117:     
    ```
  - assessment: APF bridge/register placeholder
  - reasoning: Signal appears tied to bridge/debug command scaffolding and is unused in this milestone. Expected for an APF-shell-only analysis lane.
  - likely safe for first fitter smoke gate: yes
- Example 3
  - message: Verilog HDL or VHDL warning at core_bridge_cmd.v(110): object "host_28" assigned a value but never read
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_bridge_cmd.v`
  - line: 110
  - excerpt:
    ```verilog
    00102: // host
    00103: 
    00104:     reg     [31:0]  host_0;
    00105:     reg     [31:0]  host_4 = 'h20; // host cmd parameter data at 0x20 
    00106:     reg     [31:0]  host_8 = 'h40; // host cmd response data at 0x40 
    00107:     
    00108:     reg     [31:0]  host_20; // parameter data
    00109:     reg     [31:0]  host_24;
    00110:     reg     [31:0]  host_28;
    00111:     reg     [31:0]  host_2C;
    00112:     
    00113:     reg     [31:0]  host_40; // response data
    00114:     reg     [31:0]  host_44;
    00115:     reg     [31:0]  host_48;
    00116:     reg     [31:0]  host_4C;    
    00117:     
    00118:     reg             host_cmd_start;
    ```
  - assessment: APF bridge/register placeholder
  - reasoning: Signal appears tied to bridge/debug command scaffolding and is unused in this milestone. Expected for an APF-shell-only analysis lane.
  - likely safe for first fitter smoke gate: yes
- Per-code disposition: needs more review
- Per-class assessment: unknown


## Warning code 10230
- Total reviewed examples: 3
- Example 1
  - message: Verilog HDL assignment warning at core_top.sv(460): truncated value with size 32 to match size of target (12)
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`
  - line: 460
  - excerpt:
    ```verilog
    00452: 
    00453: // Input
    00454: reg cs_m30_map_enable            = 0;
    00455: reg lightgun_enabled             = 0;
    00456: reg show_crosshair               = 1;
    00457: reg [7:0] dpad_aim_speed         = 4;
    00458: 
    00459: always @(posedge clk_74a) begin
    00460:     reset_counter = reset_counter + 1;
    00461:     if (~osnotify_inmenu && reset_delay > 0) begin
    00462:       reset_delay <= reset_delay - 1;
    00463:     end
    00464: 
    00465: 	if (bridge_wr) begin
    00466:       casex (bridge_addr)
    00467:         32'h00F00000: cs_audio_filter			<= bridge_wr_data[1:0];
    00468:         32'h00A00000: cs_fm_chip                <= bridge_wr_data[0];
    ```
  - assessment: intentional unused/stub/interface placeholder
  - reasoning: No deterministic runtime semantics currently expected from this path in this scaffold pass; does not directly indicate a fitter blocker by itself.
  - likely safe for first fitter smoke gate: needs more evidence
- Example 2
  - message: Verilog HDL assignment warning at core_top.sv(462): truncated value with size 32 to match size of target (16)
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`
  - line: 462
  - excerpt:
    ```verilog
    00454: reg cs_m30_map_enable            = 0;
    00455: reg lightgun_enabled             = 0;
    00456: reg show_crosshair               = 1;
    00457: reg [7:0] dpad_aim_speed         = 4;
    00458: 
    00459: always @(posedge clk_74a) begin
    00460:     reset_counter = reset_counter + 1;
    00461:     if (~osnotify_inmenu && reset_delay > 0) begin
    00462:       reset_delay <= reset_delay - 1;
    00463:     end
    00464: 
    00465: 	if (bridge_wr) begin
    00466:       casex (bridge_addr)
    00467:         32'h00F00000: cs_audio_filter			<= bridge_wr_data[1:0];
    00468:         32'h00A00000: cs_fm_chip                <= bridge_wr_data[0];
    00469:         32'h00C00000: cs_cpu_turbo				<= bridge_wr_data[1:0];
    00470:         32'h00000000: cs_multitap_enable 	    <= bridge_wr_data[0];
    ```
  - assessment: intentional unused/stub/interface placeholder
  - reasoning: No deterministic runtime semantics currently expected from this path in this scaffold pass; does not directly indicate a fitter blocker by itself.
  - likely safe for first fitter smoke gate: needs more evidence
- Example 3
  - message: Verilog HDL assignment warning at core_top.sv(525): truncated value with size 32 to match size of target (10)
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`
  - line: 525
  - excerpt:
    ```verilog
    00517: 		datatable_wren <= 0;
    00518: 	end else begin
    00519: 		if (datatable_div > 4) begin
    00520: 			// Write sram size half of the time
    00521: 			datatable_wren <= 1;
    00522: 			// sram_size is the size of the config value in the ROM. Convert to actual size
    00523: 			datatable_data <= 32'd65536;
    00524: 			// Data slot index 1, not id 1
    00525: 			datatable_addr <= 1 * 2 + 1;
    00526: 		end else begin
    00527: 			datatable_wren <= 0;
    00528: 			// Read ROM size rest of the time
    00529: 			datatable_addr <= 1;
    00530: 
    00531: 			if (datatable_div == 4) begin
    00532: 				rom_file_size <= datatable_q;
    00533: 			end
    ```
  - assessment: intentional unused/stub/interface placeholder
  - reasoning: No deterministic runtime semantics currently expected from this path in this scaffold pass; does not directly indicate a fitter blocker by itself.
  - likely safe for first fitter smoke gate: needs more evidence
- Per-code disposition: needs more review
- Per-class assessment: intentional unused/stub/interface placeholder


## Warning code 10259
- Total reviewed examples: 1
- Example 1
  - message: Verilog HDL error at sdram.sv(82): constant value overflow
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/rtl/sdram.sv`
  - line: 82
  - excerpt:
    ```verilog
    00074: localparam OP_MODE        = 2'd0; // only 0 (standard operation) allowed
    00075: localparam NO_WRITE_BURST = 1'd1; // 0=write burst enabled, 1=only single access write
    00076: 
    00077: localparam MODE = { 3'b000, NO_WRITE_BURST, OP_MODE, CAS_LATENCY, ACCESS_TYPE, BURST_LENGTH}; 
    00078: 
    00079: localparam STATE_IDLE  = 3'd0;             // state to check the requests
    00080: localparam STATE_START = STATE_IDLE+1'd1;  // state in which a new command is started
    00081: localparam STATE_CONT  = STATE_START+RASCAS_DELAY;
    00082: localparam STATE_READY = STATE_CONT+CAS_LATENCY+1'd1;
    00083: localparam STATE_LAST  = STATE_READY;      // last state in cycle
    00084: 
    00085: reg  [2:0] state;
    00086: reg [22:1] a;
    00087: reg [15:0] data;
    00088: reg        we;
    00089: reg  [1:0] ba = 0;
    00090: reg  [1:0] dqm;
    ```
  - assessment: SDRAM/default-constant issue
  - reasoning: Constant-width arithmetic/implementation detail in SDRAM helper logic; needs review against intended memory model before fitter/ROM pathway integration.
  - likely safe for first fitter smoke gate: needs more evidence
- Per-code disposition: needs more review
- Per-class assessment: SDRAM/default-constant issue


## Warning code 10762
- Total reviewed examples: 3
- Example 1
  - message: Verilog HDL Case Statement warning at core_top.sv(303): can't check case statement for completeness because the case expression has too many possible states
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`
  - line: 303
  - excerpt:
    ```verilog
    00295: assign aux_scl = 1'bZ;
    00296: assign vpll_feed = 1'bZ;
    00297: 
    00298: 
    00299: // for bridge write data, we just broadcast it to all bus devices
    00300: // for bridge read data, we have to mux it
    00301: // add your own devices here
    00302: always @(*) begin
    00303:     casex(bridge_addr)
    00304:     default: begin
    00305:         bridge_rd_data <= 0;
    00306:     end
    00307: 	32'h00E00000: begin
    00308:         bridge_rd_data <= region_req;
    00309:     end
    00310:     32'hF8xxxxxx: begin
    00311:         bridge_rd_data <= cmd_bridge_rd_data;
    ```
  - assessment: intentional unused/stub/interface placeholder
  - reasoning: No deterministic runtime semantics currently expected from this path in this scaffold pass; does not directly indicate a fitter blocker by itself.
  - likely safe for first fitter smoke gate: needs more evidence
- Example 2
  - message: Verilog HDL Case Statement warning at core_top.sv(466): can't check case statement for completeness because the case expression has too many possible states
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_top.sv`
  - line: 466
  - excerpt:
    ```verilog
    00458: 
    00459: always @(posedge clk_74a) begin
    00460:     reset_counter = reset_counter + 1;
    00461:     if (~osnotify_inmenu && reset_delay > 0) begin
    00462:       reset_delay <= reset_delay - 1;
    00463:     end
    00464: 
    00465: 	if (bridge_wr) begin
    00466:       casex (bridge_addr)
    00467:         32'h00F00000: cs_audio_filter			<= bridge_wr_data[1:0];
    00468:         32'h00A00000: cs_fm_chip                <= bridge_wr_data[0];
    00469:         32'h00C00000: cs_cpu_turbo				<= bridge_wr_data[1:0];
    00470:         32'h00000000: cs_multitap_enable 	    <= bridge_wr_data[0];
    00471:         32'h00000010: cs_ar_correction_enable 	<= bridge_wr_data[0];
    00472:         32'h00000020: begin
    00473:           cs_composite_enable <= bridge_wr_data[0];
    00474:           cs_auto_composite_enable <= bridge_wr_data[1];
    ```
  - assessment: intentional unused/stub/interface placeholder
  - reasoning: No deterministic runtime semantics currently expected from this path in this scaffold pass; does not directly indicate a fitter blocker by itself.
  - likely safe for first fitter smoke gate: needs more evidence
- Example 3
  - message: Verilog HDL Case Statement warning at core_bridge_cmd.v(185): can't check case statement for completeness because the case expression has too many possible states
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_bridge_cmd.v`
  - line: 185
  - excerpt:
    ```verilog
    00177:     if(status_setup_done & ~status_setup_done_1) begin
    00178:         status_setup_done_queue <= 1;
    00179:     end
    00180:     
    00181:     b_datatable_wren <= 0;
    00182:     b_datatable_addr <= bridge_addr >> 2;
    00183:         
    00184:     if(bridge_wr) begin
    00185:         casex(bridge_addr)
    00186:         32'hF8xx00xx: begin
    00187:             case(bridge_addr[7:0])
    00188:             8'h0: begin
    00189:                 host_0 <= bridge_wr_data_in; // command/status
    00190:                 // check for command 
    00191:                 if(bridge_wr_data_in[31:16] == 16'h434D) begin
    00192:                     // host wants us to do a command
    00193:                     host_cmd_startval <= bridge_wr_data_in[15:0];
    ```
  - assessment: APF bridge/register placeholder
  - reasoning: Signal appears tied to bridge/debug command scaffolding and is unused in this milestone. Expected for an APF-shell-only analysis lane.
  - likely safe for first fitter smoke gate: yes
- Per-code disposition: needs more review
- Per-class assessment: unknown


## Warning code 10858
- Total reviewed examples: 3
- Example 1
  - message: Verilog HDL warning at core_bridge_cmd.v(116): object host_4C used but never assigned
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_bridge_cmd.v`
  - line: 116
  - excerpt:
    ```verilog
    00108:     reg     [31:0]  host_20; // parameter data
    00109:     reg     [31:0]  host_24;
    00110:     reg     [31:0]  host_28;
    00111:     reg     [31:0]  host_2C;
    00112:     
    00113:     reg     [31:0]  host_40; // response data
    00114:     reg     [31:0]  host_44;
    00115:     reg     [31:0]  host_48;
    00116:     reg     [31:0]  host_4C;    
    00117:     
    00118:     reg             host_cmd_start;
    00119:     reg     [15:0]  host_cmd_startval;
    00120:     reg     [15:0]  host_cmd;
    00121:     reg     [15:0]  host_resultcode;
    00122:     
    00123: localparam  [3:0]   ST_IDLE         = 'd0;
    00124: localparam  [3:0]   ST_PARSE        = 'd1;
    ```
  - assessment: APF bridge/register placeholder
  - reasoning: Signal appears tied to bridge/debug command scaffolding and is unused in this milestone. Expected for an APF-shell-only analysis lane.
  - likely safe for first fitter smoke gate: yes
- Example 2
  - message: Verilog HDL warning at core_bridge_cmd.v(137): object target_20 used but never assigned
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_bridge_cmd.v`
  - line: 137
  - excerpt:
    ```verilog
    00129:     reg     [3:0]   hstate;
    00130:     
    00131: // target
    00132:     
    00133:     reg     [31:0]  target_0;
    00134:     reg     [31:0]  target_4 = 'h20;
    00135:     reg     [31:0]  target_8 = 'h40;
    00136:     
    00137:     reg     [31:0]  target_20; // parameter data
    00138:     reg     [31:0]  target_24;
    00139:     reg     [31:0]  target_28;
    00140:     reg     [31:0]  target_2C;
    00141:     
    00142:     reg     [31:0]  target_40; // response data
    00143:     reg     [31:0]  target_44;
    00144:     reg     [31:0]  target_48;
    00145:     reg     [31:0]  target_4C;  
    ```
  - assessment: APF bridge/register placeholder
  - reasoning: Signal appears tied to bridge/debug command scaffolding and is unused in this milestone. Expected for an APF-shell-only analysis lane.
  - likely safe for first fitter smoke gate: yes
- Example 3
  - message: Verilog HDL warning at core_bridge_cmd.v(138): object target_24 used but never assigned
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/core/core_bridge_cmd.v`
  - line: 138
  - excerpt:
    ```verilog
    00130:     
    00131: // target
    00132:     
    00133:     reg     [31:0]  target_0;
    00134:     reg     [31:0]  target_4 = 'h20;
    00135:     reg     [31:0]  target_8 = 'h40;
    00136:     
    00137:     reg     [31:0]  target_20; // parameter data
    00138:     reg     [31:0]  target_24;
    00139:     reg     [31:0]  target_28;
    00140:     reg     [31:0]  target_2C;
    00141:     
    00142:     reg     [31:0]  target_40; // response data
    00143:     reg     [31:0]  target_44;
    00144:     reg     [31:0]  target_48;
    00145:     reg     [31:0]  target_4C;  
    00146:     
    ```
  - assessment: APF bridge/register placeholder
  - reasoning: Signal appears tied to bridge/debug command scaffolding and is unused in this milestone. Expected for an APF-shell-only analysis lane.
  - likely safe for first fitter smoke gate: yes
- Per-code disposition: safe
- Per-class assessment: APF bridge/register placeholder


## Warning code 12241
- No parsed file/line examples were available in summary/log.
- Overall disposition: needs more evidence
- Reason: no source witness currently available for this code in the captured summary entries.

## Warning code 113027
- Total reviewed examples: 1
- Example 1
  - message: Addresses ranging from 0 to 223 are not initialized
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/apf/build_id.mif`
  - line: 1
  - excerpt:
    ```verilog
    00001: -- Build ID Memory Initialization File
    00002: --
    00003: 
    00004: DEPTH = 256;
    00005: WIDTH = 32;
    00006: ADDRESS_RADIX = HEX;
    00007: DATA_RADIX = HEX;
    00008: 
    00009: CONTENT
    ```
  - assessment: ROM/loader path placeholder
  - reasoning: Signal/module appears intentionally unused or present as a ROM-related stub in upstream openFPGA baseline. Safe for this scaffold-only gate as long as behavior is still inactive/not used for gameplay path.
  - likely safe for first fitter smoke gate: yes
- Per-code disposition: safe
- Per-class assessment: ROM/loader path placeholder


## Warning code 113028
- Total reviewed examples: 1
- Example 1
  - message: 253 out of 256 addresses are uninitialized. The Quartus Prime software will initialize them to "0". There are 2 warnings found, and 2 warnings are reported.
  - source: `/Users/phassold/Projects/FPGA_Pocket_SegaCD/third_party/openFPGA-Genesis/src/fpga/apf/build_id.mif`
  - line: 1
  - excerpt:
    ```verilog
    00001: -- Build ID Memory Initialization File
    00002: --
    00003: 
    00004: DEPTH = 256;
    00005: WIDTH = 32;
    00006: ADDRESS_RADIX = HEX;
    00007: DATA_RADIX = HEX;
    00008: 
    00009: CONTENT
    ```
  - assessment: ROM/loader path placeholder
  - reasoning: Signal/module appears intentionally unused or present as a ROM-related stub in upstream openFPGA baseline. Safe for this scaffold-only gate as long as behavior is still inactive/not used for gameplay path.
  - likely safe for first fitter smoke gate: yes
- Per-code disposition: safe
- Per-class assessment: ROM/loader path placeholder


## Warning code 287013
- Total reviewed examples: 1
- Example 1
  - message: Variable or input pin "outclock" is defined but never used.
  - source: `/work/build/openfpga_genesis_analysis_work/src/fpga/db/dpram_f092.tdf`
  - line: 34
  - excerpt: missing source file in docs-only review path
  - assessment: intentional unused/stub/interface placeholder
  - reasoning: No deterministic runtime semantics currently expected from this path in this scaffold pass; does not directly indicate a fitter blocker by itself.
  - likely safe for first fitter smoke gate: needs more evidence
- Per-code disposition: needs more review
- Per-class assessment: intentional unused/stub/interface placeholder


## Gate disposition from source review
- safe codes: 3
- needs-more-review codes: 7
- blocked codes: 0
- decision: **REVIEW_WARNINGS_FIRST**

### Open decision notes
- This review pass does not edit imported third-party RTL.
- No change in Sega CD, 32X, or host-per-read ROM streaming behavior is implied.
- Keep runtime stub status as placeholder-only for this task.
