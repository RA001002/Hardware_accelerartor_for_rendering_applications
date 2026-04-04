

module grayscale_simd(
    input  logic clk,
    input  logic [parameter_package::DATA_WIDTH-1:0] rgb_in,
    output logic [parameter_package::SIMD_LANES*8-1:0] gray_out
);

    import parameter_package::*;

    always_ff @(posedge clk) begin
        for (int i = 0; i < SIMD_LANES; i++) begin

            logic [7:0] R, G, B;
            logic [15:0] temp;

            R = rgb_in[i*24 +: 8];
            G = rgb_in[i*24 + 8 +: 8];
            B = rgb_in[i*24 + 16 +: 8];

            temp = (77*R + 150*G + 29*B);

            gray_out[i*8 +: 8] <= temp >> 8;
        end
    end

endmodule