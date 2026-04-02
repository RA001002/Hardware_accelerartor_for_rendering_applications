`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 06:34:04
// Design Name: 
// Module Name: Core Register
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


module CoreRegister #(
    parameter NUM_CORES = 4
)(
    input  logic       clk,
    input  logic       load,
    input  logic [7:0] pixel_in,
    input  logic [1:0] core_id,
    output logic [7:0] core_reg [0:NUM_CORES-1]
);

    always_ff @(posedge clk) begin
        if (load)
            core_reg[core_id] <= pixel_in;
    end
endmodule

