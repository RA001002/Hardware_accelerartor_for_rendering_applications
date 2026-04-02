`timescale 1ns/1ps

module tb_top;

    // ---------------------------------
    // Clock / Reset / Start
    // ---------------------------------
    logic clk;
    logic reset;
    logic start;

    // ---------------------------------
    // Instantiate DUT
    // ---------------------------------
    top DUT (
        .clk   (clk),
        .reset (reset),
        .start (start)
    );

    // ---------------------------------
    // Clock generation (100 MHz)
    // ---------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // ---------------------------------
    // Stimulus
    // ---------------------------------
    initial begin
        $display("======================================");
        $display(" TB STARTED ");
        $display("======================================");

        reset = 1;
        start = 0;

        // Hold reset
        #30;
        reset = 0;
        $display("[%0t] Reset deasserted", $time);

        // Preload BRAM (hierarchical access)
        DUT.u_bram.mem[0] = 64'h08_07_06_05_04_03_02_01;
        DUT.u_bram.mem[1] = 64'h10_0F_0E_0D_0C_0B_0A_09;
        DUT.u_bram.mem[2] = 64'h18_17_16_15_14_13_12_11;
        $display("[%0t] BRAM preloaded", $time);

        // Start transaction
        #20;
        start = 1;
        $display("[%0t] START asserted", $time);

        #20;
        start = 0;
        $display("[%0t] START deasserted", $time);

        // Run long enough
        #500;

        $display("======================================");
        $display(" TB FINISHED ");
        $display("======================================");
        $finish;
    end

    // ---------------------------------
    // MONITOR (THIS IS YOUR PROOF)
    // ---------------------------------
    always @(posedge clk) begin
        if (!reset) begin
            $display(
                "T=%0t | FSM=%0d | addr=%0d | we=%b | tile_valid=%b | kernel_done=%b",
                $time,
                DUT.u_mem_ctrl.state,
                DUT.u_mem_ctrl.bram_addr,
                DUT.u_mem_ctrl.bram_we,
                DUT.tile_valid,
                DUT.kernel_done
            );
        end
    end

    // ---------------------------------
    // PASS / FAIL CHECKS (VERY SIMPLE)
    // ---------------------------------
    initial begin
        wait(DUT.tile_valid === 1'b1);
        $display("[%0t] ✅ TILE VALID ASSERTED", $time);

        wait(DUT.kernel_done === 1'b1);
        $display("[%0t] ✅ KERNEL DONE ASSERTED", $time);

        #20;
        $display("[%0t] ✅ INTEGRATION LOOKS CORRECT", $time);
    end

endmodule
