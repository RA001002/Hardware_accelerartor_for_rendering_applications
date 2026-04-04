

module pipelined_coalescing(
    input  logic clk,
    input  logic rst,

    mem_interface in_if,
    mem_interface out_if
);

    import parameter_package::*;

    logic [ADDR_WIDTH-1:0] buffer [COAL_WINDOW-1:0];
    logic [$clog2(COAL_WINDOW):0] count;

    assign in_if.ready = (count < COAL_WINDOW);

    // Stage 1: Buffer
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else if (in_if.valid && in_if.ready) begin
            buffer[count] <= in_if.addr;
            count <= count + 1;
        end
    end

    // Stage 2 + 3: Issue
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            out_if.valid <= 0;
        end else begin
            if (count == COAL_WINDOW) begin
                out_if.valid <= 1;
                out_if.addr  <= buffer[0];
                out_if.write <= in_if.write;
                out_if.wdata <= in_if.wdata;
                count <= 0;
            end else begin
                out_if.valid <= 0;
            end
        end
    end

endmodule