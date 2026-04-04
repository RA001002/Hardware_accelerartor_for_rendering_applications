`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2026 06:01:06 PM
// Design Name: 
// Module Name: tb
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


module tb;

parameter WARP_SIZE = 8;

reg clk = 0;
always #5 clk = ~clk;

reg rst;
reg valid_in;
wire ready_out;
reg [2:0] opcode;

reg [7:0] pixel_in [WARP_SIZE];
wire [7:0] pixel_out [WARP_SIZE];
wire valid_out;

core uut (
    .clk(clk),
    .rst(rst),
    .valid_in(valid_in),
    .ready_out(ready_out),
    .opcode(opcode),
    .pixel_in(pixel_in),
    .pixel_out(pixel_out),
    .valid_out(valid_out)
);

integer i;

initial begin
    rst = 1; valid_in = 0;
    #20 rst = 0;

    // load warp
    for (i = 0; i < WARP_SIZE; i++)
        pixel_in[i] = i * 30;

    opcode = 3'd4; // invert

    #10 valid_in = 1;
    #10 valid_in = 0;

    #100 $finish;
end

endmodule
