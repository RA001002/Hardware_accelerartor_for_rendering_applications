`timescale 1ns/1ps

module simt_issue (
    input  logic clk,
    input  logic reset,
    output logic [2:0] thread0_id,
    output logic [2:0] thread1_id,
    output logic       warp_done
);

    logic [1:0] phase;

    always_ff @(posedge clk) begin
        if (reset)
            phase <= 2'd0;
        else
            phase <= (phase == 2'd3) ? 2'd0 : phase + 2'd1;
    end

    always_comb begin
        thread0_id = {phase, 1'b0};
        thread1_id = {phase, 1'b1};
        warp_done  = (phase == 2'd3);
    end

endmodule
