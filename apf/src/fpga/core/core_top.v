module core_top
(
	// APF clocks (single clock required for this feasibility milestone).
	input  logic clk_50,
	input  logic clk_74a,

	// Pocket-facing reset.
	input  logic reset_n,

	// --- Stub bridge interface ---
	// Reserved for APF host bridge transactions. Not implemented in this milestone.
	input  logic        bridge_sel,
	input  logic        bridge_rd,
	input  logic        bridge_wr,
	input  logic [15:0] bridge_addr,
	input  logic [15:0] bridge_wdata,
	output logic        bridge_ready,
	output logic [15:0] bridge_rdata,
	output logic        bridge_valid,

	// --- Stub controller adapter ---
	// One 12-bit Genesis-compatible pad is expected. Additional ports are reserved.
	input  logic [11:0] pad1_raw,
	input  logic [11:0] pad2_raw,
	output logic [11:0] pad2_safety,

	// --- Stub ROM preload interface ---
	// Real ROM preloader/memory arbitration is intentionally deferred.
	output logic [24:1] rom_slot_addr,
	output logic        rom_slot_req,
	input  logic        rom_slot_ready,
	input  logic [15:0] rom_slot_data,
	input  logic        rom_slot_valid,

	// Unused APF-facing pins tied off in this skeleton.
	input  logic [7:0]  apf_unused_in,
	output logic [7:0]  apf_unused_out,
	input  logic [3:0]  apf_unused_flags,
	output logic [3:0]  apf_unused_flag_out,

	// Genesis video outputs.
	output logic [7:0] video_r,
	output logic [7:0] video_g,
	output logic [7:0] video_b,
	output logic       video_hsync,
	output logic       video_vsync,
	output logic       video_de,

	// Genesis audio outputs.
	output logic [15:0] audio_left,
	output logic [15:0] audio_right
);

	// Keep the outer reset as a direct pass-through for this milestone.
	wire core_reset_n = reset_n;

	// No bridge behavior is implemented yet.
	assign bridge_ready = 1'b1;
	assign bridge_valid = 1'b0;
	assign bridge_rdata = 16'h0000;

	// Reserve second port; keep deterministic value and avoid X propagation.
	assign pad2_safety = 12'h000;

	// Safely tie all unsupported/unused APF pins off.
	assign apf_unused_out = 8'h00;
	assign apf_unused_flag_out = {4{1'b0}};

	// 1:1 Genesis wrapper instantiation.
	apf_genesis_base u_apf_genesis_base(
		.clk_50      (clk_50),
		.reset_n     (core_reset_n),
		.rom_slot_addr(rom_slot_addr),
		.rom_slot_req (rom_slot_req),
		.rom_slot_ready(rom_slot_ready),
		.rom_slot_data(rom_slot_data),
		.rom_slot_valid(rom_slot_valid),
		.pad1        (pad1_raw),
		.video_r     (video_r),
		.video_g     (video_g),
		.video_b     (video_b),
		.video_hsync (video_hsync),
		.video_vsync (video_vsync),
		.video_de    (video_de),
		.audio_left  (audio_left),
		.audio_right (audio_right)
	);

	// TODO: bridge transactions are intentionally stubbed in this milestone.
	// TODO: controller adapter for non-Genesis controllers and advanced mapping is deferred.
	// TODO: ROM preload memory arbitration and buffering are deferred.
	// TODO: clk_74a is accepted but not yet used; can be wired to derived clocks later.

endmodule
