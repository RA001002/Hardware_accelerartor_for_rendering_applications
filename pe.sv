`timescale 1ns/1ps
`include "isa_defs.vh"

module pe (
    input  logic                    clk,
    input  logic                    rst,
    input  logic [`OPCODE_W-1:0]     opcode,
    input  logic [3:0]              shft,
    input  logic signed [`DATA_W-1:0] in_a,
    input  logic signed [`DATA_W-1:0] in_b,
    output logic signed [`DATA_W-1:0] out
);

    logic acc_clr;
    logic signed [`DATA_W-1:0] alu_res;
    logic signed [`ACC_W-1:0]  acc;

    assign acc_clr = (opcode == `OP_CLRACC);

    alu alu_u (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .a(in_a),
        .b(in_b),
        .shft(shft),
        .acc_clr(acc_clr),
        .result(alu_res),
        .acc(acc)
    );

    assign out = alu_res;
endmodule
