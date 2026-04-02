`timescale 1ns/1ps

module regfile(
    input  logic        clk,
    input  logic [1:0]  warp_id,
    input  logic [2:0]  thread0_id,
    input  logic [2:0]  thread1_id,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic        write_en,
    input  logic [2:0]  wb_thread_id,
    input  logic [4:0]  wb_reg,
    input  logic [31:0] wb_data,
    output logic [31:0] rd0_a,
    output logic [31:0] rd0_b,
    output logic [31:0] rd1_a,
    output logic [31:0] rd1_b
);

    logic [31:0] mem [0:3][0:7][0:31];

    always_ff @(posedge clk)
        if (write_en)
            mem[warp_id][wb_thread_id][wb_reg] <= wb_data;

    always_comb begin
        rd0_a = mem[warp_id][thread0_id][rs1];
        rd0_b = mem[warp_id][thread0_id][rs2];
        rd1_a = mem[warp_id][thread1_id][rs1];
        rd1_b = mem[warp_id][thread1_id][rs2];
    end

endmodule
