module memory_controllerFSM #(
    parameter TILE_WORDS = 8   // 8 × 64-bit = 64 pixels
)(
    input  logic        clk,
    input  logic        reset,
    input  logic        start,

    // BRAM interface
    output logic [11:0] bram_addr,
    output logic        bram_we,
    output logic [63:0] bram_din,
    input  logic [63:0] bram_dout,

    // Config
    input  logic [11:0] base_addr,
    input  logic [9:0]  img_width
);

    // -----------------------------
    // FSM states
    // -----------------------------
    typedef enum logic [2:0] {
        IDLE,
        READ_STREAM,
        WAIT_BRAM,
        FILL_TILE,
        PROCESS,
        WRITEBACK
    } state_t;

    state_t state;

    // -----------------------------
    // Internal registers
    // -----------------------------
    logic [63:0] data_reg;
    logic [7:0]  tile_buf [0:(TILE_WORDS*8)-1];

    logic [2:0]  word_count;   // counts 64-bit words
    logic [5:0]  pixel_index;  // counts pixels

    // -----------------------------
    // Pixel splitter
    // -----------------------------
    logic [7:0] pixels [0:7];

    pixel_splitter SPLIT (
        .clk(clk),
        .data_in(data_reg),
        .pixels(pixels)
    );

    // -----------------------------
    // FSM
    // -----------------------------
    integer i;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state        <= IDLE;
            bram_we      <= 0;
            bram_addr    <= 0;
            bram_din     <= 0;
            word_count   <= 0;
            pixel_index  <= 0;
        end else begin
            bram_we <= 0; // default

            case (state)

                // -----------------
                IDLE: begin
                    if (start) begin
                        word_count  <= 0;
                        pixel_index <= 0;
                        bram_addr   <= base_addr;
                        state       <= READ_STREAM;
                    end
                end

                // -----------------
                READ_STREAM: begin
                    bram_addr <= base_addr + word_count;
                    state     <= WAIT_BRAM;
                end

                // -----------------
                WAIT_BRAM: begin
                    data_reg <= bram_dout;   // stall absorbed here
                    state    <= FILL_TILE;
                end

                // -----------------
                FILL_TILE: begin
                    for (i = 0; i < 8; i++) begin
                        tile_buf[pixel_index + i] <= pixels[i];
                    end

                    pixel_index <= pixel_index + 8;
                    word_count  <= word_count + 1;

                    if (word_count == TILE_WORDS-1)
                        state <= PROCESS;
                    else
                        state <= READ_STREAM;
                end

                // -----------------
                PROCESS: begin
                    // Dummy compute stage
                    // (placeholder for CNN / filter)
                    state <= WRITEBACK;
                end

                // -----------------
                WRITEBACK: begin
                    bram_addr <= base_addr;
                    bram_din  <= data_reg; // demo: write last word
                    bram_we   <= 1;
                    state     <= IDLE;
                end

            endcase
        end
    end
endmodule
