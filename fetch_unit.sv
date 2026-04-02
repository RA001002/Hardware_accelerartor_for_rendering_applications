`timescale 1ns/1ps

module fetch_unit (
    input  logic        clk,
    input  logic        reset,
    input  logic        fetch_en,
    input  logic [9:0]  pc,
    input  logic [31:0] instr_mem [0:1023],
    output logic [31:0] instr,
    output logic        instr_valid
);

    always_ff @(posedge clk) begin
        if (reset) begin
            instr       <= 32'd0;
            instr_valid <= 1'b0;
        end
        else if (fetch_en) begin
            instr       <= instr_mem[pc];
            instr_valid <= 1'b1;
        end
        else begin
            instr_valid <= 1'b0;
        end
    end

endmodule
