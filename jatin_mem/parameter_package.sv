package parameter_package;

    parameter int ADDR_WIDTH  = 12;
    parameter int SIMD_LANES  = 4;
    parameter int PIXEL_WIDTH = 24;

    parameter int DATA_WIDTH  = SIMD_LANES * PIXEL_WIDTH;

    parameter int NUM_BANKS   = 4;
    parameter int BANK_DEPTH  = 1024;

    parameter int COAL_WINDOW = 4;

endpackage