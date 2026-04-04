

module warp_scheduler #(
    parameter NUM_WARPS = 4
)(
    input  logic clk,
    input  logic rst,
    input  logic core_ready,

    output logic [$clog2(NUM_WARPS)-1:0] warp_id,
    output logic valid
);

always_ff @(posedge clk) begin
    if (rst) begin
        warp_id <= 0;
        valid <= 0;
    end else begin
        if (core_ready) begin
            warp_id <= warp_id + 1;  // round robin
            valid <= 1;
        end else begin
            valid <= 0;
        end
    end
end

endmodule