`timescale 1ns/1ps
module warp_scheduler #(
    parameter WARPS = 4
)(
    input  logic clk,
    input  logic reset,
    output logic [$clog2(WARPS)-1:0] warp_id
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            warp_id <= 0;
        else
            warp_id <= warp_id + 1;
    end

endmodule