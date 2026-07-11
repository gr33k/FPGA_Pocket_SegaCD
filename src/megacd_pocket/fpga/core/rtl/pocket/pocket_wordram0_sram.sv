`default_nettype none

module pocket_wordram0_sram (
    input  wire        clock,
    input  wire        reset,
    input  wire [15:0] wordram_addr,
    input  wire [15:0] wordram_write_data,
    input  wire        wordram_write,
    output reg  [15:0] wordram_read_data,
    output reg         wordram_read_seen,
    output reg         wordram_write_seen,
    output reg  [15:0] last_wordram_addr,
    output wire [16:0] sram_a,
    inout  wire [15:0] sram_dq,
    output wire        sram_oe_n,
    output wire        sram_we_n,
    output wire        sram_ub_n,
    output wire        sram_lb_n
);

reg [15:0] addr_q;
reg [15:0] data_q;
reg        write_q;

assign sram_a    = {1'b0, addr_q};
assign sram_dq   = write_q ? data_q : 16'hZZZZ;
assign sram_oe_n = write_q;
assign sram_we_n = ~write_q;
assign sram_ub_n = 1'b0;
assign sram_lb_n = 1'b0;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        addr_q             <= 16'd0;
        data_q             <= 16'd0;
        write_q            <= 1'b0;
        wordram_read_data  <= 16'd0;
        wordram_read_seen  <= 1'b0;
        wordram_write_seen <= 1'b0;
        last_wordram_addr  <= 16'd0;
    end else begin
        addr_q            <= wordram_addr;
        data_q            <= wordram_write_data;
        write_q           <= wordram_write;
        last_wordram_addr <= wordram_addr;

        if (wordram_write) begin
            wordram_write_seen <= 1'b1;
            wordram_read_data  <= wordram_write_data;
        end else begin
            wordram_read_seen <= 1'b1;
            wordram_read_data <= sram_dq;
        end
    end
end

endmodule
