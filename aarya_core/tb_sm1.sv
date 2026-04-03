`timescale 1ns/1ps

module tb_sm1;

    parameter LANES = 8;
    parameter WARPS = 4;
    parameter DEPTH = 1024;

    logic clk;
    logic reset;

    logic [23:0] in_mem  [0:DEPTH-1];
    logic [7:0]  out_mem [0:DEPTH-1];

    // DUT
    sm #(.LANES(LANES), .WARPS(WARPS), .DEPTH(DEPTH)) dut (
        .clk(clk),
        .reset(reset),
        .in_mem(in_mem),
        .out_mem(out_mem)
    );

    // Load input
    initial begin
        $readmemh("input.hex", in_mem);
        #1;
        $display("First pixel = %h", in_mem[0]);
    end

    // Clock
    always #5 clk = ~clk;

    // MAIN CONTROL
    initial begin
        clk = 0;
        reset = 1;

        #10;
        reset = 0;

        // ? Run long enough for full processing
        #(DEPTH * 20);   // Safe upper bound

        // ? Print output to TCL console
        $display("\n===== OUTPUT DATA =====");
        for (int i = 0; i < DEPTH; i++) begin
            if (^out_mem[i] !== 1'bX) begin
                $display("Pixel[%0d] = %h", i, out_mem[i]);
            end
        end

        // ? Write to file
        $writememh("output1.hex", out_mem);

        $display("\nOutput written to output.hex");
        $finish;
    end

endmodule