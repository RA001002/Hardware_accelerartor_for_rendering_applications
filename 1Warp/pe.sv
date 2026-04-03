`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2026 06:01:06 PM
// Design Name: 
// Module Name: pe
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


module pe #(
    parameter DATA_WIDTH = 8
)(
    input  logic [DATA_WIDTH-1:0] in_pixel,
    input  logic [2:0] opcode,
    output logic [DATA_WIDTH-1:0] out_pixel
);

always_comb begin
    case (opcode)
        3'd0: out_pixel = in_pixel + 8'd10;      // ADD
        3'd1: out_pixel = in_pixel - 8'd10;      // SUB
        3'd2: out_pixel = in_pixel * 2;          // MUL
        3'd3: out_pixel = (in_pixel > 8'd128) ? 8'd255 : 8'd0; // THRESH
        3'd4: out_pixel = 8'd255 - in_pixel;     // INVERT
        default: out_pixel = in_pixel;
    endcase
end

endmodule
