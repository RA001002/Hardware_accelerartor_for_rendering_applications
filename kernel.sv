`timescale 1ns / 1ps
`timescale 1ns/1ps

module kernel #(
    parameter NUM_SMS    = 2,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  logic clk,
    input  logic reset,

    // Kernel launch
    input  logic start,
    input  logic [ADDR_WIDTH-1:0] kernel_base_addr,
    input  logic [31:0] num_threads,

    // Per-SM memory interface (VECTOR!)
    output logic [NUM_SMS-1:0] mem_req,
    output logic [NUM_SMS-1:0] mem_we,
    output logic [NUM_SMS-1:0][ADDR_WIDTH-1:0] mem_addr,
    output logic [NUM_SMS-1:0][DATA_WIDTH-1:0] mem_wdata,

    input  logic [NUM_SMS-1:0][DATA_WIDTH-1:0] mem_rdata,
    input  logic [NUM_SMS-1:0] mem_ready,

    output logic done
);

    // =====================================
    // Internal Signals
    // =====================================

    logic [NUM_SMS-1:0] sm_start;
    logic [NUM_SMS-1:0] sm_done;

    logic [31:0] threads_per_sm;

    assign threads_per_sm = num_threads / NUM_SMS;

    // =====================================
    // SM Instantiation
    // =====================================

    genvar i;
    generate
        for (i = 0; i < NUM_SMS; i++) begin : SM_ARRAY

            sm sm_inst (
                .clk(clk),
                .reset(reset),

                .start(sm_start[i]),
                .thread_count(threads_per_sm),
                .base_pc(kernel_base_addr),

                // Memory (per SM)
                .mem_req(mem_req[i]),
                .mem_we(mem_we[i]),
                .mem_addr(mem_addr[i]),
                .mem_wdata(mem_wdata[i]),
                .mem_rdata(mem_rdata[i]),
                .mem_ready(mem_ready[i]),

                .done(sm_done[i])
            );

        end
    endgenerate

    // =====================================
    // FSM (Kernel Control)
    // =====================================

    typedef enum logic [1:0] {
        IDLE,
        LAUNCH,
        RUN,
        COMPLETE
    } state_t;

    state_t state, next;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next;
    end

    always_comb begin
        next     = state;
        sm_start = '0;
        done     = 0;

        case (state)

            IDLE: begin
                if (start)
                    next = LAUNCH;
            end

            LAUNCH: begin
                sm_start = '1;   // pulse start
                next = RUN;
            end

            RUN: begin
                if (&sm_done)    // all SMs finished
                    next = COMPLETE;
            end

            COMPLETE: begin
                done = 1;
                if (!start)      // wait for restart
                    next = IDLE;
            end

        endcase
    end

endmodule
