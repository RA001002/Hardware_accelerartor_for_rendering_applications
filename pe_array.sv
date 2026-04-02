`timescale 1ns/1ps
`include "isa_defs.vh"

module pe_array #(
    parameter int N = 8
)(
    input  logic clk,
    input  logic rst,
    input  logic [`OPCODE_W-1:0] opcode,
    input  logic [3:0]          shft,
    input  logic signed [`DATA_W-1:0] in_a [N],
    input  logic signed [`DATA_W-1:0] in_b [N],
    output logic signed [`DATA_W-1:0] out  [N]
);

    genvar i;
    generate
        for (i = 0; i < N; i++) begin : PE_GEN
            pe pe_i (
                .clk(clk),
                .rst(rst),
                .opcode(opcode),
                .shft(shft),
                .in_a(in_a[i]),
                .in_b(in_b[i]),
                .out(out[i])
            );
        end
    endgenerate
endmodule
