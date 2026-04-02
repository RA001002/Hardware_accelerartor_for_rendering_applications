`timescale 1ns/1ps

module tb_gpu_top;

    logic clk;
    logic reset;

    gpu_top dut (
        .clk   (clk),
        .reset (reset)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset
    initial begin
        reset = 1;
        #40 reset = 0;
    end

    // Instructions
    initial begin
        integer i;
        for (i = 0; i < 1024; i++)
            dut.instr_mem[i] = 0;

        dut.instr_mem[0] = {4'b0000, 28'd0}; // ADD
        dut.instr_mem[1] = {4'b0111, 28'd0}; // MAC
        dut.instr_mem[2] = {4'b0110, 24'd0, 4'd1}; // SHIFTR
        dut.instr_mem[3] = {4'b1001, 28'd0}; // MOVACC
        dut.instr_mem[4] = {4'b1000, 28'd0}; // CLRACC
    end

    // Image memory
    initial begin
        integer i;
        for (i = 0; i < (1<<12); i++)
            dut.c0.sm0.lsu_u.mem[i] = i[7:0];
    end

    // ? PRINT ON EXEC STAGE ONLY
    always @(posedge clk) begin
        if (!reset &&
            dut.c0.sm0.warp_state[dut.c0.sm0.warp_id] == 2'd3) begin

            $display(
                "[T=%0t] WARP=%0d PC=%0d OPCODE=%b | ALU=%0b MAC=%0b ACC=%0b | LSU_ADDR=%0d PIXEL=%0d | OUT0=%0d OUT1=%0d",
                $time,
                dut.c0.sm0.warp_id,
                dut.c0.sm0.pc,
                dut.c0.sm0.opcode,
                dut.c0.sm0.is_alu,
                dut.c0.sm0.is_mac,
                dut.c0.sm0.is_acc,
                dut.c0.sm0.lsu_addr,
                dut.c0.sm0.lsu_rd_data,
                dut.c0.sm0.out[0],
                dut.c0.sm0.out[1]
            );
        end
    end

    initial begin
        #800 $finish;
    end

endmodule
