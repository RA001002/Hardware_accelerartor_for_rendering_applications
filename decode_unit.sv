`timescale 1ns/1ps
`include "isa_defs.vh"

module decode_unit (
    input  logic [31:0] instr,

    output logic [`OPCODE_W-1:0] opcode,
    output logic [3:0]           shft,

    // Instruction class
    output logic is_alu,
    output logic is_mac,
    output logic is_lsu,
    output logic is_acc,

    // Control
    output logic acc_clr,
    output logic writeback_en
);

    always_comb begin
        opcode = instr[31:28];
        shft   = instr[3:0];

        // Defaults
        is_alu       = 1'b0;
        is_mac       = 1'b0;
        is_lsu       = 1'b0;
        is_acc       = 1'b0;
        acc_clr      = 1'b0;
        writeback_en = 1'b0;

        case (opcode)
            `OP_ADD,
            `OP_SUB,
            `OP_MUL,
            `OP_ABS,
            `OP_MIN,
            `OP_MAX,
            `OP_SHIFTR: begin
                is_alu       = 1'b1;
                writeback_en = 1'b1;
            end

            `OP_MAC: begin
                is_mac  = 1'b1;
                is_acc  = 1'b1;
            end

            `OP_CLRACC: begin
                acc_clr = 1'b1;
                is_acc  = 1'b1;
            end

            `OP_MOVACC: begin
                is_acc       = 1'b1;
                writeback_en = 1'b1;
            end

            default: begin
                // NOP / invalid
            end
        endcase
    end

endmodule
