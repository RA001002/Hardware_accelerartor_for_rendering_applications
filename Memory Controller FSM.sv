`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 06:34:04
// Design Name: 
// Module Name: Memory Controller FSM
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


module MemoryControllerFSM (
    input  logic        clk,
    input  logic        reset,
    input  logic        start,

    // BRAM interface
    output logic [11:0] bram_addr,
    output logic        bram_we,
    output logic [63:0] bram_din,
    input  logic [63:0] bram_dout,

    // Control
    input  logic [11:0] base_addr,
    input  logic [9:0]  img_width
);

    typedef enum logic [2:0] {
        IDLE,
        READ,
        WAIT,
        SPLIT,
        TILE_FILL,
        DISPATCH,
        WRITEBACK
    } state_t;

    state_t state;

    logic [63:0] data_reg;
    logic [7:0]  pixels [0:7];
    logic [5:0]  tile_index;
    logic [1:0]  core_id;

    pixel_splitter SPLIT0 (
        .clk(clk),
        .data_in(data_reg),
        .pixels(pixels)
    );

    Scheduler SCHED (
        .clk(clk),
        .enable(state == DISPATCH),
        .core_sel(core_id)
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= IDLE;
            tile_index <= 0;
            bram_we    <= 0;
        end else begin
            case (state)

                IDLE: begin
                    if (start) begin
                        bram_addr <= base_addr;
                        state     <= READ;
                    end
                end

                READ: begin
                    state <= WAIT;
                end

                WAIT: begin
                    data_reg <= bram_dout;
                    state    <= SPLIT;
                end

                SPLIT: begin
                    tile_index <= 0;
                    state <= TILE_FILL;
                end

                TILE_FILL: begin
                    tile_index <= tile_index + 1;
                    if (tile_index == 7)
                        state <= DISPATCH;
                end

                DISPATCH: begin
                    state <= WRITEBACK;
                end

                WRITEBACK: begin
                    bram_we  <= 1;
                    bram_din <= data_reg; // placeholder
                    state   <= IDLE;
                end

            endcase
        end
    end
endmodule

