`timescale 1ns/1ps

module cluster (
    input logic clk,
    input logic reset,
    input logic [31:0] instr_mem [0:1023]
);
    sm sm0 (.clk(clk), .reset(reset), .instr_mem(instr_mem));
endmodule
