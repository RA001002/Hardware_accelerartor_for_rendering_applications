`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 06:34:04
// Design Name: 
// Module Name: Tile Buffer
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

module tile_buffer #(
    parameter TILE_SIZE = 64
)(
    input  logic       clk,
    input  logic       we,
    input  logic [5:0] addr,
    input  logic [7:0] din,
    output logic [7:0] dout
);

    logic [7:0] buffer [0:TILE_SIZE-1];

    always_ff @(posedge clk) begin
        if (we)
            buffer[addr] <= din;
        dout <= buffer[addr];
    end
endmodule

