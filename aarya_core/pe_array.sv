module pe_array #(
    parameter LANES = 8
)(
    input  logic [23:0] pixel_in [LANES],
    output logic [7:0]  gray_out [LANES]
);

    genvar i;
    generate
        for (i = 0; i < LANES; i++) begin : PE_BLOCK
            pe u_pe (
                .pixel(pixel_in[i]),
                .gray(gray_out[i])
            );
        end
    endgenerate

endmodule