module core_top #(
    parameter ENABLE_GENESIS_STUB_RUN = 1'b0
)(
    // physical connections
    input   wire            clk_74a,
    input   wire            clk_74b,

    // cartridge interface
    // switches between 3.3v and 5v mechanically
    // output enable for multibit translators controlled by pic32

    // GBA AD[15:8]
    inout   wire    [7:0]   cart_tran_bank2,
    output  wire            cart_tran_bank2_dir,

    // GBA AD[7:0]
    inout   wire    [7:0]   cart_tran_bank3,
    output  wire            cart_tran_bank3_dir,

    // GBA A[23:16]
    inout   wire    [7:0]   cart_tran_bank1,
    output  wire            cart_tran_bank1_dir,

    // GBA [7] PHI#
    // GBA [6] WR#
    // GBA [5] RD#
    // GBA [4] CS1#/CS#
    // [3:0] unwired
    inout   wire    [7:4]   cart_tran_bank0,
    output  wire            cart_tran_bank0_dir,

    // GBA CS2#/RES#
    inout   wire            cart_tran_pin30,
    output  wire            cart_tran_pin30_dir,
    output  wire            cart_pin30_pwroff_reset,

    // GBA IRQ/DRQ
    inout   wire            cart_tran_pin31,
    output  wire            cart_tran_pin31_dir,

    // infrared
    input   wire            port_ir_rx,
    output  wire            port_ir_tx,
    output  wire            port_ir_rx_disable,

    // GBA link port
    inout   wire            port_tran_si,
    output  wire            port_tran_si_dir,
    inout   wire            port_tran_so,
    output  wire            port_tran_so_dir,
    inout   wire            port_tran_sck,
    output  wire            port_tran_sck_dir,
    inout   wire            port_tran_sd,
    output  wire            port_tran_sd_dir,

    // cartridge/sdram/ram external buses
    output  wire    [21:16] cram0_a,
    inout   wire    [15:0]  cram0_dq,
    input   wire            cram0_wait,
    output  wire            cram0_clk,
    output  wire            cram0_adv_n,
    output  wire            cram0_cre,
    output  wire            cram0_ce0_n,
    output  wire            cram0_ce1_n,
    output  wire            cram0_oe_n,
    output  wire            cram0_we_n,
    output  wire            cram0_ub_n,
    output  wire            cram0_lb_n,

    output  wire    [21:16] cram1_a,
    inout   wire    [15:0]  cram1_dq,
    input   wire            cram1_wait,
    output  wire            cram1_clk,
    output  wire            cram1_adv_n,
    output  wire            cram1_cre,
    output  wire            cram1_ce0_n,
    output  wire            cram1_ce1_n,
    output  wire            cram1_oe_n,
    output  wire            cram1_we_n,
    output  wire            cram1_ub_n,
    output  wire            cram1_lb_n,

    output  wire    [12:0]  dram_a,
    output  wire    [1:0]   dram_ba,
    inout   wire    [15:0]  dram_dq,
    output  wire    [1:0]   dram_dqm,
    output  wire            dram_clk,
    output  wire            dram_cke,
    output  wire            dram_ras_n,
    output  wire            dram_cas_n,
    output  wire            dram_we_n,

    output  wire    [16:0]  sram_a,
    inout   wire    [15:0]  sram_dq,
    output  wire            sram_oe_n,
    output  wire            sram_we_n,
    output  wire            sram_ub_n,
    output  wire            sram_lb_n,

    // vblank driven by dock for sync in a certain mode
    input   wire            vblank,

    // i/o to serial debug output
    output  wire            dbg_tx,
    input   wire            dbg_rx,

    // user pad I/O near jtag connector
    output  wire            user1,
    input   wire            user2,

    // RFU internal i2c bus
    inout   wire            aux_sda,
    output  wire            aux_scl,

    // RFU
    output  wire            vpll_feed,

    // logical connections
    output  wire    [23:0]  video_rgb,
    output  wire            video_rgb_clock,
    output  wire            video_rgb_clock_90,
    output  wire            video_de,
    output  wire            video_skip,
    output  wire            video_vs,
    output  wire            video_hs,

    output  wire            audio_mclk,
    input   wire            audio_adc,
    output  wire            audio_dac,
    output  wire            audio_lrck,

    output  wire            bridge_endian_little,
    input   wire    [31:0]  bridge_addr,
    input   wire            bridge_rd,
    output  wire    [31:0]  bridge_rd_data,
    input   wire            bridge_wr,
    input   wire    [31:0]  bridge_wr_data,

    input   wire    [31:0]  cont1_key,
    input   wire    [31:0]  cont2_key,
    input   wire    [31:0]  cont3_key,
    input   wire    [31:0]  cont4_key,
    input   wire    [31:0]  cont1_joy,
    input   wire    [31:0]  cont2_joy,
    input   wire    [31:0]  cont3_joy,
    input   wire    [31:0]  cont4_joy,
    input   wire    [15:0]  cont1_trig,
    input   wire    [15:0]  cont2_trig,
    input   wire    [15:0]  cont3_trig,
    input   wire    [15:0]  cont4_trig
);

    // Conservative reset/preload state machine stub (no real APF data preload path yet).
    localparam [1:0]
        WAIT_APF_RESET_RELEASE = 2'd0,
        WAIT_PLL_LOCK          = 2'd1,
        WAIT_ROM_PRELOAD       = 2'd2,
        RUN                    = 2'd3;

    // TODO(Task 5A): connect to real APF reset source when available.
    wire apf_reset_released = 1'b1;
    // TODO(Task 5A): replace with real PLL lock input when integrated.
    wire pll_locked_stub    = 1'b1;
    // TODO(Task 5A): replace with real ROM preload completion once implemented.
    wire rom_preload_done_stub = 1'b0;

    wire rom_preload_done = ENABLE_GENESIS_STUB_RUN ? 1'b1 : rom_preload_done_stub;
    reg [1:0] core_reset_state;

    // Conservative local-state default for deterministic boot scaffolding.
    initial core_reset_state = WAIT_APF_RESET_RELEASE;

    always @(posedge clk_74a) begin
        case (core_reset_state)
            WAIT_APF_RESET_RELEASE: core_reset_state <= apf_reset_released ? WAIT_PLL_LOCK : WAIT_APF_RESET_RELEASE;
            WAIT_PLL_LOCK:          core_reset_state <= pll_locked_stub ? WAIT_ROM_PRELOAD : WAIT_PLL_LOCK;
            WAIT_ROM_PRELOAD:       core_reset_state <= rom_preload_done ? RUN : WAIT_ROM_PRELOAD;
            RUN:                    core_reset_state <= RUN;
            default:                core_reset_state <= WAIT_APF_RESET_RELEASE;
        endcase
    end

    wire core_reset_n = (core_reset_state == RUN);

    // keep unused control words visible to avoid aggressive optimization of inputs.
    (* keep *) wire _unused_bridge_addr   = bridge_addr[0];
    (* keep *) wire _unused_bridge_rd    = bridge_rd;
    (* keep *) wire _unused_bridge_wr    = bridge_wr;
    (* keep *) wire _unused_bridge_wdata = bridge_wr_data[0];
    (* keep *) wire _unused_cartridge_sig = cart_pin30_pwroff_reset;
    (* keep *) wire _unused_vblank       = vblank;
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

    // Bridge is intentionally stubbed in this milestone.
    assign bridge_endian_little = 1'b1;
    assign bridge_rd_data      = 32'h00000000;

    // IR/Future RFU pins are tied off safely.
    assign port_ir_tx         = 1'b0;
    assign port_ir_rx_disable = 1'b1;
    assign aux_sda            = 1'bz;
    assign aux_scl            = 1'b0;

    // Deterministic one-controller Genesis pad mapping (12-bit vector):
    // D-pad + A/B/C + Start; X/Y/Z/Mode deferred.
    wire [11:0] pad1;
    assign pad1[0]  = cont1_key[0];  // dpad up
    assign pad1[1]  = cont1_key[1];  // dpad down
    assign pad1[2]  = cont1_key[2];  // dpad left
    assign pad1[3]  = cont1_key[3];  // dpad right
    assign pad1[4]  = cont1_key[4];  // A
    assign pad1[5]  = cont1_key[5];  // B
    assign pad1[6]  = cont1_key[6];  // C
    assign pad1[7]  = cont1_key[15]; // Start
    assign pad1[8]  = cont1_key[14]; // Select / deferred
    assign pad1[9]  = cont1_trig[8]; // L / deferred
    assign pad1[10] = cont1_trig[0]; // R / deferred
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

    // ROM preload and memory arbitration are deferred (safety stub only).
    wire [24:1] rom_slot_addr;
    wire        rom_slot_req;
    wire        rom_slot_ready = 1'b0;
    wire [15:0] rom_slot_data  = 16'h0000;
    wire        rom_slot_valid = 1'b0;

    apf_genesis_base u_apf_genesis_base(
        .clk_50        (clk_74a),
        .reset_n       (core_reset_n),
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

    // Direct video passthrough from Genesis runtime.
    assign video_rgb        = {core_video_r, core_video_g, core_video_b};
    assign video_rgb_clock  = clk_74a;
    assign video_rgb_clock_90 = clk_74a;
    assign video_de         = core_video_de;
    assign video_hs         = core_video_hs;
    assign video_vs         = core_video_vs;
    assign video_skip       = 1'b0;

    // Audio serializer is intentionally stubbed for this milestone.
    reg [14:0] audio_clock_accum;
    reg        audio_clk_out;

    always @(posedge clk_74a) begin
        if (!core_reset_n) begin
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
    (* keep *) wire [15:0] _audio_left_unused  = core_audio_left;
    (* keep *) wire [15:0] _audio_right_unused = core_audio_right;

    // Unused cartridge interface pins to match template safe tie-off style.
    assign cart_tran_bank3    = 8'hzz;
    assign cart_tran_bank3_dir = 1'b0;
    assign cart_tran_bank2    = 8'hzz;
    assign cart_tran_bank2_dir = 1'b0;
    assign cart_tran_bank1    = 8'hzz;
    assign cart_tran_bank1_dir = 1'b0;
    assign cart_tran_bank0    = 4'hf;
    assign cart_tran_bank0_dir = 1'b0;
    assign cart_tran_pin30    = 1'b0;
    assign cart_tran_pin30_dir = 1'bz;
    assign cart_pin30_pwroff_reset = 1'b0;
    assign cart_tran_pin31    = 1'bz;
    assign cart_tran_pin31_dir = 1'b0;

    // Unused link port pins as safe template-style input-only defaults.
    assign port_tran_so       = 1'bz;
    assign port_tran_so_dir   = 1'b0;
    assign port_tran_si       = 1'bz;
    assign port_tran_si_dir   = 1'b0;
    assign port_tran_sck      = 1'bz;
    assign port_tran_sck_dir  = 1'b0;
    assign port_tran_sd       = 1'bz;
    assign port_tran_sd_dir   = 1'b0;

    // External memory pins are tied off while preload/memory controller is deferred.
    assign cram0_a     = 6'h00;
    assign cram0_dq    = {16{1'bZ}};
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
    assign cram1_dq    = {16{1'bZ}};
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
    assign dram_dq     = {16{1'bZ}};
    assign dram_dqm    = 2'b11;
    assign dram_clk    = 1'b0;
    assign dram_cke    = 1'b0;
    assign dram_ras_n  = 1'b1;
    assign dram_cas_n  = 1'b1;
    assign dram_we_n   = 1'b1;

    assign sram_a      = 17'h00000;
    assign sram_dq     = {16{1'bZ}};
    assign sram_oe_n   = 1'b1;
    assign sram_we_n   = 1'b1;
    assign sram_ub_n   = 1'b1;
    assign sram_lb_n   = 1'b1;

    assign dbg_tx = 1'bz;
    assign user1  = 1'bz;
    assign vpll_feed = 1'bz;

    // Keep deferred bus controls as retained paths.
    (* keep *) wire _unused_mem_wait = cram0_wait | cram1_wait;

endmodule
