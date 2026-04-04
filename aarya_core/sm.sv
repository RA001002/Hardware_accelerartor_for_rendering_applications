
`timescale 1ns/1ps
module sm #(
    parameter LANES = 8,
    parameter WARPS = 4,
    parameter DEPTH = 188244
)(
    input  logic clk,
    input  logic reset,

    input  logic [23:0] in_mem  [0:DEPTH-1],
    output logic [23:0] out_mem [0:DEPTH-1]
);

    // ============================
    // WARP SCHEDULER
    // ============================
    logic [$clog2(WARPS)-1:0] warp_id;

    warp_scheduler #(.WARPS(WARPS)) scheduler (
        .clk(clk),
        .reset(reset),
        .warp_id(warp_id)
    );

    // ============================
    // PIPELINE REGISTERS
    // ============================
    logic [$clog2(WARPS)-1:0] warp_id_reg;
    int base, base_reg;

    logic [23:0] pixel_in  [LANES];
    logic [23:0] pixel_reg [LANES];
    logic [7:0]  gray_out  [LANES];

    logic valid;

    // ============================
    // PE ARRAY
    // ============================
    pe_array #(.LANES(LANES)) u_pe_array (
        .pixel_in(pixel_reg),
        .gray_out(gray_out)
    );

    // ============================
    // INIT OUTPUT
    // ============================
    initial begin
        for (int i = 0; i < DEPTH; i++)
            out_mem[i] = 24'h000000;
    end

    // ============================
    // READ STAGE
    // ============================
    function automatic int get_index(input int lane);
        return base + warp_id * LANES + lane;
    endfunction

    always_comb begin
        for (int i = 0; i < LANES; i++) begin
            automatic int idx = get_index(i);

            if (idx < DEPTH)
                pixel_in[i] = in_mem[idx];
            else
                pixel_in[i] = 24'h0;
        end
    end

    // ============================
    // PIPELINE + WRITE
    // ============================
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            base <= 0;
            base_reg <= 0;
            warp_id_reg <= 0;
            valid <= 0;

            for (int i = 0; i < LANES; i++)
                pixel_reg[i] <= 0;

        end else begin

            // ----------------------------
            // STAGE 1: Capture inputs
            // ----------------------------
            for (int i = 0; i < LANES; i++)
                pixel_reg[i] <= pixel_in[i];

            warp_id_reg <= warp_id;
            base_reg    <= base;

            valid <= 1;

            // ----------------------------
            // STAGE 2: WRITE (aligned)
            // ----------------------------
            if (valid) begin
                for (int i = 0; i < LANES; i++) begin
                    automatic int idx = base_reg + warp_id_reg * LANES + i;

                    if (idx < DEPTH)
                        out_mem[idx] <= {gray_out[i], gray_out[i], gray_out[i]};
                end
            end

            // ----------------------------
            // ADVANCE BASE
            // ----------------------------
            if (warp_id == WARPS-1)
                base <= base + (LANES * WARPS);
        end
    end

endmodule