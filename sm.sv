`timescale 1ns/1ps
`include "isa_defs.vh"

module sm (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instr_mem [0:1023]
);

    // =================================================
    // Warp Scheduler
    // =================================================
    logic [1:0] warp_id;
    logic       warp_valid;
    logic [3:0] warp_active;
    logic [3:0] warp_stalled;

    assign warp_active = 4'b1111;

    warp_scheduler ws (
        .clk          (clk),
        .reset        (reset),
        .warp_active  (warp_active),
        .warp_stalled (warp_stalled),
        .warp_id      (warp_id),
        .warp_valid   (warp_valid)
    );

    // =================================================
    // Per-warp FSM
    // =================================================
    typedef enum logic [1:0] {
        W_IDLE  = 2'd0,
        W_LSU   = 2'd1,
        W_WAIT  = 2'd2,
        W_EXEC  = 2'd3
    } warp_state_t;

    warp_state_t warp_state [0:3];

    integer i;
    always_ff @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 4; i++)
                warp_state[i] <= W_IDLE;
        end else begin
            case (warp_state[warp_id])
                W_IDLE:  if (warp_valid) warp_state[warp_id] <= W_LSU;
                W_LSU:   warp_state[warp_id] <= W_WAIT;
                W_WAIT:  warp_state[warp_id] <= W_EXEC;
                W_EXEC:  warp_state[warp_id] <= W_IDLE;
            endcase
        end
    end

    assign warp_stalled = {
        warp_state[3] != W_IDLE,
        warp_state[2] != W_IDLE,
        warp_state[1] != W_IDLE,
        warp_state[0] != W_IDLE
    };

    // =================================================
    // Warp PC
    // =================================================
    logic [9:0] pc;

    warp_pc_table pc_tab (
        .clk     (clk),
        .reset   (reset),
        .warp_id (warp_id),
        .pc_we   (warp_state[warp_id] == W_EXEC),
        .pc_next (pc + 10'd1),
        .pc_out  (pc)
    );

    // =================================================
    // Fetch
    // =================================================
    logic [31:0] instr;
    logic        fetch_en;

    assign fetch_en = warp_valid && (warp_state[warp_id] == W_IDLE);

    fetch_unit fu (
        .clk       (clk),
        .reset     (reset),
        .fetch_en  (fetch_en),
        .pc        (pc),
        .instr_mem (instr_mem),
        .instr     (instr),
        .instr_valid()
    );

    // =================================================
    // ? PER-WARP INSTRUCTION LATCH (CRITICAL FIX)
    // =================================================
    logic [31:0] instr_reg [0:3];

    always_ff @(posedge clk) begin
        if (fetch_en)
            instr_reg[warp_id] <= instr;
    end

    // =================================================
    // Decode (from latched instruction)
    // =================================================
    logic [`OPCODE_W-1:0] opcode;
    logic [3:0]           shft;
    logic is_alu, is_mac, is_acc;
    logic acc_clr;

    decode_unit du (
        .instr        (instr_reg[warp_id]),
        .opcode       (opcode),
        .shft         (shft),
        .is_alu       (is_alu),
        .is_mac       (is_mac),
        .is_lsu       (),
        .is_acc       (is_acc),
        .acc_clr      (acc_clr),
        .writeback_en ()
    );

    // =================================================
    // LSU (1-cycle latency)
    // =================================================
    logic        lsu_rd_en;
    logic [11:0] lsu_addr;
    logic [7:0]  lsu_rd_data;

    assign lsu_rd_en = (warp_state[warp_id] == W_LSU);
    assign lsu_addr  = {warp_id, pc};

    lsu #(.ADDR_W(12)) lsu_u (
        .clk     (clk),
        .rst     (reset),
        .rd_en   (lsu_rd_en),
        .wr_en   (1'b0),
        .addr    (lsu_addr),
        .wr_data (8'd0),
        .rd_data (lsu_rd_data)
    );

    // =================================================
    // PE Array
    // =================================================
    logic signed [`DATA_W-1:0] in_a [8];
    logic signed [`DATA_W-1:0] in_b [8];
    logic signed [`DATA_W-1:0] out  [8];

    genvar g;
    generate
        for (g = 0; g < 8; g++) begin
            assign in_a[g] = {{8{lsu_rd_data[7]}}, lsu_rd_data};
            assign in_b[g] = 16'sd1;
        end
    endgenerate

    pe_array #(.N(8)) exec (
        .clk    (clk),
        .rst    (reset),
        .opcode (opcode),
        .shft   (shft),
        .in_a   (in_a),
        .in_b   (in_b),
        .out    (out)
    );

endmodule
