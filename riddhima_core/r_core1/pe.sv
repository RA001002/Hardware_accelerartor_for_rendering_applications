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


module pe (
    input  [23:0] in_pixel,
    input  [2:0]  opcode,
    output reg [7:0] out_pixel
);

    reg [7:0] R, G, B;
    reg [15:0] gray_temp;

    always @(*) begin
        R = in_pixel[23:16];
        G = in_pixel[15:8];
        B = in_pixel[7:0];

        case (opcode)
        3'd0: out_pixel = R + 8'd10; // simple example
        3'd1: out_pixel = R - 8'd10;
        3'd2: out_pixel = R * 2;

        3'd3: out_pixel = (R > 8'd128) ? 8'd255 : 8'd0;

        3'd4: out_pixel = 8'd255 - R;
        3'd5: begin
        gray_temp = (R * 8'd77) + (G * 8'd150) + (B * 8'd29);
        out_pixel = gray_temp >> 8;
        end

            default: out_pixel = 8'd0;

        endcase
    end
    
       

endmodule
