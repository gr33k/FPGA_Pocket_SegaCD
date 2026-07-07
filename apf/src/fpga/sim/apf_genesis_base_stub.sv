module apf_genesis_base #(
    parameter CLK_50_FREQ_HZ = 50000000
)(
    input  wire        clk_50,
    input  wire        reset_n,
    output reg  [24:1] rom_slot_addr,
    output reg         rom_slot_req,
    input  wire        rom_slot_ready,
    input  wire [15:0] rom_slot_data,
    input  wire        rom_slot_valid,
    input  wire [11:0] pad1,
    output wire [7:0]  video_r,
    output wire [7:0]  video_g,
    output wire [7:0]  video_b,
    output wire        video_hsync,
    output wire        video_vsync,
    output wire        video_de,
    output wire [15:0] audio_left,
    output wire [15:0] audio_right
);
    // This file is simulation/elaboration-only.
    // It must never replace the real apf/apf_genesis_base.sv boundary in runtime builds.

    // Keep connected runtime signals explicit to avoid unused-logic surprises in simulators.
    (* keep *) wire _unused_rom_slot_ready = rom_slot_ready;
    (* keep *) wire [15:0] _unused_rom_slot_data = rom_slot_data;
    (* keep *) wire _unused_rom_slot_valid = rom_slot_valid;
    (* keep *) wire [11:0] _unused_pad1 = pad1;
    (* keep *) wire _unused_reset_n = reset_n;

    always @(posedge clk_50 or negedge reset_n) begin
        if (!reset_n) begin
            rom_slot_addr <= 24'd0;
            rom_slot_req  <= 1'b0;
        end else begin
            rom_slot_addr <= 24'd0;
            rom_slot_req  <= 1'b0;
        end
    end

    assign video_r       = 8'h00;
    assign video_g       = 8'h00;
    assign video_b       = 8'h00;
    assign video_hsync   = 1'b0;
    assign video_vsync   = 1'b0;
    assign video_de      = 1'b0;
    assign audio_left    = 16'h0000;
    assign audio_right   = 16'h0000;

    initial begin
        rom_slot_addr = 24'd0;
        rom_slot_req  = 1'b0;
    end
endmodule
