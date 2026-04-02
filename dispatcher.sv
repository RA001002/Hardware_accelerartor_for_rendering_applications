`timescale 1ns / 1ps

module dispatcher #(
    parameter NUM_SMS    = 2,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  logic clk,
    input  logic reset,

    // ================================
    // FROM SMs
    // ================================
    input  logic [NUM_SMS-1:0] sm_mem_req,
    input  logic [NUM_SMS-1:0] sm_mem_we,
    input  logic [NUM_SMS-1:0][ADDR_WIDTH-1:0] sm_mem_addr,
    input  logic [NUM_SMS-1:0][DATA_WIDTH-1:0] sm_mem_wdata,

    output logic [NUM_SMS-1:0][DATA_WIDTH-1:0] sm_mem_rdata,
    output logic [NUM_SMS-1:0] sm_mem_ready,

    // ================================
    // TO MEMORY CONTROLLER
    // ================================
    output logic mem_req,
    output logic mem_we,
    output logic [ADDR_WIDTH-1:0] mem_addr,
    output logic [DATA_WIDTH-1:0] mem_wdata,

    input  logic [DATA_WIDTH-1:0] mem_rdata,
    input  logic mem_ready
);

    // =====================================
    // Arbiter State
    // =====================================

    logic [$clog2(NUM_SMS)-1:0] grant;
    logic [$clog2(NUM_SMS)-1:0] next_grant;

    // =====================================
    // Round-Robin Arbiter
    // =====================================

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            grant <= 0;
        else
            grant <= next_grant;
    end

    always_comb begin
        next_grant = grant;

        // Move to next requesting SM
        for (int i = 0; i < NUM_SMS; i++) begin
            int idx = (grant + i) % NUM_SMS;
            if (sm_mem_req[idx]) begin
                next_grant = idx;
                break;
            end
        end
    end

    // =====================================
    // Request Routing
    // =====================================

    always_comb begin
        mem_req   = sm_mem_req[grant];
        mem_we    = sm_mem_we[grant];
        mem_addr  = sm_mem_addr[grant];
        mem_wdata = sm_mem_wdata[grant];
    end

    // =====================================
    // Response Routing
    // =====================================

    always_comb begin
        // default
        for (int i = 0; i < NUM_SMS; i++) begin
            sm_mem_ready[i] = 0;
            sm_mem_rdata[i] = 0;
        end

        if (mem_ready && mem_req) begin
            sm_mem_ready[grant] = 1;
            sm_mem_rdata[grant] = mem_rdata;
        end
    end

endmodule