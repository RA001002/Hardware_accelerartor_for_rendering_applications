interface mem_interface #(parameter ADDR_WIDTH=12, DATA_WIDTH=96);

    logic valid, ready;
    logic [ADDR_WIDTH-1:0] addr;
    logic write;
    logic [DATA_WIDTH-1:0] wdata;
    logic [DATA_WIDTH-1:0] rdata;

endinterface