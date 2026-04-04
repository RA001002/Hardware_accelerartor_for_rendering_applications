`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2026 06:01:06 PM
// Design Name: 
// Module Name: pe_array
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


module pe_array #(
    parameter WARP_SIZE = 8
)(
    input  [23:0] warp_in  [0:WARP_SIZE-1],
    input  [2:0]  opcode,
    output [7:0] warp_out [0:WARP_SIZE-1]
);

    genvar i;

    generate
        for (i = 0; i < WARP_SIZE; i = i + 1) begin : PE_BLOCK
            pe u_pe (
                .in_pixel(warp_in[i]),
                .opcode(opcode),
                .out_pixel(warp_out[i])
            );
        end
    endgenerate

endmodule
