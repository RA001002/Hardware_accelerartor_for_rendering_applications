`timescale 1ns / 1ps
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
    parameter WARP_SIZE = 8,
    parameter DATA_WIDTH = 8
)(
    input  logic clk,
    input  logic rst,

    input  logic valid_in,
    output logic ready_out,

    input  logic [2:0] opcode,

    input  logic [DATA_WIDTH-1:0] pixel_in [WARP_SIZE],
    output logic [DATA_WIDTH-1:0] pixel_out [WARP_SIZE],

    output logic valid_out
);

// internal registers (pipeline stage)
logic [DATA_WIDTH-1:0] pixel_reg [WARP_SIZE];
logic valid_reg;

// instantiate PE array
logic [DATA_WIDTH-1:0] pe_out [WARP_SIZE];

pe_array #(
    .WARP_SIZE(WARP_SIZE),
    .DATA_WIDTH(DATA_WIDTH)
) pe_array_inst (
    .pixel_in(pixel_reg),
    .opcode(opcode),
    .pixel_out(pe_out)
);

integer i;

always_ff @(posedge clk) begin
    if (rst) begin
        valid_reg <= 0;
        valid_out <= 0;
        ready_out <= 1;
    end else begin
        if (valid_in && ready_out) begin
            for (i = 0; i < WARP_SIZE; i++) begin
                pixel_reg[i] <= pixel_in[i];
            end
            valid_reg <= 1;
            ready_out <= 0;
        end else begin
            valid_reg <= 0;
            ready_out <= 1;
        end

        // output stage
        if (valid_reg) begin
            for (i = 0; i < WARP_SIZE; i++) begin
                pixel_out[i] <= pe_out[i];
            end
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end
end

endmodule