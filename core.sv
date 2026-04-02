`timescale 1ns/1ps

module core (
    input  logic [3:0]  opcode,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] result
);

    always_comb begin
        case (opcode)
            4'h0: result = a + b;
            4'h1: result = a - b;
            default: result = 32'd0;
        endcase
    end

endmodule
