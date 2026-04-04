`timescale 1ns/1ps

module tb;

    parameter DEPTH = 188244;  

    logic clk = 0;
    logic reset = 1;

    logic [23:0] in_mem  [0:DEPTH-1];
    logic [23:0] out_mem [0:DEPTH-1];

    sm uut (
        .clk(clk),
        .reset(reset),
        .in_mem(in_mem),
        .out_mem(out_mem)
    );

    always #5 clk = ~clk;

    initial begin
        $readmemh("input25.hex", in_mem);
    end

    initial begin
        #20 reset = 0;

        // enough cycles
        #800000;

        // write file
        $writememh("output251.hex", out_mem);

        // print small preview
        $display("---- OUTPUT PREVIEW ----");
        for (int i = 0; i < 20; i++)
            $display("%06X", out_mem[i]);

        $finish;
    end

endmodule