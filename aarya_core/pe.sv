`timescale 1ns/1ps
module pe (
    input  logic [23:0] pixel_in,
    output logic [7:0]  gray
);

    logic [7:0] R, G, B;

    assign R = pixel_in[23:16];
    assign G = pixel_in[15:8];
    assign B = pixel_in[7:0];

    // Grayscale formula
    assign gray = (77*R + 150*G + 29*B) >> 8;

endmodule
