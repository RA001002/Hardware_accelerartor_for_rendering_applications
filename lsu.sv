`timescale 1ns/1ps
module lsu #(
    parameter ADDR_W = 12
)(
    input  logic              clk,
    input  logic              rst,

    input  logic              rd_en,
    input  logic              wr_en,
    input  logic [ADDR_W-1:0] addr,
    input  logic [7:0]        wr_data,
    output logic [7:0]        rd_data
);

    logic [7:0] mem [0:(1<<ADDR_W)-1];

    always_ff @(posedge clk) begin
        if (wr_en)
            mem[addr] <= wr_data;

        if (rd_en)
            rd_data <= mem[addr];
    end
endmodule
