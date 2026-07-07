module rom_preload_ingress_stub #(
    parameter ENABLE_PRELOAD_INGRESS_STUB = 1'b0
)(
    input  wire        clk,
    input  wire [31:0] bridge_addr,
    input  wire        bridge_wr,
    input  wire [31:0] bridge_wr_data,
    input  wire        bridge_rd,

    output wire        preload_wr,
    output wire [24:1] preload_addr,
    output wire [15:0] preload_data,
    output wire        preload_commit,
    output wire        preload_active
);

    // TODO(Task 5C): replace with real APF data-slot loader.
    // This is a conservative scaffold-only debug ingress; it is not final APF loading logic.
    // Inputs:
    // - bridge_wr_data[24:1] -> latch as preload address
    // - bridge_wr_data[15:0] -> latch as preload data
    // - bridge_wr_data[0] at 0x0C -> control preload_active latch
    // - 0x00,0x04,0x08 addresses are debug command entrypoints.
    // - preload_* outputs are inert unless explicitly enabled.
    generate
        if (ENABLE_PRELOAD_INGRESS_STUB) begin : gen_preload_ingress
            // keep inactive debug register path visible for bridge-only safety
            (* keep *) wire _unused_bridge_rd = bridge_rd;

            reg  [24:1] latched_addr;
            reg  [15:0] latched_data;
            reg         commit_pulse;
            reg         wr_pulse;
            reg         active;

            wire write_addr   = bridge_wr && (bridge_addr == 32'h00000000);
            wire write_data   = bridge_wr && (bridge_addr == 32'h00000004);
            wire write_commit = bridge_wr && (bridge_addr == 32'h00000008);
            wire write_active = bridge_wr && (bridge_addr == 32'h0000000C);

            always @(posedge clk) begin
                // clear one-shot pulses by default
                wr_pulse     <= 1'b0;
                commit_pulse <= 1'b0;

                if (write_addr) begin
                    latched_addr <= bridge_wr_data[24:1];
                end
                if (write_data) begin
                    latched_data <= bridge_wr_data[15:0];
                    wr_pulse     <= 1'b1;
                end
                if (write_commit) begin
                    commit_pulse <= 1'b1;
                end
                if (write_active) begin
                    active <= bridge_wr_data[0];
                end
            end

            assign preload_addr    = latched_addr;
            assign preload_data    = latched_data;
            assign preload_wr      = wr_pulse;
            assign preload_commit  = commit_pulse;
            assign preload_active  = active;
        end else begin : gen_stub
            // default inert bridge stub for scaffold mode
            assign preload_addr    = 24'd0;
            assign preload_data    = 16'd0;
            assign preload_wr      = 1'b0;
            assign preload_commit  = 1'b0;
            assign preload_active  = 1'b0;

            // Silence unused bridge_rd input while keeping interface complete.
            wire _unused_bridge_rd = bridge_rd;
            (* keep *) wire unused_bridge_rd = _unused_bridge_rd;
        end
    endgenerate
endmodule
