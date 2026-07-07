module rom_local_service_stub #(
    parameter ENABLE_FAKE_ROM_FOR_SMOKE_TEST = 1'b0
)(
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

    // TODO(Task 5B): In this milestone, no real storage is present.
    // ROM reads must not stream directly from APF host-side bridge.
    // Future implementation should:
    // 1) load ROM bytes from APF preload path into local memory,
    // 2) service rom_req with local-memory read data/ack,
    // 3) deassert preload signals once complete and assert rom_preload_done.
    // 4) keep deterministic behavior if preload does not complete.
    // NOTE(Task 5B): `preload_*` inputs are currently unused placeholders.
    wire preload_inputs_unused;
    assign preload_inputs_unused = preload_wr | preload_addr[24] | preload_data[0] | preload_commit;

    generate
        if (ENABLE_FAKE_ROM_FOR_SMOKE_TEST) begin : gen_fake
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
