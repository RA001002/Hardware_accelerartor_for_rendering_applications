`ifndef ISA_DEFS_VH
`define ISA_DEFS_VH

`define OPCODE_W 4

`define OP_ADD     4'b0000
`define OP_SUB     4'b0001
`define OP_MUL     4'b0010
`define OP_ABS     4'b0011
`define OP_MIN     4'b0100
`define OP_MAX     4'b0101
`define OP_SHIFTR  4'b0110
`define OP_MAC     4'b0111
`define OP_CLRACC  4'b1000
`define OP_MOVACC  4'b1001

`define DATA_W     16
`define ACC_W      32

`endif
