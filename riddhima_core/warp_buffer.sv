
module warp_buffer #(
    parameter WARP_SIZE = 8,
    parameter NUM_WARPS = 4,
    parameter DATA_WIDTH = 24
)(
    input  logic clk,

    input  logic load_en,
    input  logic [$clog2(NUM_WARPS)-1:0] load_id,
    input  logic [DATA_WIDTH-1:0] warp_in [WARP_SIZE],

    input  logic [$clog2(NUM_WARPS)-1:0] read_id,
    output logic [DATA_WIDTH-1:0] warp_out [WARP_SIZE]  // ✅ FIXED
);

logic [DATA_WIDTH-1:0] mem [NUM_WARPS][WARP_SIZE];

integer i;

always_ff @(posedge clk) begin
    if (load_en) begin
        for (i = 0; i < WARP_SIZE; i++) begin
            mem[load_id][i] <= warp_in[i];
        end
    end
end

assign warp_out = mem[read_id];  // ✅ now matches

endmodule