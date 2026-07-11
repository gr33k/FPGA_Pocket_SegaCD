`default_nettype none

module cdd_nodisc_stub (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [39:0] cdd_comm,
    input  wire        cdd_send,
    input  wire        mcd_rst_n,
    output reg  [39:0] cdd_stat,
    output reg         cdd_dm,
    output reg         cdd_rec,
    output reg  [15:0] cdc_data,
    output reg         cdc_dat_wr,
    output reg         cdc_sc_wr,
    output reg         cdc_cdda_wr,
    output reg         cdda_wr_ready,
    output reg         cdd_command_seen
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cdd_stat         <= 40'h0000_0000ff;
        cdd_dm           <= 1'b0;
        cdd_rec          <= 1'b0;
        cdc_data         <= 16'h0000;
        cdc_dat_wr       <= 1'b0;
        cdc_sc_wr        <= 1'b0;
        cdc_cdda_wr      <= 1'b0;
        cdda_wr_ready    <= 1'b1;
        cdd_command_seen <= 1'b0;
    end else begin
        cdd_rec       <= 1'b0;
        cdc_dat_wr    <= 1'b0;
        cdc_sc_wr     <= 1'b0;
        cdc_cdda_wr   <= 1'b0;
        cdda_wr_ready <= 1'b1;

        if (!mcd_rst_n) begin
            cdd_stat <= 40'h0000_0000ff;
        end else if (cdd_send) begin
            cdd_command_seen <= 1'b1;
            cdd_rec          <= 1'b1;
            cdd_stat         <= 40'h0000_0000ff;
        end
    end
end

endmodule
