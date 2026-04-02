`timescale 1ns/1ps

module gpu_top (
    input logic clk,
    input logic reset
);
    logic [31:0] instr_mem [0:1023];

    cluster c0 (.clk(clk), .reset(reset), .instr_mem(instr_mem));
    cluster c1 (.clk(clk), .reset(reset), .instr_mem(instr_mem));
endmodule
