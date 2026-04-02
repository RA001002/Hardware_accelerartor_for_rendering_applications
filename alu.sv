`timescale 1ns/1ps
`include "isa_defs.vh"

module alu (
    input  logic                    clk,
    input  logic                    rst,
    input  logic [`OPCODE_W-1:0]     opcode,
    input  logic signed [`DATA_W-1:0] a,
    input  logic signed [`DATA_W-1:0] b,
    input  logic [3:0]              shft,
    input  logic                    acc_clr,
    output logic signed [`DATA_W-1:0] result,
    output logic signed [`ACC_W-1:0]  acc
);

    logic signed [`DATA_W-1:0] mul_res;
    assign mul_res = a * b;

    always_ff @(posedge clk) begin
        if (rst) begin
            result <= '0;
            acc    <= '0;
        end else begin
            if (acc_clr)
                acc <= '0;

            case (opcode)
                `OP_ADD:    result <= a + b;
                `OP_SUB:    result <= a - b;
                `OP_MUL:    result <= mul_res;
                `OP_ABS:    result <= (a < 0) ? -a : a;
                `OP_MIN:    result <= (a < b) ? a : b;
                `OP_MAX:    result <= (a > b) ? a : b;
                `OP_SHIFTR: result <= a >>> shft;
                `OP_MAC:    acc    <= acc + mul_res;
                `OP_CLRACC: acc    <= '0;
                `OP_MOVACC: result <= acc[`DATA_W-1:0];
                default:    result <= '0;
            endcase
        end
    end
endmodule
