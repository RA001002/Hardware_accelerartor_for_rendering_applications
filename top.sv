module top (
    input  logic clk,
    input  logic reset,
    input  logic start
);

    // -------------------------------------------------
    // BRAM interface signals
    // -------------------------------------------------
    logic [11:0] bram_addr;
    logic        bram_we;
    logic [63:0] bram_din;
    logic [63:0] bram_dout;

    // -------------------------------------------------
    // Handshake signals
    // -------------------------------------------------
    logic tile_valid;
    logic kernel_done;

    // -------------------------------------------------
    // Configuration registers
    // (can be driven by host later)
    // -------------------------------------------------
    logic [11:0] base_addr;
    logic [9:0]  img_width;

    // Static configuration for now
    assign base_addr = 12'd0;
    assign img_width = 10'd64;

    // -------------------------------------------------
    // MEMORY CONTROLLER (SYSTEM MASTER)
    // -------------------------------------------------
    MemoryControllerFSM #(
        .TILE_WORDS(8)
    ) u_mem_ctrl (
        .clk(clk),
        .reset(reset),
        .start(start),

        // BRAM interface
        .bram_addr(bram_addr),
        .bram_we(bram_we),
        .bram_din(bram_din),
        .bram_dout(bram_dout),

        // Configuration
        .base_addr(base_addr),
        .img_width(img_width),

        // Kernel handshake
        .tile_valid(tile_valid),
        .kernel_done(kernel_done)
    );

    // -------------------------------------------------
    // GLOBAL MEMORY (BRAM)
    // -------------------------------------------------
    bram_64 u_bram (
        .clk(clk),
        .we(bram_we),
        .addr(bram_addr),
        .din(bram_din),
        .dout(bram_dout)
    );

    // -------------------------------------------------
    // KERNEL SUBSYSTEM
    // (dispatcher + core + regfile inside)
    // -------------------------------------------------
    image_kernel_dispatcher u_kernel (
        .clk(clk),
        .reset(reset),

        // Handshake only
        .tile_valid(tile_valid),
        .kernel_done(kernel_done)

        // IMPORTANT:
        // Kernel does NOT touch BRAM
        // Kernel reads tile data internally
    );

endmodule
