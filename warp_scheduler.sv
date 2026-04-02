module warp_scheduler #(
    parameter int NUM_WARPS = 4
)(
    input  logic clk,
    input  logic reset,
    input  logic [NUM_WARPS-1:0] warp_active,
    input  logic [NUM_WARPS-1:0] warp_stalled,
    output logic [$clog2(NUM_WARPS)-1:0] warp_id,
    output logic warp_valid
);

    logic [$clog2(NUM_WARPS)-1:0] rr_ptr;
    integer i;

    always_ff @(posedge clk)
        if (reset) rr_ptr <= '0;
        else if (warp_valid) rr_ptr <= warp_id + 1'b1;

    always_comb begin
        warp_valid = 0;
        warp_id    = rr_ptr;

        for (i = 0; i < NUM_WARPS; i++) begin
            int idx = (rr_ptr + i) % NUM_WARPS;
            if (warp_active[idx] && !warp_stalled[idx] && !warp_valid) begin
                warp_id    = idx;
                warp_valid = 1;
            end
        end
    end
endmodule
