`timescale 1ns/1ps

module tb_sm_core;

    parameter DATA_WIDTH = 24;
    parameter WARP_SIZE  = 8;
    parameter NUM_WARPS  = 4;
    parameter IMG_SIZE   = 65536;

    reg clk;
    reg rst;

    reg  [7:0] image_mem [0:IMG_SIZE-1];   // ✅ FIXED: 8-bit input
    reg  [7:0] out_mem   [0:IMG_SIZE-1];

    reg  [DATA_WIDTH-1:0] warp_in  [0:WARP_SIZE-1];
    wire [7:0] warp_out [0:WARP_SIZE-1];

    reg valid_in;
    wire valid_out;

    integer i;
    integer pixel_idx;
    integer file;
    integer out_idx;

    // DUT
    sm_core #(
        .DATA_WIDTH(DATA_WIDTH),
        .WARP_SIZE(WARP_SIZE),
        .NUM_WARPS(NUM_WARPS)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .warp_in(warp_in),
        .valid_in(valid_in),
        .warp_out(warp_out),
        .valid_out(valid_out),
        .opcode(3'd5)   // grayscale
    );

    // Clock
    always #5 clk = ~clk;

    // Load image into warp
    task load_warp;
        integer j;
        begin
            for (j = 0; j < WARP_SIZE; j = j + 1) begin
                // ✅ FIX: 8-bit → 24-bit RGB expansion
                warp_in[j] = {
                    image_mem[pixel_idx],
                    image_mem[pixel_idx],
                    image_mem[pixel_idx]
                };
                pixel_idx = pixel_idx + 1;
            end
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        valid_in = 0;
        pixel_idx = 0;
        out_idx = 0;

        // Load input hex
        $readmemh("inpput.hex", image_mem);

        // Open output file
        file = $fopen("output.hex", "w");

        #20 rst = 0;

        // Feed warps
        for (i = 0; i < IMG_SIZE / WARP_SIZE; i = i + 1) begin
            @(posedge clk);
            load_warp();
            valid_in = 1;
        end

        @(posedge clk);
        valid_in = 0;

        // Wait some cycles
        #2000;

        // Close file
        $fclose(file);

        $display("DONE");
        $finish;
    end

    // Capture output
    always @(posedge clk) begin
        if (valid_out) begin
            for (i = 0; i < WARP_SIZE; i = i + 1) begin
                out_mem[out_idx] = warp_out[i];
                $fwrite(file, "%02h\n", warp_out[i]);
                out_idx = out_idx + 1;
            end
        end
    end

endmodule