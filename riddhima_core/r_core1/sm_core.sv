`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2026 06:56:15 PM
// Design Name: 
// Module Name: sm_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sm_core #(
    parameter DATA_WIDTH = 24,
    parameter WARP_SIZE  = 8,
    parameter NUM_WARPS  = 4
)(
    input clk,
    input rst,

    input  [DATA_WIDTH-1:0] warp_in [0:WARP_SIZE-1],
    input  valid_in,

    output reg [7:0] warp_out [0:WARP_SIZE-1],
    output reg valid_out,

    input [2:0] opcode
);

    // -------------------------------
    // Stage 0: Scheduler Output
    // -------------------------------
    wire [DATA_WIDTH-1:0] sched_warp [0:WARP_SIZE-1];
    wire sched_valid;

    warp_scheduler #(
        .DATA_WIDTH(DATA_WIDTH),
        .WARP_SIZE(WARP_SIZE),
        .NUM_WARPS(NUM_WARPS)
    ) scheduler (
        .clk(clk),
        .rst(rst),
        .warp_in(warp_in),
        .valid_in(valid_in),
        .warp_out(sched_warp),
        .valid_out(sched_valid)
    );

    // -------------------------------
    // PIPELINE REGISTER (Stage 1)
    // -------------------------------
    reg [DATA_WIDTH-1:0] pipe_warp [0:WARP_SIZE-1];
    reg pipe_valid;

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            pipe_valid <= 0;
        end else begin
            pipe_valid <= sched_valid;
            for (i = 0; i < WARP_SIZE; i = i + 1)
                pipe_warp[i] <= sched_warp[i];
        end
    end

    // -------------------------------
    // Stage 2: Core Execution
    // -------------------------------
    wire [7:0] core_out [0:WARP_SIZE-1];
    wire core_valid;

    core #(
        .WARP_SIZE(WARP_SIZE)
    ) u_core (
        .clk(clk),
        .rst(rst),
        .warp_in(pipe_warp),
        .valid_in(pipe_valid),
        .warp_out(core_out),
        .valid_out(core_valid),
        .opcode(opcode)
    );

    // -------------------------------
    // PIPELINE REGISTER (Stage 3)
    // -------------------------------
    always @(posedge clk) begin
        if (rst) begin
            valid_out <= 0;
            for (i = 0; i < WARP_SIZE; i = i + 1)
                warp_out[i] <= 0;
        end else begin
            valid_out <= core_valid;
            for (i = 0; i < WARP_SIZE; i = i + 1)
                warp_out[i] <= core_out[i];
        end
    end

endmodule
