//
// Pocket MegaCD probe core top
// Derived from openFPGA-Genesis Pocket shell and MegaCD_MiSTer donor wiring.
//
`default_nettype none

module core_top (
input   wire            clk_74a,
input   wire            clk_74b,
inout   wire    [7:0]   cart_tran_bank2,
output  wire            cart_tran_bank2_dir,
inout   wire    [7:0]   cart_tran_bank3,
output  wire            cart_tran_bank3_dir,
inout   wire    [7:0]   cart_tran_bank1,
output  wire            cart_tran_bank1_dir,
inout   wire    [7:4]   cart_tran_bank0,
output  wire            cart_tran_bank0_dir,
inout   wire            cart_tran_pin30,
output  wire            cart_tran_pin30_dir,
output  wire            cart_pin30_pwroff_reset,
inout   wire            cart_tran_pin31,
output  wire            cart_tran_pin31_dir,
input   wire            port_ir_rx,
output  wire            port_ir_tx,
output  wire            port_ir_rx_disable,
inout   wire            port_tran_si,
output  wire            port_tran_si_dir,
inout   wire            port_tran_so,
output  wire            port_tran_so_dir,
inout   wire            port_tran_sck,
output  wire            port_tran_sck_dir,
inout   wire            port_tran_sd,
output  wire            port_tran_sd_dir,
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
input   wire            vblank,
output  wire            dbg_tx,
input   wire            dbg_rx,
output  wire            user1,
input   wire            user2,
inout   wire            aux_sda,
output  wire            aux_scl,
output  wire            vpll_feed,
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
output  reg     [31:0]  bridge_rd_data,
input   wire            bridge_wr,
input   wire    [31:0]  bridge_wr_data,
input   wire    [15:0]  cont1_key,
input   wire    [15:0]  cont2_key,
input   wire    [15:0]  cont3_key,
input   wire    [15:0]  cont4_key,
input   wire    [31:0]  cont1_joy,
input   wire    [31:0]  cont2_joy,
input   wire    [31:0]  cont3_joy,
input   wire    [31:0]  cont4_joy,
input   wire    [15:0]  cont1_trig,
input   wire    [15:0]  cont2_trig,
input   wire    [15:0]  cont3_trig,
input   wire    [15:0]  cont4_trig
);

assign port_ir_tx = 1'b0;
assign port_ir_rx_disable = 1'b1;
assign bridge_endian_little = 1'b0;
assign cart_tran_bank3 = 8'hzz; assign cart_tran_bank3_dir = 1'b0;
assign cart_tran_bank2 = 8'hzz; assign cart_tran_bank2_dir = 1'b0;
assign cart_tran_bank1 = 8'hzz; assign cart_tran_bank1_dir = 1'b0;
assign cart_tran_bank0 = 4'hf;  assign cart_tran_bank0_dir = 1'b1;
assign cart_tran_pin30 = 1'b0;  assign cart_tran_pin30_dir = 1'bz;
assign cart_pin30_pwroff_reset = 1'b0;
assign cart_tran_pin31 = 1'bz;  assign cart_tran_pin31_dir = 1'b0;
assign port_tran_so = 1'bz; assign port_tran_so_dir = 1'b0;
assign port_tran_si = 1'bz; assign port_tran_si_dir = 1'b0;
assign port_tran_sck = 1'bz; assign port_tran_sck_dir = 1'b0;
assign port_tran_sd = 1'bz; assign port_tran_sd_dir = 1'b0;
assign cram0_a = 'h0; assign cram0_dq = {16{1'bZ}}; assign cram0_clk = 1'b0; assign cram0_adv_n = 1'b1; assign cram0_cre = 1'b0; assign cram0_ce0_n = 1'b1; assign cram0_ce1_n = 1'b1; assign cram0_oe_n = 1'b1; assign cram0_we_n = 1'b1; assign cram0_ub_n = 1'b1; assign cram0_lb_n = 1'b1;
assign cram1_a = 'h0; assign cram1_dq = {16{1'bZ}}; assign cram1_clk = 1'b0; assign cram1_adv_n = 1'b1; assign cram1_cre = 1'b0; assign cram1_ce0_n = 1'b1; assign cram1_ce1_n = 1'b1; assign cram1_oe_n = 1'b1; assign cram1_we_n = 1'b1; assign cram1_ub_n = 1'b1; assign cram1_lb_n = 1'b1;
assign sram_a = 'h0; assign sram_dq = {16{1'bZ}}; assign sram_oe_n = 1'b1; assign sram_we_n = 1'b1; assign sram_ub_n = 1'b1; assign sram_lb_n = 1'b1;
assign dbg_tx = 1'bz; assign user1 = 1'bz; assign aux_scl = 1'bz; assign aux_sda = 1'bz; assign vpll_feed = 1'bz;
assign video_skip = 1'b0;

wire clk_sys, clk_ram, clk_vid_320, clk_vid_320_90deg, clk_vid_256, clk_vid_256_90deg, pll_core_locked;
mf_pllbase mp1 (
    .refclk(clk_74a), .rst(1'b0),
    .outclk_0(clk_sys), .outclk_1(clk_ram), .outclk_2(clk_vid_320), .outclk_3(clk_vid_320_90deg), .outclk_4(clk_vid_256), .outclk_5(clk_vid_256_90deg),
    .locked(pll_core_locked)
);

wire [31:0] cmd_bridge_rd_data;
wire dataslot_requestread, dataslot_requestwrite, dataslot_allcomplete;
wire [15:0] dataslot_requestread_id, dataslot_requestwrite_id;
wire [9:0] datatable_addr;
wire datatable_wren;
wire [31:0] datatable_data;
wire [31:0] datatable_q = 32'd0;
wire reset_n;
wire osnotify_inmenu;
wire savestate_supported = 1'b0;
wire [31:0] savestate_addr = 32'd0, savestate_size = 32'd0, savestate_maxloadsize = 32'd0;
wire savestate_start, savestate_start_ack = 1'b0, savestate_start_busy = 1'b0, savestate_start_ok = 1'b0, savestate_start_err = 1'b0;
wire savestate_load, savestate_load_ack = 1'b0, savestate_load_busy = 1'b0, savestate_load_ok = 1'b0, savestate_load_err = 1'b0;

wire status_boot_done;
wire status_setup_done;
wire status_running;
assign status_running = reset_n;

core_bridge_cmd icb (
    .clk(clk_74a), .reset_n(reset_n), .bridge_endian_little(bridge_endian_little), .bridge_addr(bridge_addr), .bridge_rd(bridge_rd), .bridge_rd_data(cmd_bridge_rd_data), .bridge_wr(bridge_wr), .bridge_wr_data(bridge_wr_data),
    .status_boot_done(status_boot_done), .status_setup_done(status_setup_done), .status_running(status_running),
    .dataslot_requestread(dataslot_requestread), .dataslot_requestread_id(dataslot_requestread_id), .dataslot_requestread_ack(1'b1), .dataslot_requestread_ok(1'b1),
    .dataslot_requestwrite(dataslot_requestwrite), .dataslot_requestwrite_id(dataslot_requestwrite_id), .dataslot_requestwrite_ack(1'b1), .dataslot_requestwrite_ok(1'b1),
    .dataslot_allcomplete(dataslot_allcomplete), .savestate_supported(savestate_supported), .savestate_addr(savestate_addr), .savestate_size(savestate_size), .savestate_maxloadsize(savestate_maxloadsize),
    .savestate_start(savestate_start), .savestate_start_ack(savestate_start_ack), .savestate_start_busy(savestate_start_busy), .savestate_start_ok(savestate_start_ok), .savestate_start_err(savestate_start_err),
    .savestate_load(savestate_load), .savestate_load_ack(savestate_load_ack), .savestate_load_busy(savestate_load_busy), .savestate_load_ok(savestate_load_ok), .savestate_load_err(savestate_load_err),
    .osnotify_inmenu(osnotify_inmenu), .datatable_addr(datatable_addr), .datatable_wren(datatable_wren), .datatable_data(datatable_data), .datatable_q(datatable_q)
);

reg cart_slot_active = 1'b0;
reg bios_slot_active = 1'b0;
reg bios_present = 1'b0;
reg bios_load_complete = 1'b0;
reg [31:0] cart_bytes_seen = 32'd0;
reg [31:0] bios_bytes_seen = 32'd0;
always @(posedge clk_74a or negedge pll_core_locked) begin
    if (!pll_core_locked) begin
        cart_slot_active <= 1'b0;
        bios_slot_active <= 1'b0;
        bios_present <= 1'b0;
        bios_load_complete <= 1'b0;
        cart_bytes_seen <= 32'd0;
        bios_bytes_seen <= 32'd0;
    end else begin
        if (dataslot_requestwrite) begin
            if (dataslot_requestwrite_id == 16'd0) cart_slot_active <= 1'b1;
            if (dataslot_requestwrite_id == 16'd1) begin
                bios_slot_active <= 1'b1;
                bios_load_complete <= 1'b0;
            end
        end
        if (cart_ioctl_wr) cart_bytes_seen <= cart_bytes_seen + 32'd2;
        if (bios_ioctl_wr) begin
            bios_bytes_seen <= bios_bytes_seen + 32'd2;
            bios_present <= 1'b1;
        end
        if (dataslot_allcomplete) begin
            if (bios_slot_active) bios_load_complete <= bios_present;
            cart_slot_active <= 1'b0;
            bios_slot_active <= 1'b0;
        end
    end
end

wire [24:0] cart_ioctl_addr;
wire [15:0] cart_ioctl_data;
wire cart_ioctl_wr;
wire [17:0] bios_ioctl_addr;
wire [15:0] bios_ioctl_data;
wire bios_ioctl_wr;

data_loader #(.ADDRESS_MASK_UPPER_4(4'h1), .ADDRESS_SIZE(25), .WRITE_MEM_CLOCK_DELAY(12), .WRITE_MEM_EN_CYCLE_LENGTH(2), .OUTPUT_WORD_SIZE(2)) cart_loader (
    .clk_74a(clk_74a), .clk_memory(clk_sys), .bridge_wr(bridge_wr), .bridge_endian_little(bridge_endian_little), .bridge_addr(bridge_addr), .bridge_wr_data(bridge_wr_data),
    .write_en(cart_ioctl_wr), .write_addr(cart_ioctl_addr), .write_data(cart_ioctl_data)
);

data_loader #(.ADDRESS_MASK_UPPER_4(4'h2), .ADDRESS_SIZE(18), .WRITE_MEM_CLOCK_DELAY(12), .WRITE_MEM_EN_CYCLE_LENGTH(2), .OUTPUT_WORD_SIZE(2)) bios_loader (
    .clk_74a(clk_74a), .clk_memory(clk_sys), .bridge_wr(bridge_wr), .bridge_endian_little(bridge_endian_little), .bridge_addr(bridge_addr), .bridge_wr_data(bridge_wr_data),
    .write_en(bios_ioctl_wr), .write_addr(bios_ioctl_addr), .write_data(bios_ioctl_data)
);


wire cart_download_sys, bios_loading_sys;
synch_3 cart_dl_s(cart_slot_active, cart_download_sys, clk_sys);
synch_3 bios_dl_s(bios_slot_active, bios_loading_sys, clk_sys);
wire megacd_mode_enabled = bios_present;
wire genesis_reset = ~reset_n | cart_download_sys | (megacd_mode_enabled & ~bios_load_complete);
wire mcd_reset = ~reset_n | cart_download_sys | bios_loading_sys | (megacd_mode_enabled & ~bios_load_complete);
assign status_boot_done = pll_core_locked;
assign status_setup_done = pll_core_locked & (~megacd_mode_enabled | bios_load_complete);

wire [31:0] cont1_key_s, cont2_key_s, cont3_key_s, cont4_key_s;
wire [31:0] cont1_joy_s;
synch_3 #(.WIDTH(32)) c1s(cont1_key, cont1_key_s, clk_sys);
synch_3 #(.WIDTH(32)) c2s(cont2_key, cont2_key_s, clk_sys);
synch_3 #(.WIDTH(32)) c3s(cont3_key, cont3_key_s, clk_sys);
synch_3 #(.WIDTH(32)) c4s(cont4_key, cont4_key_s, clk_sys);
synch_3 #(.WIDTH(32)) j1s(cont1_joy, cont1_joy_s, clk_sys);

wire [11:0] joystick_0 = {cont1_key_s[9],cont1_key_s[6],cont1_key_s[8],cont1_key_s[14],cont1_key_s[15],cont1_key_s[4],cont1_key_s[5],cont1_key_s[7],cont1_key_s[0],cont1_key_s[1],cont1_key_s[2],cont1_key_s[3]};
wire [11:0] joystick_1 = {cont2_key_s[9],cont2_key_s[6],cont2_key_s[8],cont2_key_s[14],cont2_key_s[15],cont2_key_s[4],cont2_key_s[5],cont2_key_s[7],cont2_key_s[0],cont2_key_s[1],cont2_key_s[2],cont2_key_s[3]};
wire [11:0] joystick_2 = {cont3_key_s[9],cont3_key_s[6],cont3_key_s[8],cont3_key_s[14],cont3_key_s[15],cont3_key_s[4],cont3_key_s[5],cont3_key_s[7],cont3_key_s[0],cont3_key_s[1],cont3_key_s[2],cont3_key_s[3]};
wire [11:0] joystick_3 = {cont4_key_s[9],cont4_key_s[6],cont4_key_s[8],cont4_key_s[14],cont4_key_s[15],cont4_key_s[4],cont4_key_s[5],cont4_key_s[7],cont4_key_s[0],cont4_key_s[1],cont4_key_s[2],cont4_key_s[3]};

wire [23:1] GEN_VA;
wire [15:0] GEN_VDI, GEN_VDO;
wire GEN_RNW, GEN_LDS_N, GEN_UDS_N, GEN_AS_N, GEN_ASEL_N, GEN_VCLK_CE, GEN_CE0_N, GEN_WRL_N, GEN_WRH_N, GEN_OE_N, GEN_RAS2_N, EXT_ROM_N, EXT_FDC_N;
wire GEN_RAM_CE_N;
wire [15:0] GEN_AUDL, GEN_AUDR;
wire GEN_CE;
wire [3:0] r,g,b;
wire vs, hs, hblank, vblank_sys, ce_pix, TRANSP_DETECT, interlaced, field;
wire [1:0] resolution;
wire [15:0] mcd_l, mcd_r;
wire [15:0] MCD_DO;
wire MCD_DTACK_N;
wire [17:0] MCD_PRG_ADDR;
wire [15:0] MCD_PRG_DI, MCD_PRG_DO;
wire MCD_PRG_OE_N, MCD_PRG_WRL_N, MCD_PRG_WRH_N, MCD_PRG_BUSY;
wire [13:1] MCD_BRAM_ADDR;
wire [7:0] MCD_BRAM_DI, MCD_BRAM_DO;
wire MCD_BRAM_WE;
wire [15:0] MCD_PCM_SL, MCD_PCM_SR, MCD_CDDA_SL, MCD_CDDA_SR;
wire MCD_CDDA_WR_READY;
wire MCD_RST_N;
wire [39:0] scd_cdd_stat, scd_cdd_comm;
wire scd_cdd_send, scd_cdd_rec, scd_cdd_dm;
wire [15:0] cdc_d;
wire cdc_wr, cdc_sub_wr, cdc_cdda_wr;
wire cdd_command_seen;
wire [15:0] CART_DO;
wire CART_DTACK_N, CART_CART_N, CART_ROM_CE_N, CART_RAM_CE_N;
wire [15:0] GEN_MEM_DO;
wire GEN_MEM_BUSY;
wire GEN_ROM_CE_N;
reg [15:0] GEN_MEM_DO_R;
wire [15:0] bram_unused_q;
wire [15:0] sdrom_data;
wire [15:0] gen_mem_addr_data = GEN_MEM_DO;
wire sub68k_activity_seen_w = (~MCD_PRG_OE_N) | (~MCD_PRG_WRL_N) | (~MCD_PRG_WRH_N);
reg gen_activity_seen = 1'b0, sub68k_activity_seen = 1'b0;
always @(posedge clk_sys) begin
    if (!GEN_AS_N) gen_activity_seen <= 1'b1;
    if (sub68k_activity_seen_w) sub68k_activity_seen <= 1'b1;
end

assign GEN_VDI = !GEN_RAM_CE_N ? GEN_MEM_DO_R : !CART_DTACK_N ? CART_DO : MCD_DO;
wire GEN_DTACK_N = MCD_DTACK_N & CART_DTACK_N;
always @(posedge clk_sys) begin
    reg old_busy;
    old_busy <= GEN_MEM_BUSY;
    if (old_busy & ~GEN_MEM_BUSY) GEN_MEM_DO_R <= GEN_MEM_DO;
end

gen donor_gen (
    .RESET_N(~genesis_reset), .MCLK(clk_sys), .VA(GEN_VA), .VDI(GEN_VDI), .VDO(GEN_VDO), .RNW(GEN_RNW), .LDS_N(GEN_LDS_N), .UDS_N(GEN_UDS_N), .AS_N(GEN_AS_N), .DTACK_N(GEN_DTACK_N), .ASEL_N(GEN_ASEL_N), .VCLK_CE(GEN_VCLK_CE), .CE0_N(GEN_CE0_N), .WRL_N(GEN_WRL_N), .WRH_N(GEN_WRH_N), .OE_N(GEN_OE_N), .RAS2_N(GEN_RAS2_N), .ROM_N(EXT_ROM_N), .FDC_N(EXT_FDC_N), .CART_N(CART_CART_N), .DISK_N(1'b0),
    .LPF_MODE(2'b00), .ENABLE_FM(1'b1), .ENABLE_PSG(1'b1), .EXT_SL(mcd_l), .EXT_SR(mcd_r), .EXT_EN(megacd_mode_enabled), .DAC_LDATA(GEN_AUDL), .DAC_RDATA(GEN_AUDR), .DAC_CE(GEN_CE),
    .LOADING(cart_download_sys), .PAL(1'b0), .EXPORT(1'b1), .TIME_N(), .TIME_DI(16'h0000), .EN_HIFI_PCM(1'b1), .LADDER(1'b1), .OBJ_LIMIT_HIGH(1'b1),
    .RED(r), .GREEN(g), .BLUE(b), .VS(vs), .HS(hs), .HBL(hblank), .VBL(vblank_sys), .CE_PIX(ce_pix), .TRANSP_DETECT(TRANSP_DETECT), .CRAM_DOTS(1'b0), .BORDER(1'b0), .INTERLACE(interlaced), .FIELD(field), .RESOLUTION(resolution), .EN_BGA(1'b1), .EN_BGB(1'b1), .EN_SPR(1'b1),
    .J3BUT(1'b0), .JOY_1(joystick_0), .JOY_2(joystick_1), .JOY_3(joystick_2), .JOY_4(joystick_3), .JOY_5(12'h000), .MULTITAP(3'b000), .MOUSE(25'h0), .MOUSE_OPT(3'b000), .GUN_OPT(1'b0), .GUN_TYPE(1'b0), .GUN_SENSOR(1'b0), .GUN_A(1'b0), .GUN_B(1'b0), .GUN_C(1'b0), .GUN_START(1'b0), .SERJOYSTICK_IN(8'h00), .SERJOYSTICK_OUT(), .SER_OPT(2'b00),
    .RAM_CE_N(GEN_RAM_CE_N), .RAM_RDY(~GEN_MEM_BUSY), .RFS(), .RFS_RDY(1'b1), .GG_RESET(1'b0), .GG_EN(1'b0), .GG_CODE(129'd0), .GG_AVAILABLE(), .DBG_M68K_A(), .DBG_MBUS_A()
);

CART donor_cart (
    .RST_N(~genesis_reset), .CLK(clk_sys), .ENABLE(1'b1), .ROM_MODE(1'b1), .RAM_ID(8'd6), .VA(GEN_VA), .VDI(GEN_VDO), .VDO(CART_DO), .AS_N(GEN_AS_N), .RNW(GEN_RNW), .LDS_N(GEN_LDS_N), .UDS_N(GEN_UDS_N), .DTACK_N(CART_DTACK_N), .ASEL_N(GEN_ASEL_N), .VCLK_CE(GEN_VCLK_CE), .CE0_N(GEN_CE0_N), .CART_N(CART_CART_N), .ROM_CE_N(CART_ROM_CE_N), .ROM_DI(GEN_MEM_DO), .ROM_RDY(~GEN_MEM_BUSY), .RAM_CE_N(CART_RAM_CE_N), .RAM_DI(GEN_MEM_DO), .RAM_RDY(~GEN_MEM_BUSY)
);

cdd_nodisc_stub nodisc (
    .clk(clk_sys), .rst_n(~mcd_reset), .cdd_comm(scd_cdd_comm), .cdd_send(scd_cdd_send), .mcd_rst_n(MCD_RST_N), .cdd_stat(scd_cdd_stat), .cdd_dm(scd_cdd_dm), .cdd_rec(scd_cdd_rec), .cdc_data(cdc_d), .cdc_dat_wr(cdc_wr), .cdc_sc_wr(cdc_sub_wr), .cdc_cdda_wr(cdc_cdda_wr), .cdda_wr_ready(MCD_CDDA_WR_READY), .cdd_command_seen(cdd_command_seen)
);

MCD donor_mcd (
    .RST_N(~mcd_reset), .CLK(clk_sys), .ENABLE(megacd_mode_enabled), .MCD_RST_N(MCD_RST_N), .PALSW(1'b0), .EXT_VA(GEN_VA[17:1]), .EXT_VDI(GEN_VDO), .EXT_VDO(MCD_DO), .EXT_AS_N(GEN_AS_N), .EXT_RNW(GEN_RNW), .EXT_LDS_N(GEN_LDS_N), .EXT_UDS_N(GEN_UDS_N), .EXT_DTACK_N(MCD_DTACK_N), .EXT_ASEL_N(GEN_ASEL_N), .EXT_VCLK_CE(GEN_VCLK_CE), .EXT_RAS2_N(GEN_RAS2_N), .EXT_ROM_N(EXT_ROM_N), .EXT_FDC_N(EXT_FDC_N),
    .PRG_A(MCD_PRG_ADDR), .PRG_DI(MCD_PRG_DI), .PRG_DO(MCD_PRG_DO), .PRG_WRL_N(MCD_PRG_WRL_N), .PRG_WRH_N(MCD_PRG_WRH_N), .PRG_OE_N(MCD_PRG_OE_N), .PRG_RDY(~MCD_PRG_BUSY),
    .ROM_DI(GEN_MEM_DO), .ROM_CE_N(GEN_ROM_CE_N), .ROM_RDY(~GEN_MEM_BUSY), .BRAM_A(MCD_BRAM_ADDR), .BRAM_DI(MCD_BRAM_DI), .BRAM_DO(MCD_BRAM_DO), .BRAM_WE(MCD_BRAM_WE),
    .CDD_STAT(scd_cdd_stat), .CDD_COMM(scd_cdd_comm), .CDD_SEND(scd_cdd_send), .CDD_REC(scd_cdd_rec), .CDD_DM(scd_cdd_dm), .CDC_DATA(cdc_d), .CDC_DAT_WR(cdc_wr), .CDC_SC_WR(cdc_sub_wr), .CDC_CDDA_WR(cdc_cdda_wr), .CDDA_WR_READY(), .PCM_SL(MCD_PCM_SL), .PCM_SR(MCD_PCM_SR), .CDDA_SL(MCD_CDDA_SL), .CDDA_SR(MCD_CDDA_SR), .LED_RED(), .LED_GREEN(), .GG_RESET(1'b0), .GG_EN(1'b0), .GG_CODE(129'd0), .GG_AVAILABLE(), .DBG_S68K_A()
);

wire [24:1] sdram_addr0 = {6'b100000, MCD_PRG_ADDR};
wire [24:1] sdram_addr1 = !GEN_RAM_CE_N  ? {9'b010000000, GEN_VA[15:1]} :
                          !CART_RAM_CE_N ? {5'b01110, GEN_VA[19:1]} :
                          !CART_ROM_CE_N ? {2'b00, GEN_VA[22:1]} :
                          !GEN_ROM_CE_N  ? {8'b01111000, GEN_VA[16:1]} :
                                           {9'b010000000, 15'd0};
wire [24:1] sdram_addr2 = bios_ioctl_wr ? {8'b01111000, bios_ioctl_addr[17:1]} : {2'b00, cart_ioctl_addr[22:1]};
wire [15:0] sdram_din2 = bios_ioctl_wr ? {bios_ioctl_data[7:0], bios_ioctl_data[15:8]} : {cart_ioctl_data[7:0], cart_ioctl_data[15:8]};
wire load_wr_any = bios_ioctl_wr | cart_ioctl_wr;

sdram main_sdram (
    .init(~pll_core_locked), .clk(clk_ram),
    .addr0(sdram_addr0), .rd0(~MCD_PRG_OE_N), .wrl0(~MCD_PRG_WRL_N), .wrh0(~MCD_PRG_WRH_N), .din0(MCD_PRG_DO), .dout0(MCD_PRG_DI), .busy0(MCD_PRG_BUSY),
    .addr1(sdram_addr1), .rd1((~GEN_RAM_CE_N | ~GEN_ROM_CE_N | ~CART_RAM_CE_N | ~CART_ROM_CE_N) & ~GEN_OE_N), .wrl1((~GEN_RAM_CE_N | ~CART_RAM_CE_N) & ~GEN_WRL_N), .wrh1((~GEN_RAM_CE_N | ~CART_RAM_CE_N) & ~GEN_WRH_N), .din1(GEN_VDO), .dout1(GEN_MEM_DO), .busy1(GEN_MEM_BUSY),
    .addr2(sdram_addr2), .rd2(1'b0), .wrl2(load_wr_any), .wrh2(load_wr_any), .din2(sdram_din2), .dout2(), .busy2(),
    .SDRAM_DQ(dram_dq), .SDRAM_A(dram_a), .SDRAM_DQML(dram_dqm[0]), .SDRAM_DQMH(dram_dqm[1]), .SDRAM_BA(dram_ba), .SDRAM_nCS(), .SDRAM_nWE(dram_we_n), .SDRAM_nRAS(dram_ras_n), .SDRAM_nCAS(dram_cas_n), .SDRAM_CLK(dram_clk), .SDRAM_CKE(dram_cke)
);

dpram_dif #(13,8,12,16) mcd_bram (
    .clock(clk_sys), .address_a(MCD_BRAM_ADDR), .data_a(MCD_BRAM_DO), .wren_a(MCD_BRAM_WE), .q_a(MCD_BRAM_DI),
    .address_b(12'd0), .data_b(16'd0), .wren_b(1'b0), .q_b(bram_unused_q)
);

reg signed [15:0] aud_l, aud_r, mcd_mix_l, mcd_mix_r;
always @(posedge clk_sys) begin
    mcd_mix_l <= $signed(MCD_PCM_SL >>> 1) + $signed(MCD_CDDA_SL >>> 1);
    mcd_mix_r <= $signed(MCD_PCM_SR >>> 1) + $signed(MCD_CDDA_SR >>> 1);
    if (megacd_mode_enabled) begin
        aud_l <= $signed(GEN_AUDL >>> 1) + $signed(mcd_mix_l >>> 1);
        aud_r <= $signed(GEN_AUDR >>> 1) + $signed(mcd_mix_r >>> 1);
    end else begin
        aud_l <= GEN_AUDL;
        aud_r <= GEN_AUDR;
    end
end
wire [15:0] AUDIO_L = aud_l;
wire [15:0] AUDIO_R = aud_r;

sound_i2s #(.CHANNEL_WIDTH(16), .SIGNED_INPUT(1)) i2s (
    .clk_74a(clk_74a), .clk_audio(clk_sys), .audio_l(AUDIO_L), .audio_r(AUDIO_R), .audio_mclk(audio_mclk), .audio_lrck(audio_lrck), .audio_dac(audio_dac)
);

wire [7:0] color_lut[16] = '{8'd0,8'd27,8'd49,8'd71,8'd87,8'd103,8'd119,8'd130,8'd146,8'd157,8'd174,8'd190,8'd206,8'd228,8'd255,8'd255};
wire hs_c, vs_c, hblank_c, vblank_c;
wire [7:0] red, green, blue;
cofi coffee (
    .clk(clk_sys), .pix_ce(ce_pix), .enable(1'b0), .hblank(hblank), .vblank(vblank_sys), .hs(hs), .vs(vs), .red(color_lut[r]), .green(color_lut[g]), .blue(color_lut[b]), .hblank_out(hblank_c), .vblank_out(vblank_c), .hs_out(hs_c), .vs_out(vs_c), .red_out(red), .green_out(green), .blue_out(blue)
);
reg video_de_reg, video_hs_reg, video_vs_reg;
reg [23:0] video_rgb_reg;
reg current_pix_clk, current_pix_clk_90, hs_prev, vs_prev;
reg field_r, interlaced_r; reg [1:0] resolution_r;
wire field_s, interlaced_s; wire [1:0] resolution_s;
synch_3 #(.WIDTH(2)) sync_res(resolution_r, resolution_s, current_pix_clk);
synch_3 sync_int(interlaced_r, interlaced_s, current_pix_clk);
synch_3 sync_field(field_r, field_s, current_pix_clk);
always @(*) begin
    if (resolution_r == 2'b00) begin current_pix_clk = clk_vid_256; current_pix_clk_90 = clk_vid_256_90deg; end
    else begin current_pix_clk = clk_vid_320; current_pix_clk_90 = clk_vid_320_90deg; end
end
assign video_rgb_clock = current_pix_clk;
assign video_rgb_clock_90 = current_pix_clk_90;
assign video_de = video_de_reg;
assign video_hs = video_hs_reg;
assign video_vs = video_vs_reg;
assign video_rgb = video_rgb_reg;
always @(posedge clk_sys) begin
    field_r <= field;
    interlaced_r <= interlaced;
    resolution_r <= resolution;
end
always @(posedge current_pix_clk) begin
    reg vblank_line = 1'b0;
    video_de_reg <= 1'b0;
    if (~(vblank_line || hblank_c)) begin
        video_de_reg <= 1'b1;
        video_rgb_reg[23:16] <= red;
        video_rgb_reg[15:8]  <= green;
        video_rgb_reg[7:0]   <= blue;
    end
    video_hs_reg <= ~hs_prev && hs_c;
    video_vs_reg <= ~vs_prev && vs_c;
    hs_prev <= hs_c;
    vs_prev <= vs_c;
    if (~hs_prev && hs_c) vblank_line <= vblank_c;
end

wire [31:0] debug_status = {
    22'd0,
    cdd_command_seen,
    sub68k_activity_seen,
    gen_activity_seen,
    MCD_RST_N,
    ~genesis_reset,
    megacd_mode_enabled,
    bios_slot_active,
    bios_present,
    reset_n,
    pll_core_locked
};

always @(*) begin
    bridge_rd_data = 32'd0;
    casex (bridge_addr)
        32'h00E00000: bridge_rd_data = 32'h00000001;
        32'h00E00004: bridge_rd_data = debug_status;
        32'h00E00008: bridge_rd_data = cart_bytes_seen;
        32'h00E0000C: bridge_rd_data = bios_bytes_seen;
        32'hF8xxxxxx: bridge_rd_data = cmd_bridge_rd_data;
        default: bridge_rd_data = 32'd0;
    endcase
end

endmodule
