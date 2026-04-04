
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2026 06:01:06 PM
// Design Name: 
// Module Name: core
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

module core #(
    parameter WARP_SIZE = 8
)(
    input clk,
    input rst,

    input  [23:0] warp_in [0:WARP_SIZE-1],
    input  valid_in,

    output reg [7:0] warp_out [0:WARP_SIZE-1],
    output reg valid_out,

    input [2:0] opcode
);

    wire [7:0] pe_out [0:WARP_SIZE-1];

    pe_array #(.WARP_SIZE(WARP_SIZE)) u_array (
        .warp_in(warp_in),
        .opcode(opcode),
        .warp_out(pe_out)
    );

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            valid_out <= 0;
        end else begin
            valid_out <= valid_in;
            for (i = 0; i < WARP_SIZE; i = i + 1) begin
                warp_out[i] <= pe_out[i];
            end
        end
    end

endmodule