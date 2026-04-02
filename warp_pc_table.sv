module warp_pc_table #(
    parameter int NUM_WARPS = 4,
    parameter int PC_WIDTH = 10
)(
    input  logic clk,
    input  logic reset,
    input  logic [$clog2(NUM_WARPS)-1:0] warp_id,
    input  logic pc_we,
    input  logic [PC_WIDTH-1:0] pc_next,
    output logic [PC_WIDTH-1:0] pc_out
);

    logic [PC_WIDTH-1:0] pc_mem [NUM_WARPS];

    integer i;
    always_ff @(posedge clk)
        if (reset)
            for (i = 0; i < NUM_WARPS; i++) pc_mem[i] <= '0;
        else if (pc_we)
            pc_mem[warp_id] <= pc_next;

    assign pc_out = pc_mem[warp_id];
endmodule
