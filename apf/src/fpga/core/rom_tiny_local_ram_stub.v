module rom_tiny_local_ram_stub #(
    parameter ENABLE_TINY_LOCAL_ROM_RAM = 1'b0,
    parameter integer ADDR_WORDS = 1024
)(
    input  wire        clk,

    // Preload ingress side (Task 5C/5D path).
    input  wire        preload_wr,
    input  wire [24:1] preload_addr,
    input  wire [15:0] preload_data,
    input  wire        preload_commit,

    // Runtime ROM service side.
    input  wire [24:1] rom_addr,
    input  wire        rom_req,

    output wire [15:0] rom_data,
    output wire        rom_valid,
    output wire        rom_ready,
    output wire        rom_preload_done
);
    // Tiny compile-time-only smoke/stub ROM store.
    // This is not full cartridge memory: only small local fabric memory for structural wiring.
    localparam integer ADDR_INDEX_W = (ADDR_WORDS <= 1) ? 1 : $clog2(ADDR_WORDS);

    generate
        if (ENABLE_TINY_LOCAL_ROM_RAM) begin : gen_tiny
            reg [15:0] tiny_rom [0:ADDR_WORDS-1];
            reg [15:0] rom_data_reg;
            reg        preload_done;

            wire [ADDR_INDEX_W-1:0] preload_index = preload_addr[ADDR_INDEX_W:1];
            wire [ADDR_INDEX_W-1:0] read_index    = rom_addr[ADDR_INDEX_W:1];

            always @(posedge clk) begin
                if (preload_wr) begin
                    tiny_rom[preload_index] <= preload_data;
                end
                if (preload_commit) begin
                    preload_done <= 1'b1;
                end
            end

            always @(*) begin
                if (preload_done) begin
                    rom_data_reg = tiny_rom[read_index];
                end else begin
                    rom_data_reg = 16'hFFFF;
                end
            end

            assign rom_ready        = rom_preload_done;
            assign rom_valid        = rom_req && rom_ready;
            assign rom_data         = rom_data_reg;
            assign rom_preload_done = preload_done;

            // avoid unknown reset/latch behavior in this stub phase
            initial begin
                preload_done = 1'b0;
            end
        end else begin : gen_tiny_stub
            assign rom_ready        = 1'b0;
            assign rom_valid        = 1'b0;
            assign rom_data         = 16'hFFFF;
            assign rom_preload_done = 1'b0;
        end
    endgenerate
endmodule
