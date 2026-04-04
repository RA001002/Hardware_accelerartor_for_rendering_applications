
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2026 06:56:15 PM
// Design Name: 
// Module Name: sm_core
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

module sm_core #(
    parameter DATA_WIDTH = 24,
    parameter WARP_SIZE  = 8,
    parameter NUM_WARPS  = 4
)(
    input clk,
    input rst,

    input  [DATA_WIDTH-1:0] warp_in [0:WARP_SIZE-1],
    input  valid_in,

    output [7:0] warp_out [0:WARP_SIZE-1],
    output valid_out,

    input [2:0] opcode
);

    core #(.WARP_SIZE(WARP_SIZE)) u_core (
        .clk(clk),
        .rst(rst),
        .warp_in(warp_in),
        .valid_in(valid_in),
        .warp_out(warp_out),
        .valid_out(valid_out),
        .opcode(opcode)
    );

endmodule
