module apf_genesis_base
(
	input  logic         clk_50,
	input  logic         reset_n,

	// APF data-slot ROM bus contract.
	// rom_slot_addr: byte-oriented address requested by core logic.
	// rom_slot_data: 16-bit word sampled when rom_slot_ack is true.
	// rom_slot_valid: host can provide valid 16-bit data for requested word.
	// rom_slot_ready: high when cartridge image is present.
	output logic [24:1]  rom_slot_addr,
	output logic         rom_slot_req,
	input  logic         rom_slot_ready,
	input  logic [15:0]  rom_slot_data,
	input  logic         rom_slot_valid,

	// One controller (12-bit Genesis-style pad vector).
	input  logic [11:0]  pad1,

	// Genesis video outputs.
	output logic [7:0]   video_r,
	output logic [7:0]   video_g,
	output logic [7:0]   video_b,
	output logic         video_hsync,
	output logic         video_vsync,
	output logic         video_de,

	// Genesis audio outputs.
	output logic [15:0]  audio_left,
	output logic [15:0]  audio_right
);
	// Internal feasibility wrapper only: not the final APF top module.

	// Core status and ROM path controls.
	// TODO: Runtime ROM must come from local memory buffering, not APF host-per-read in final design.
	// Keep loading low until host indicates ROM data slot is available.
	wire loading = ~rom_slot_ready;

	// Core timing and core glue.
	wire [1:0] lpf_mode = 2'b00;
	wire       enable_fm = 1'b1;
	wire       enable_psg = 1'b1;

	wire       pal = 1'b0;
	// TODO: Sega CD integration deferred.
	wire       export = 1'b0;
	wire       fast_fifo = 1'b0;
	// TODO: SRAM/save support deferred for this milestone.
	wire       sram_quirk = 1'b0;
	wire       sram00_quirk = 1'b0;
	wire       eeprom_quirk = 1'b0;
	wire       noram_quirk = 1'b0;
	wire       pier_quirk = 1'b0;
	// TODO: SVP disabled for Genesis-only milestone.
	wire       svp_quirk = 1'b0;
	wire       fmbusy_quirk = 1'b0;
	wire       schan_quirk = 1'b0;
	wire [1:0] turbo = 2'b00;

	wire        gg_reset = 1'b0;
	wire        gg_en = 1'b0;
	wire [128:0] gg_code = 129'h0;
	wire        gg_available;

	wire [14:0] bram_a = 15'h0000;
	wire [15:0] bram_di = 16'h0000;
	wire [15:0] bram_do;
	wire        bram_we = 1'b0;
	wire        bram_change;

	// Memory bus.
	// TODO: ROM_SIZE is a placeholder while local ROM pipeline/memory controller is deferred.
	wire [24:1] rom_size_placeholder = 24'h400000;
	wire [24:1] rom_addr;
	wire [15:0] rom_data = rom_slot_data;
	wire [15:0] rom_wdata;
	wire        rom_we;
	wire  [1:0] rom_be;
	wire        rom_req;
	wire        rom_ack = (rom_slot_req && rom_slot_valid);
	// TODO: ROM_ADDR2 disabled/stubbed for first milestone.
	wire [24:1] rom_addr2 = 24'h000000;
	wire [15:0] rom_data2 = 16'hFFFF;
	wire        rom_req2 = 1'b0;
	wire        rom_ack2 = 1'b0;

	assign rom_slot_addr = rom_addr;
	assign rom_slot_req  = rom_req;

	// System side bus/status inputs.
	wire [23:0]  dbg_m68k_a;
	wire [23:0]  dbg_vbus_a;
	wire [7:0]   serjoy_in = 8'h00;
	wire [7:0]   serjoy_out;
	wire [1:0]   ser_opt = 2'b00;
	wire         lightgun_mode = 1'b0;
	wire         lightgun_type = 1'b0;
	wire         lightgun_sensor = 1'b0;
	wire         lightgun_a = 1'b0;
	wire         lightgun_b = 1'b0;
	wire         lightgun_c = 1'b0;
	wire         lightgun_start = 1'b0;
	// Mouse bus width set to match rtl/system.sv port declaration ([24:0]).
	wire [24:0]  mouse = 25'b0;
	wire [2:0]   mouse_opt = 3'b000;

	// Audio/video outputs from base system.
	wire [15:0] dac_l;
	wire [15:0] dac_r;
	wire  [3:0] red;
	wire  [3:0] green;
	wire  [3:0] blue;
	wire        vs;
	wire        hs;
	wire        hbl;
	wire        vbl;
	wire        ce_pix;
	wire        interlace;
	wire        field;
	wire  [1:0] resolution;

	system u_genesis(
		.RESET_N    (reset_n),
		.MCLK       (clk_50),
		.LPF_MODE   (lpf_mode),
		.ENABLE_FM  (enable_fm),
		.ENABLE_PSG (enable_psg),
		.DAC_LDATA  (dac_l),
		.DAC_RDATA  (dac_r),
		.LOADING    (loading),
		.PAL        (pal),
		.EXPORT     (export),
		.FAST_FIFO  (fast_fifo),
		.SRAM_QUIRK (sram_quirk),
		.SRAM00_QUIRK(sram00_quirk),
		.EEPROM_QUIRK(eeprom_quirk),
		.NORAM_QUIRK (noram_quirk),
		.PIER_QUIRK (pier_quirk),
		.SVP_QUIRK (svp_quirk),
		.FMBUSY_QUIRK(fmbusy_quirk),
		.SCHAN_QUIRK(schan_quirk),
		.TURBO      (turbo),
		.GG_RESET   (gg_reset),
		.GG_EN      (gg_en),
		.GG_CODE    (gg_code),
		.GG_AVAILABLE(gg_available),
		.BRAM_A     (bram_a),
		.BRAM_DI    (bram_di),
		.BRAM_DO    (bram_do),
		.BRAM_WE    (bram_we),
		.BRAM_CHANGE(bram_change),
		.RED        (red),
		.GREEN      (green),
		.BLUE       (blue),
		.VS         (vs),
		.HS         (hs),
		.HBL        (hbl),
		.VBL        (vbl),
		.CE_PIX     (ce_pix),
		.BORDER     (1'b0),
		.CRAM_DOTS  (1'b0),
		.INTERLACE  (interlace),
		.FIELD      (field),
		.RESOLUTION (resolution),
		.J3BUT      (1'b0),
		.JOY_1      (pad1),
		.JOY_2      (12'b0000_0000_0000),
		.JOY_3      (12'b0000_0000_0000),
		.JOY_4      (12'b0000_0000_0000),
		.JOY_5      (12'b0000_0000_0000),
		.MULTITAP   (3'd0),
		.MOUSE      (mouse),
		.MOUSE_OPT  (mouse_opt),
		.GUN_OPT    (lightgun_mode),
		.GUN_TYPE   (lightgun_type),
		.GUN_SENSOR (lightgun_sensor),
		.GUN_A      (lightgun_a),
		.GUN_B      (lightgun_b),
		.GUN_C      (lightgun_c),
		.GUN_START  (lightgun_start),
		.SERJOYSTICK_IN (serjoy_in),
		.SERJOYSTICK_OUT(serjoy_out),
		.SER_OPT        (ser_opt),
		.ROMSZ          (rom_size_placeholder),
		.ROM_ADDR       (rom_addr),
		.ROM_DATA       (rom_data),
		.ROM_WDATA      (rom_wdata),
		.ROM_WE         (rom_we),
		.ROM_BE         (rom_be),
		.ROM_REQ        (rom_req),
		.ROM_ACK        (rom_ack),
		.ROM_ADDR2      (rom_addr2),
		.ROM_DATA2      (rom_data2),
		.ROM_REQ2       (rom_req2),
		.ROM_ACK2       (rom_ack2),
		.EN_HIFI_PCM    (1'b0),
		.LADDER         (1'b0),
		.OBJ_LIMIT_HIGH (1'b0),
		.TRANSP_DETECT  (),
		.PAUSE_EN       (1'b0),
		.BGA_EN         (1'b0),
		.BGB_EN         (1'b0),
		.SPR_EN         (1'b0),
		.DBG_M68K_A      (dbg_m68k_a),
		.DBG_VBUS_A      (dbg_vbus_a)
	);

	// 4-bit output color -> 8-bit output color.
	always_comb begin
		video_r = {red, red};
		video_g = {green, green};
		video_b = {blue, blue};
		video_hsync = hs;
		video_vsync = vs;
		video_de = ~hbl & ~vbl & ce_pix;
		audio_left = dac_l;
		audio_right = dac_r;
	end

endmodule
