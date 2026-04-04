`timescale 1ns / 1ps

module warp_scheduler #(
    parameter DATA_WIDTH = 24,
    parameter WARP_SIZE  = 8,
    parameter NUM_WARPS  = 4
)(
    input clk,
    input rst,

    input  [DATA_WIDTH-1:0] warp_in [0:WARP_SIZE-1],
    input  valid_in,

    output reg [DATA_WIDTH-1:0] warp_out [0:WARP_SIZE-1],
    output reg valid_out
);

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            valid_out <= 0;
        end else begin
            valid_out <= valid_in;

            for (i = 0; i < WARP_SIZE; i = i + 1)
                warp_out[i] <= warp_in[i];
        end
    end

endmodule