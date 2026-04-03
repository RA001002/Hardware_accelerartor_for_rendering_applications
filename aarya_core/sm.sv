module sm #(
    parameter LANES = 8,
    parameter WARPS = 4,
    parameter DEPTH = 1024
)(
    input  logic clk,
    input  logic reset,

    input  logic [23:0] in_mem  [0:DEPTH-1],
    output logic [7:0]  out_mem [0:DEPTH-1]
);

    // ============================
    // Warp Scheduler
    // ============================
    logic [$clog2(WARPS)-1:0] active_warp;

    warp_scheduler #(.WARPS(WARPS)) scheduler (
        .clk(clk),
        .reset(reset),
        .active_warp(active_warp)
    );

    // ============================
    // Base pointers
    // ============================
    int base     [WARPS];
    int base_d   [WARPS];   // delayed base (FIX)

    // ============================
    // Pipeline signals
    // ============================
    logic [23:0] pixel_in  [LANES];
    logic [23:0] pixel_reg [LANES];
    logic [7:0]  gray_out  [LANES];

    // ============================
    // PE Array
    // ============================
    pe_array #(.LANES(LANES)) u_pe_array (
        .pixel_in(pixel_reg),
        .gray_out(gray_out)
    );

    // ============================
    // READ STAGE (warp ? lanes)
    // ============================
    always_comb begin
        for (int i = 0; i < LANES; i++) begin
            pixel_in[i] = in_mem[base[active_warp] + i];
        end
    end

    // ============================
    // PIPELINE + WRITE (FIXED)
    // ============================
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int w = 0; w < WARPS; w++) begin
                base[w]   <= w * LANES;
                base_d[w] <= 0;
            end
        end else begin

            // ? FIX: delay base for alignment
            base_d[active_warp] <= base[active_warp];

            // Stage 1: register pixels
            for (int i = 0; i < LANES; i++) begin
                pixel_reg[i] <= pixel_in[i];
            end

            // Stage 2: write output using delayed base
            for (int i = 0; i < LANES; i++) begin
                out_mem[base_d[active_warp] + i] <= gray_out[i];
            end

            // Advance base (stride across warps)
            base[active_warp] <= base[active_warp] + (LANES * WARPS);
        end
    end

endmodule