module top (
    input  logic clk,
    input  logic reset,

    input  logic [7:0] pixel_in,
    input  logic       pixel_valid,

    output logic [7:0] pixel_out,
    output logic       pixel_out_valid
);

    logic [7:0] r, g, b;
    logic [1:0] count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            r <= 0; g <= 0; b <= 0;
            count <= 0;
            pixel_out <= 0;
            pixel_out_valid <= 0;
        end else begin
            pixel_out_valid <= 0;

            if (pixel_valid) begin
                case (count)
                    2'd0: r <= pixel_in;
                    2'd1: g <= pixel_in;
                    2'd2: begin
                        b <= pixel_in;
                        pixel_out <= (r + g + pixel_in) / 3;
                        pixel_out_valid <= 1; // 🔥 VALID GUARANTEED
                    end
                endcase

                if (count == 2)
                    count <= 0;
                else
                    count <= count + 1;
            end
        end
    end

endmodule