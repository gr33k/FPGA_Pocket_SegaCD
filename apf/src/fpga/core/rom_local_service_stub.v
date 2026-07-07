module rom_local_service_stub #(
    parameter ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 1'b0,
    parameter ENABLE_TINY_LOCAL_ROM_RAM = 1'b0
)(
    input  wire        clk,
    // Genesis ROM service request side from runtime:
    // rom_addr is byte/word address as expected by imported Genesis base.
    input  wire [24:1] rom_addr,
    input  wire        rom_req,
    output wire        rom_ready,
    output wire [15:0] rom_data,
    output wire        rom_valid,
    output wire        rom_preload_done,

    // Future preload write/commit path from APF data-slot loader.
    // Not implemented in this scaffold; kept as inert placeholders.
    input  wire        preload_wr,
    input  wire [24:1] preload_addr,
    input  wire [15:0] preload_data,
    input  wire        preload_commit
);
    // Keep default placeholder usage explicit to avoid accidental optimization and preserve
    // stable wiring for ingress ports that are connected but not functionally used in all modes.
    wire preload_inputs_unused;
    assign preload_inputs_unused = preload_wr | preload_addr[24] | preload_data[0] | preload_commit;

    wire        tiny_rom_ready;
    wire [15:0] tiny_rom_data;
    wire        tiny_rom_valid;
    wire        tiny_rom_preload_done;

    rom_tiny_local_ram_stub #(
        .ENABLE_TINY_LOCAL_ROM_RAM(ENABLE_TINY_LOCAL_ROM_RAM),
        .ADDR_WORDS(1024)
    ) u_rom_tiny_local_ram_stub(
        .clk            (clk),
        .preload_wr     (preload_wr),
        .preload_addr   (preload_addr),
        .preload_data   (preload_data),
        .preload_commit (preload_commit),
        .rom_addr       (rom_addr),
        .rom_req        (rom_req),
        .rom_data       (tiny_rom_data),
        .rom_valid      (tiny_rom_valid),
        .rom_ready      (tiny_rom_ready),
        .rom_preload_done(tiny_rom_preload_done)
    );

    generate
        if (ENABLE_TINY_LOCAL_ROM_RAM) begin : gen_tiny_ram_path
            assign rom_preload_done = tiny_rom_preload_done;
            assign rom_ready        = tiny_rom_ready;
            assign rom_valid        = tiny_rom_valid;
            assign rom_data         = tiny_rom_data;
        end else if (ENABLE_FAKE_ROM_FOR_SMOKE_TEST) begin : gen_fake
            // Structural smoke mode: acknowledge every request with inert sample data.
            assign rom_preload_done = 1'b1;
            assign rom_ready       = 1'b1;
            assign rom_valid       = rom_req;
            assign rom_data        = 16'hFFFF;
        end else begin : gen_stub
            // Conservative inert default until APF-side preload/controller exists.
            assign rom_preload_done = 1'b0;
            assign rom_ready       = 1'b0;
            assign rom_valid       = 1'b0;
            assign rom_data        = 16'hFFFF;
        end
    endgenerate
endmodule
