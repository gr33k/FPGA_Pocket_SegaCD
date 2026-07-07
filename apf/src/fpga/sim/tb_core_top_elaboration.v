`timescale 1ns/1ps

module tb_core_top_elaboration;
    reg  clk_74a;
    reg  clk_74b;
    reg  vblank;
    reg  dbg_rx;
    reg  port_ir_rx;
    reg  user2;
    reg  cart_pin30_pwroff_reset;
    reg  cram0_wait;
    reg  cram1_wait;
    reg  audio_adc;
    reg  bridge_rd;
    reg [31:0] bridge_addr;
    reg [31:0] bridge_wr_data;
    reg  bridge_wr;
    reg [31:0] cont1_key;
    reg [31:0] cont2_key;
    reg [31:0] cont3_key;
    reg [31:0] cont4_key;
    reg [31:0] cont1_joy;
    reg [31:0] cont2_joy;
    reg [31:0] cont3_joy;
    reg [31:0] cont4_joy;
    reg [15:0] cont1_trig;
    reg [15:0] cont2_trig;
    reg [15:0] cont3_trig;
    reg [15:0] cont4_trig;

    wire [7:0]  cart_tran_bank2;
    wire [7:0]  cart_tran_bank3;
    wire [7:0]  cart_tran_bank1;
    wire [7:4]  cart_tran_bank0;
    wire        cart_tran_pin30;
    wire        cart_tran_pin31;
    wire        cart_tran_bank2_dir;
    wire        cart_tran_bank3_dir;
    wire        cart_tran_bank1_dir;
    wire        cart_tran_bank0_dir;
    wire        cart_tran_pin30_dir;
    wire        cart_tran_pin31_dir;

    wire        port_tran_si;
    wire        port_tran_so;
    wire        port_tran_sck;
    wire        port_tran_sd;
    wire        port_tran_si_dir;
    wire        port_tran_so_dir;
    wire        port_tran_sck_dir;
    wire        port_tran_sd_dir;

    wire [21:16] cram0_a;
    wire [15:0]  cram0_dq;
    wire         cram0_clk;
    wire         cram0_adv_n;
    wire         cram0_cre;
    wire         cram0_ce0_n;
    wire         cram0_ce1_n;
    wire         cram0_oe_n;
    wire         cram0_we_n;
    wire         cram0_ub_n;
    wire         cram0_lb_n;

    wire [21:16] cram1_a;
    wire [15:0]  cram1_dq;
    wire         cram1_clk;
    wire         cram1_adv_n;
    wire         cram1_cre;
    wire         cram1_ce0_n;
    wire         cram1_ce1_n;
    wire         cram1_oe_n;
    wire         cram1_we_n;
    wire         cram1_ub_n;
    wire         cram1_lb_n;

    wire [12:0]  dram_a;
    wire [1:0]   dram_ba;
    wire [15:0]  dram_dq;
    wire [1:0]   dram_dqm;
    wire         dram_clk;
    wire         dram_cke;
    wire         dram_ras_n;
    wire         dram_cas_n;
    wire         dram_we_n;

    wire [16:0]  sram_a;
    wire [15:0]  sram_dq;
    wire         sram_oe_n;
    wire         sram_we_n;
    wire         sram_ub_n;
    wire         sram_lb_n;

    wire         port_ir_tx;
    wire         port_ir_rx_disable;
    wire         dbg_tx;
    wire         user1;
    wire         aux_sda_wire;
    wire         aux_scl;
    wire         vpll_feed;

    wire [23:0]  video_rgb;
    wire         video_rgb_clock;
    wire         video_rgb_clock_90;
    wire         video_de;
    wire         video_skip;
    wire         video_vs;
    wire         video_hs;
    wire         audio_mclk;
    wire         audio_dac;
    wire         audio_lrck;
    wire         bridge_endian_little;
    wire [31:0]  bridge_rd_data;

    core_top #(
        .ENABLE_GENESIS_STUB_RUN       (1'b0),
        .ENABLE_PRELOAD_INGRESS_STUB   (1'b0),
        .ENABLE_FAKE_ROM_FOR_SMOKE_TEST(1'b0),
        .ENABLE_TINY_LOCAL_ROM_RAM    (1'b0)
    ) u_core_top(
        .clk_74a            (clk_74a),
        .clk_74b            (clk_74b),
        .cart_tran_bank2     (cart_tran_bank2),
        .cart_tran_bank2_dir (cart_tran_bank2_dir),
        .cart_tran_bank3     (cart_tran_bank3),
        .cart_tran_bank3_dir (cart_tran_bank3_dir),
        .cart_tran_bank1     (cart_tran_bank1),
        .cart_tran_bank1_dir (cart_tran_bank1_dir),
        .cart_tran_bank0     (cart_tran_bank0),
        .cart_tran_bank0_dir (cart_tran_bank0_dir),
        .cart_tran_pin30     (cart_tran_pin30),
        .cart_tran_pin30_dir (cart_tran_pin30_dir),
        .cart_pin30_pwroff_reset(cart_pin30_pwroff_reset),
        .cart_tran_pin31     (cart_tran_pin31),
        .cart_tran_pin31_dir (cart_tran_pin31_dir),
        .vblank              (vblank),
        .dbg_tx              (dbg_tx),
        .dbg_rx              (dbg_rx),
        .user1               (user1),
        .user2               (user2),
        .aux_sda             (aux_sda_wire),
        .aux_scl             (aux_scl),
        .vpll_feed           (vpll_feed),
        .port_ir_rx          (port_ir_rx),
        .port_ir_tx          (port_ir_tx),
        .port_ir_rx_disable  (port_ir_rx_disable),
        .port_tran_si        (port_tran_si),
        .port_tran_si_dir    (port_tran_si_dir),
        .port_tran_so        (port_tran_so),
        .port_tran_so_dir    (port_tran_so_dir),
        .port_tran_sck       (port_tran_sck),
        .port_tran_sck_dir   (port_tran_sck_dir),
        .port_tran_sd        (port_tran_sd),
        .port_tran_sd_dir    (port_tran_sd_dir),
        .cram0_a             (cram0_a),
        .cram0_dq            (cram0_dq),
        .cram0_wait          (cram0_wait),
        .cram0_clk           (cram0_clk),
        .cram0_adv_n         (cram0_adv_n),
        .cram0_cre           (cram0_cre),
        .cram0_ce0_n         (cram0_ce0_n),
        .cram0_ce1_n         (cram0_ce1_n),
        .cram0_oe_n          (cram0_oe_n),
        .cram0_we_n          (cram0_we_n),
        .cram0_ub_n          (cram0_ub_n),
        .cram0_lb_n          (cram0_lb_n),
        .cram1_a             (cram1_a),
        .cram1_dq            (cram1_dq),
        .cram1_wait          (cram1_wait),
        .cram1_clk           (cram1_clk),
        .cram1_adv_n         (cram1_adv_n),
        .cram1_cre           (cram1_cre),
        .cram1_ce0_n         (cram1_ce0_n),
        .cram1_ce1_n         (cram1_ce1_n),
        .cram1_oe_n          (cram1_oe_n),
        .cram1_we_n          (cram1_we_n),
        .cram1_ub_n          (cram1_ub_n),
        .cram1_lb_n          (cram1_lb_n),
        .dram_a              (dram_a),
        .dram_ba             (dram_ba),
        .dram_dq             (dram_dq),
        .dram_dqm            (dram_dqm),
        .dram_clk            (dram_clk),
        .dram_cke            (dram_cke),
        .dram_ras_n          (dram_ras_n),
        .dram_cas_n          (dram_cas_n),
        .dram_we_n           (dram_we_n),
        .sram_a              (sram_a),
        .sram_dq             (sram_dq),
        .sram_oe_n           (sram_oe_n),
        .sram_we_n           (sram_we_n),
        .sram_ub_n           (sram_ub_n),
        .sram_lb_n           (sram_lb_n),
        .video_rgb           (video_rgb),
        .video_rgb_clock     (video_rgb_clock),
        .video_rgb_clock_90  (video_rgb_clock_90),
        .video_de            (video_de),
        .video_skip          (video_skip),
        .video_vs            (video_vs),
        .video_hs            (video_hs),
        .audio_mclk          (audio_mclk),
        .audio_adc           (audio_adc),
        .audio_dac           (audio_dac),
        .audio_lrck          (audio_lrck),
        .bridge_endian_little (bridge_endian_little),
        .bridge_addr         (bridge_addr),
        .bridge_rd           (bridge_rd),
        .bridge_rd_data      (bridge_rd_data),
        .bridge_wr           (bridge_wr),
        .bridge_wr_data      (bridge_wr_data),
        .cont1_key           (cont1_key),
        .cont2_key           (cont2_key),
        .cont3_key           (cont3_key),
        .cont4_key           (cont4_key),
        .cont1_joy           (cont1_joy),
        .cont2_joy           (cont2_joy),
        .cont3_joy           (cont3_joy),
        .cont4_joy           (cont4_joy),
        .cont1_trig          (cont1_trig),
        .cont2_trig          (cont2_trig),
        .cont3_trig          (cont3_trig),
        .cont4_trig          (cont4_trig)
    );

    always #5 clk_74a = ~clk_74a;
    always #5 clk_74b = ~clk_74b;

    initial begin
        clk_74a = 1'b0;
        clk_74b = 1'b1;

        vblank = 1'b0;
        dbg_rx = 1'b0;
        port_ir_rx = 1'b0;
        user2 = 1'b0;
        cart_pin30_pwroff_reset = 1'b0;
        cram0_wait = 1'b0;
        cram1_wait = 1'b0;
        bridge_rd = 1'b0;
        bridge_wr = 1'b0;
        bridge_addr = 32'd0;
        bridge_wr_data = 32'd0;

        cont1_key = 32'd0;
        cont2_key = 32'd0;
        cont3_key = 32'd0;
        cont4_key = 32'd0;
        cont1_joy = 32'd0;
        cont2_joy = 32'd0;
        cont3_joy = 32'd0;
        cont4_joy = 32'd0;
        cont1_trig = 16'd0;
        cont2_trig = 16'd0;
        cont3_trig = 16'd0;
        cont4_trig = 16'd0;
        audio_adc = 1'b0;

        repeat (8) @(posedge clk_74a);

        if (bridge_rd_data !== 32'h00000000) begin
            $display("FAIL: bridge_rd_data expected 0 in inert bridge stub mode.");
            $fatal(1);
        end
        if (video_rgb !== 24'h000000) begin
            $display("FAIL: video_rgb expected 0 in inert mode.");
            $fatal(1);
        end
        if (video_de !== 1'b0 || video_skip !== 1'b0 || video_hs !== 1'b0 || video_vs !== 1'b0) begin
            $display("FAIL: deterministic video sync/control is not all zero.");
            $fatal(1);
        end
        if (video_rgb_clock !== clk_74a || video_rgb_clock_90 !== clk_74a) begin
            $display("FAIL: video clocks not driven by clk_74a.");
            $fatal(1);
        end

        $display("PASS: core_top elaboration smoke test PASSED (inert/sim stub mode)");
        $finish;
    end
endmodule
