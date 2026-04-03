module pe (
    input  logic [23:0] pixel,
    output logic [7:0]  gray
);

    logic [7:0] R, G, B;

    // Unpack RGB
    assign R = pixel[23:16];
    assign G = pixel[15:8];
    assign B = pixel[7:0];

    // Grayscale (integer approximation)
    assign gray = (77*R + 150*G + 29*B) >> 8;

endmodule
