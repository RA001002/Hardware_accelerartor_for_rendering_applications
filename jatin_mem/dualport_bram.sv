module dualport_bram #(
    parameter ADDR_WIDTH = 10,
    parameter DATA_WIDTH = 96
)(
    input  logic clk,

    // Port A (read)
    input  logic [ADDR_WIDTH-1:0] addr_a,
    output logic [DATA_WIDTH-1:0] rdata_a,

    // Port B (read/write)
    input  logic [ADDR_WIDTH-1:0] addr_b,
    input  logic [DATA_WIDTH-1:0] wdata_b,
    input  logic we_b,
    output logic [DATA_WIDTH-1:0] rdata_b
);

    logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    always_ff @(posedge clk) begin
        rdata_a <= mem[addr_a];
        rdata_b <= mem[addr_b];

        if (we_b)
            mem[addr_b] <= wdata_b;
    end

endmodule