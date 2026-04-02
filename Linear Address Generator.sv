`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 06:34:04
// Design Name: 
// Module Name: Linear Address Generator
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


module LinearAddressGenerator(

    input  logic [11:0] base_addr,
    input  logic [9:0]  x,
    input  logic [9:0]  y,
    input  logic [9:0]  image_width,
    output logic [11:0] linear_addr
);
    always_comb
        linear_addr = base_addr + (y * image_width) + x;
endmodule

