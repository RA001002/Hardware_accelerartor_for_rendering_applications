`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 06:34:04
// Design Name: 
// Module Name: Pixel Splitter
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


module pixel_splitter (
    input  logic        clk,
    input  logic [63:0] data_in,
    output logic [7:0]  pixels [0:7]
);
    always_ff @(posedge clk) begin
        pixels[0] <= data_in[7:0];
        pixels[1] <= data_in[15:8];
        pixels[2] <= data_in[23:16];
        pixels[3] <= data_in[31:24];
        pixels[4] <= data_in[39:32];
        pixels[5] <= data_in[47:40];
        pixels[6] <= data_in[55:48];
        pixels[7] <= data_in[63:56];
    end
endmodule


