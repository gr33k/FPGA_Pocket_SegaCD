`timescale 1ns/1ps

module tb_rom_preload_path;
    // Conservative scaffold testbench for Task 5F.
    // Verifies bridge ingress -> local service -> tiny RAM path without full Genesis runtime.
    reg         clk;
    reg [31:0]  bridge_addr;
    reg         bridge_wr;
    reg [31:0]  bridge_wr_data;
    reg         bridge_rd;

    reg  [24:1] rom_addr;
    reg         rom_req;

    wire        preload_wr;
    wire [24:1] preload_addr;
    wire [15:0] preload_data;
    wire        preload_commit;
    wire        preload_active;

    wire        rom_slot_ready;
    wire [15:0] rom_slot_data;
    wire        rom_slot_valid;
    wire        rom_preload_done;

    integer failures;

    // Keep address semantics explicit for this testbench:
    // - Inputs are byte-address style values with bit0 dropped by interface width [24:1].
    // - Word #0 is 24'h000000000 (bus value 0).
    // - Word #1 is 24'h000000002 (bus value 2).

    rom_preload_ingress_stub #(
        .ENABLE_PRELOAD_INGRESS_STUB(1'b1)
    ) u_rom_preload_ingress_stub(
        .clk            (clk),
        .bridge_addr    (bridge_addr),
        .bridge_wr      (bridge_wr),
        .bridge_wr_data (bridge_wr_data),
        .bridge_rd      (bridge_rd),
        .preload_wr     (preload_wr),
        .preload_addr   (preload_addr),
        .preload_data   (preload_data),
        .preload_commit (preload_commit),
        .preload_active (preload_active)
    );

    rom_local_service_stub #(
        .ENABLE_FAKE_ROM_FOR_SMOKE_TEST(1'b0),
        .ENABLE_TINY_LOCAL_ROM_RAM    (1'b1)
    ) u_rom_local_service_stub(
        .rom_addr         (rom_addr),
        .rom_req          (rom_req),
        .rom_ready        (rom_slot_ready),
        .rom_data         (rom_slot_data),
        .rom_valid        (rom_slot_valid),
        .rom_preload_done  (rom_preload_done),
        .preload_wr       (preload_wr),
        .preload_addr     (preload_addr),
        .preload_data     (preload_data),
        .preload_commit   (preload_commit)
    );

    initial begin
        clk = 1'b0;
        bridge_addr = 32'd0;
        bridge_wr = 1'b0;
        bridge_wr_data = 32'd0;
        bridge_rd = 1'b0;
        rom_addr = 24'd0;
        rom_req = 1'b0;
        failures = 0;

        // Run the preload+read sequence on deterministic timing.
        repeat (2) @(posedge clk);

        // Write preload address for word 0 (0x00000000).
        do_bridge_write(32'h00000000, 32'h00000000);
        // Write preload data for word 0.
        do_bridge_write(32'h00000004, 32'h00001234);

        // Write preload address for word 1 (0x00000002 in byte-address terms).
        do_bridge_write(32'h00000000, 32'h00000002);
        // Write preload data for word 1.
        do_bridge_write(32'h00000004, 32'h0000ABCD);

        // Commit preload.
        do_bridge_write(32'h00000008, 32'h00000001);

        // Assert commit effects.
        @(posedge clk);
        if (rom_preload_done !== 1'b1) begin
            $display("FAIL: rom_preload_done did not assert after preload_commit.");
            failures = failures + 1;
        end
        if (rom_slot_ready !== 1'b1) begin
            $display("FAIL: rom_ready did not assert after preload_commit.");
            failures = failures + 1;
        end

        // Runtime-style read checks (combinational response expected while rom_req asserted).
        do_runtime_read(24'h00000000, 16'h1234); // word index 0
        do_runtime_read(24'h00000002, 16'hABCD); // word index 1

        if (failures == 0) begin
            $display("PASS: Task 5F ROM preload path smoke test PASSED");
            $finish;
        end else begin
            $display("FAIL: Task 5F ROM preload path smoke test FAILED with %0d failures", failures);
            $fatal(1);
        end
    end

    always #5 clk = ~clk;

    task automatic do_bridge_write(input [31:0] addr, input [31:0] data);
        begin
            @(negedge clk);
            bridge_addr     = addr;
            bridge_wr_data  = data;
            bridge_wr       = 1'b1;
            @(posedge clk);
            @(negedge clk);
            bridge_wr       = 1'b0;
            bridge_addr     = 32'd0;
            bridge_wr_data  = 32'd0;
        end
    endtask

    task automatic do_runtime_read(input [24:1] addr, input [15:0] expected_data);
        begin
            @(negedge clk);
            rom_addr = addr;
            rom_req  = 1'b1;
            #1;
            if (rom_slot_valid !== 1'b1) begin
                $display("FAIL: rom_valid not asserted for addr 0x%h", addr);
                failures = failures + 1;
            end
            if (rom_slot_data !== expected_data) begin
                $display("FAIL: rom_data mismatch for addr 0x%h expected=0x%h actual=0x%h", addr, expected_data, rom_slot_data);
                failures = failures + 1;
            end
            @(negedge clk);
            rom_req = 1'b0;
        end
    endtask

endmodule
