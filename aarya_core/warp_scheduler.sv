module warp_scheduler #(
    parameter WARPS = 4
)(
    input  logic clk,
    input  logic reset,
    output logic [$clog2(WARPS)-1:0] active_warp
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            active_warp <= 0;
        else
            active_warp <= active_warp + 1;
    end

endmodule