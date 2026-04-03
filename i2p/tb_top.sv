`timescale 1ns/1ps

module tb_top;

    parameter WIDTH  = 498;
    parameter HEIGHT = 378;
    parameter TOTAL  = WIDTH * HEIGHT * 3; // RGB input

    // ---------------- SIGNALS ----------------
    logic clk, reset;

    logic [7:0] pixel_in;
    logic       pixel_valid;

    logic [7:0] pixel_out;
    logic       pixel_out_valid;

    // ---------------- DUT ----------------
    top DUT (
        .clk(clk),
        .reset(reset),
        .pixel_in(pixel_in),
        .pixel_valid(pixel_valid),
        .pixel_out(pixel_out),
        .pixel_out_valid(pixel_out_valid)
    );

    // ---------------- CLOCK ----------------
    initial clk = 0;
    always #5 clk = ~clk;

    // ---------------- RESET ----------------
    initial begin
        reset = 1;
        #20;
        reset = 0;
    end

    // ---------------- MEMORY ----------------
    logic [7:0] image_mem [0:TOTAL-1];

    initial begin
        $display("Loading HEX...");
        $readmemh("inpput.hex", image_mem);
        $display("HEX LOADED");
    end

    // ---------------- INPUT STREAM ----------------
    int i;

    initial begin
        pixel_valid = 0;
        pixel_in    = 0;

        wait(!reset);

        for (i = 0; i < TOTAL; i++) begin
            @(posedge clk);
            pixel_in    =  image_mem[i];
            pixel_valid = 1;
        end

        @(posedge clk);
        pixel_valid = 0;
    end

    // ---------------- FILE ----------------
    int file_out;

    initial begin
        file_out = $fopen("output.txt", "w");

        if (file_out == 0) begin
            $display(" FILE OPEN FAILED");
        end else begin
            $display(" FILE OPEN SUCCESS");
        end
    end

    // ---------------- WRITE OUTPUT ----------------
    always @(posedge clk) begin
        if (pixel_out_valid) begin
            $fdisplay(file_out, "%0d", pixel_out);
        end
    end

    // ---------------- DEBUG ----------------
    always @(posedge clk) begin
        if (pixel_out_valid) begin
            $display("OUT = %0d", pixel_out);
        end
    end

    // ---------------- FORCE LONG RUN ----------------
    initial begin
        #150000000;   
        $display("SIMULATION COMPLETE");
        $fclose(file_out);
    end

endmodule