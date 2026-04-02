`timescale 1ns / 1ps


module tb_memory_controller;

    logic clk;
    logic reset;
    logic start;

    logic [11:0] bram_addr;
    logic        bram_we;
    logic [63:0] bram_din;
    logic [63:0] bram_dout;

    logic [11:0] base_addr = 12'd0;
    logic [9:0]  img_width = 10'd64;

    // Clock
    always #5 clk = ~clk;

    // DUT
  memory_controller DUT (
        .clk(clk),
        .reset(reset),
        .start(start),
        .bram_addr(bram_addr),
        .bram_we(bram_we),
        .bram_din(bram_din),
        .bram_dout(bram_dout),
        .base_addr(base_addr),
        .img_width(img_width)
    );

    // BRAM
    bram_64 MEM (
        .clk(clk),
        .we(bram_we),
        .addr(bram_addr),
        .din(bram_din),
        .dout(bram_dout)
    );

    initial begin
        clk = 0;
        reset = 1;
        start = 0;

        #20 reset = 0;

        // preload image data
        MEM.mem[0] = 64'h0807060504030201;
        MEM.mem[1] = 64'h100F0E0D0C0B0A09;

        #20 start = 1;
        #10 start = 0;

        #300 $finish;
    end
endmodule
