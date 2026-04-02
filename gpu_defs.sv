package gpu_defs;

    localparam int NUM_CLUSTERS      = 2;
    localparam int SMS_PER_CLUSTER   = 1;

    localparam int NUM_WARPS = 4;
    localparam int WARP_SIZE = 8;

    localparam int NUM_CORES = 2;
    localparam int NUM_REGS  = 32;

    localparam int PC_WIDTH  = 10;

endpackage
