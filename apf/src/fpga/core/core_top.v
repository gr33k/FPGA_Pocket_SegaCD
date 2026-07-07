module core_top
(
    // APF clocks.
    input  wire         clk_74a,
    input  wire         clk_74b,

    // APF reset.
    input  wire         reset_n,

    // External cartridge/link/IR pins (present for template compatibility, not used this milestone).
    input  wire [31:0]  cartridge,
    input  wire         link,
    input  wire         port_ir_rx,
    output wire         port_ir_tx,
    output wire         port_ir_rx_disable,

    // PSRAM0 pins.
    output wire [21:16] cram0_a,
    inout  wire [15:0]  cram0_dq,
    input  wire         cram0_wait,
    output wire         cram0_clk,
    output wire         cram0_adv_n,
    output wire         cram0_cre,
    output wire         cram0_ce0_n,
    output wire         cram0_ce1_n,
    output wire         cram0_oe_n,
    output wire         cram0_we_n,
    output wire         cram0_ub_n,
    output wire         cram0_lb_n,

    // PSRAM1 pins.
    output wire [21:16] cram1_a,
    inout  wire [15:0]  cram1_dq,
    input  wire         cram1_wait,
    output wire         cram1_clk,
    output wire         cram1_adv_n,
    output wire         cram1_cre,
    output wire         cram1_ce0_n,
    output wire         cram1_ce1_n,
    output wire         cram1_oe_n,
    output wire         cram1_we_n,
    output wire         cram1_ub_n,
    output wire         cram1_lb_n,

    // SDRAM pins.
    output wire [12:0]  dram_a,
    output wire [1:0]   dram_ba,
    inout  wire [15:0]  dram_dq,
    output wire [1:0]   dram_dqm,
    output wire         dram_clk,
    output wire         dram_cke,
    output wire         dram_ras_n,
    output wire         dram_cas_n,
    output wire         dram_we_n,

    // SRAM pins.
    output wire [16:0]  sram_a,
    inout  wire [15:0]  sram_dq,
    output wire         sram_oe_n,
    output wire         sram_we_n,
    output wire         sram_ub_n,
    output wire         sram_lb_n,

    // RFU I2C.
    inout  wire         aux_sda,
    output wire         aux_scl,

    // Bridge bus.
    output wire         bridge_endian_little,
    input  wire [31:0]  bridge_addr,
    input  wire         bridge_rd,
    output wire [31:0]  bridge_rd_data,
    input  wire         bridge_wr,
    input  wire [31:0]  bridge_wr_data,

    // PAD controller data.
    input  wire [31:0]  cont1_key,
    input  wire [31:0]  cont2_key,
    input  wire [31:0]  cont3_key,
    input  wire [31:0]  cont4_key,
    input  wire [31:0]  cont1_joy,
    input  wire [31:0]  cont2_joy,
    input  wire [31:0]  cont3_joy,
    input  wire [31:0]  cont4_joy,
    input  wire [15:0]  cont1_trig,
    input  wire [15:0]  cont2_trig,
    input  wire [15:0]  cont3_trig,
    input  wire [15:0]  cont4_trig,

    // Video.
    output wire [23:0]  video_rgb,
    output wire         video_rgb_clock,
    output wire         video_rgb_clock_90,
    output wire         video_de,
    output wire         video_skip,
    output wire         video_vs,
    output wire         video_hs,

    // Audio.
    output wire         audio_mclk,
    input  wire         audio_adc,
    output wire         audio_dac,
    output wire         audio_lrck
);

    // Stub/unused input sink wires keep integration pins visible while not used in this milestone.
    (* keep *) wire _unused_bridge_addr   = bridge_addr[0];
    (* keep *) wire _unused_bridge_rd    = bridge_rd;
    (* keep *) wire _unused_bridge_wr    = bridge_wr;
    (* keep *) wire _unused_bridge_wdata = bridge_wr_data[0];
    (* keep *) wire _unused_cartridge    = ^cartridge;
    (* keep *) wire _unused_link         = link;
    (* keep *) wire _unused_ir_rx        = port_ir_rx;
    (* keep *) wire _unused_key2         = cont2_key[0];
    (* keep *) wire _unused_key3         = cont3_key[0];
    (* keep *) wire _unused_key4         = cont4_key[0];
    (* keep *) wire _unused_joy2         = cont2_joy[0];
    (* keep *) wire _unused_joy3         = cont3_joy[0];
    (* keep *) wire _unused_joy4         = cont4_joy[0];
    (* keep *) wire _unused_trig2        = cont2_trig[0];
    (* keep *) wire _unused_trig3        = cont3_trig[0];
    (* keep *) wire _unused_trig4        = cont4_trig[0];

    // Bridge is stubbed in this milestone.
    assign bridge_endian_little = 1'b1;
    assign bridge_rd_data      = 32'h00000000;

    // IR/Future RFU pins are tied off safely.
    assign port_ir_tx         = 1'b0;
    assign port_ir_rx_disable = 1'b0;
    assign aux_sda            = 1'bz;
    assign aux_scl            = 1'b0;

    // Deterministic one-controller Genesis pad mapping (12-bit vector):
    // dpad and A/B/C + Start are mapped. X/Y/Z/Mode left for later.
    wire [11:0] pad1;
    assign pad1[0] = cont1_key[0];  // dpad up
    assign pad1[1] = cont1_key[1];  // dpad down
    assign pad1[2] = cont1_key[2];  // dpad left
    assign pad1[3] = cont1_key[3];  // dpad right
    assign pad1[4] = cont1_key[4];  // A
    assign pad1[5] = cont1_key[5];  // B
    assign pad1[6] = cont1_key[6];  // C
    assign pad1[7] = cont1_key[15]; // Start
    assign pad1[8] = cont1_key[14]; // Select (deferred mapping)
    assign pad1[9] = cont1_trig[8]; // L (deferred)
    assign pad1[10] = cont1_trig[0]; // R (deferred)
    assign pad1[11] = 1'b0;

    // Deterministic local outputs.
    wire [7:0]  core_video_r;
    wire [7:0]  core_video_g;
    wire [7:0]  core_video_b;
    wire        core_video_de;
    wire        core_video_hs;
    wire        core_video_vs;
    wire [15:0] core_audio_left;
    wire [15:0] core_audio_right;

    // ROM preloader and memory arbitration are deferred (safety stub only).
    wire [24:1] rom_slot_addr;
    wire        rom_slot_req;
    wire        rom_slot_ready = 1'b0;
    wire [15:0] rom_slot_data  = 16'h0000;
    wire        rom_slot_valid = 1'b0;

    apf_genesis_base u_apf_genesis_base(
        .clk_50        (clk_74a),
        .reset_n       (reset_n),
        .rom_slot_addr (rom_slot_addr),
        .rom_slot_req  (rom_slot_req),
        .rom_slot_ready(rom_slot_ready),
        .rom_slot_data (rom_slot_data),
        .rom_slot_valid(rom_slot_valid),
        .pad1          (pad1),
        .video_r       (core_video_r),
        .video_g       (core_video_g),
        .video_b       (core_video_b),
        .video_hsync   (core_video_hs),
        .video_vsync   (core_video_vs),
        .video_de      (core_video_de),
        .audio_left    (core_audio_left),
        .audio_right   (core_audio_right)
    );

    // Keep ROM request/address signals alive for eventual loader implementation.
    (* keep *) wire _rom_slot_addr_active = |rom_slot_addr;
    (* keep *) wire _rom_slot_req_active  = rom_slot_req;

    // Direct raw video passthrough.
    assign video_rgb       = {core_video_r, core_video_g, core_video_b};
    assign video_rgb_clock = clk_74a;
    assign video_rgb_clock_90 = clk_74a;
    assign video_de        = core_video_de;
    assign video_hs        = core_video_hs;
    assign video_vs        = core_video_vs;
    assign video_skip      = 1'b0;

    // Audio serializer/dac path is intentionally stubbed for this milestone.
    // Keep a deterministic 12.288 MHz-like clock generator.
    reg [14:0] audio_clock_accum;
    reg        audio_clk_out;

    always @(posedge clk_74a or negedge reset_n) begin
        if (!reset_n) begin
            audio_clock_accum <= 15'd0;
            audio_clk_out     <= 1'b0;
        end else begin
            audio_clock_accum <= audio_clock_accum + 15'd2048;
            if (audio_clock_accum >= 15'd12375) begin
                audio_clock_accum <= audio_clock_accum - 15'd12375 + 15'd2048;
                audio_clk_out     <= ~audio_clk_out;
            end
        end
    end

    assign audio_mclk = audio_clk_out;
    assign audio_dac  = 1'b0;
    assign audio_lrck = 1'b0;

    // Keep imported audio path visible for later binding.
    (* keep *) wire [15:0] _audio_left_unused = core_audio_left;
    (* keep *) wire [15:0] _audio_right_unused = core_audio_right;

    // External memory pins are tied off as this milestone does not implement memory controller.
    assign cram0_a     = 6'h00;
    assign cram0_dq    = 16'h0000;
    assign cram0_clk   = 1'b0;
    assign cram0_adv_n = 1'b1;
    assign cram0_cre   = 1'b0;
    assign cram0_ce0_n = 1'b1;
    assign cram0_ce1_n = 1'b1;
    assign cram0_oe_n  = 1'b1;
    assign cram0_we_n  = 1'b1;
    assign cram0_ub_n  = 1'b1;
    assign cram0_lb_n  = 1'b1;

    assign cram1_a     = 6'h00;
    assign cram1_dq    = 16'h0000;
    assign cram1_clk   = 1'b0;
    assign cram1_adv_n = 1'b1;
    assign cram1_cre   = 1'b0;
    assign cram1_ce0_n = 1'b1;
    assign cram1_ce1_n = 1'b1;
    assign cram1_oe_n  = 1'b1;
    assign cram1_we_n  = 1'b1;
    assign cram1_ub_n  = 1'b1;
    assign cram1_lb_n  = 1'b1;

    assign dram_a      = 13'h0000;
    assign dram_ba     = 2'b00;
    assign dram_dq     = 16'h0000;
    assign dram_dqm    = 2'b11;
    assign dram_clk    = 1'b0;
    assign dram_cke    = 1'b0;
    assign dram_ras_n  = 1'b1;
    assign dram_cas_n  = 1'b1;
    assign dram_we_n   = 1'b1;

    assign sram_a      = 17'h00000;
    assign sram_dq     = 16'h0000;
    assign sram_oe_n   = 1'b1;
    assign sram_we_n   = 1'b1;
    assign sram_ub_n   = 1'b1;
    assign sram_lb_n   = 1'b1;

    // Also keep explicit read of deferred bus controls so ports are retained.
    (* keep *) wire _unused_mem_wait = cram0_wait | cram1_wait;

endmodule
