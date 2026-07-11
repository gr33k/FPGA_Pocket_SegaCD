`default_nettype none

module megacd_cdc_ram_mlab (
    input  wire        clock,
    input  wire        reset,
    input  wire [13:0] read_addr,
    output wire [7:0]  read_data,
    input  wire [12:0] write_addr,
    input  wire [15:0] write_data,
    input  wire        write_en,
    output reg         read_seen,
    output reg         write_seen,
    output reg  [13:0] last_read_addr,
    output reg  [12:0] last_write_addr
);

localparam integer WORD_COUNT = 8192;

(* ramstyle = "MLAB, no_rw_check" *) reg [7:0] ram_lo [0:WORD_COUNT-1];
(* ramstyle = "MLAB, no_rw_check" *) reg [7:0] ram_hi [0:WORD_COUNT-1];

wire [12:0] read_word_addr = read_addr[13:1];
wire        read_high_byte = read_addr[0];
wire        bypass_read = write_en && (write_addr == read_word_addr);
wire [7:0]  ram_read_data = read_high_byte ? ram_hi[read_word_addr] : ram_lo[read_word_addr];
wire [7:0]  bypass_data = read_high_byte ? write_data[15:8] : write_data[7:0];

assign read_data = bypass_read ? bypass_data : ram_read_data;

always @(posedge clock) begin
    if (reset) begin
        read_seen <= 1'b0;
        write_seen <= 1'b0;
        last_read_addr <= 14'd0;
        last_write_addr <= 13'd0;
    end else begin
        if (read_addr != last_read_addr) read_seen <= 1'b1;
        last_read_addr <= read_addr;
        if (write_en) begin
            ram_lo[write_addr] <= write_data[7:0];
            ram_hi[write_addr] <= write_data[15:8];
            write_seen <= 1'b1;
            last_write_addr <= write_addr;
        end
    end
end

endmodule
