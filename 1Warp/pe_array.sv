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
    parameter WARP_SIZE = 8,
    parameter DATA_WIDTH = 8
)(
    input  logic [DATA_WIDTH-1:0] pixel_in [WARP_SIZE],
    input  logic [2:0] opcode,
    output logic [DATA_WIDTH-1:0] pixel_out [WARP_SIZE]
);

genvar i;

generate
    for (i = 0; i < WARP_SIZE; i++) begin : PE_GEN
        pe #(.DATA_WIDTH(DATA_WIDTH)) pe_inst (
            .in_pixel(pixel_in[i]),
            .opcode(opcode),
            .out_pixel(pixel_out[i])
        );
    end
endgenerate

endmodule
