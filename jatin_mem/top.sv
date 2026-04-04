`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 14:24:14
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top;

    import parameter_package::*;

    logic clk, rst;

    mem_interface #(ADDR_WIDTH, DATA_WIDTH) req_if();
    mem_interface #(ADDR_WIDTH, DATA_WIDTH) coal_if();

    // Coalescing
    pipelined_coalescing coal (
        .clk(clk),
        .rst(rst),
        .in_if(req_if),
        .out_if(coal_if)
    );

    // Banked Memory
    Banked_bram mem (
        .clk(clk),
        .rst(rst),
        .mem_port(coal_if)
    );

    // Compute
    logic [SIMD_LANES*8-1:0] gray_out;

    grayscale_simd compute (
        .clk(clk),
        .rgb_in(coal_if.rdata),
        .gray_out(gray_out)
    );

endmodule