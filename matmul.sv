module matmul()
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 12,
    parameter VECTOR_SIZE = 64
)
(
    input   logic                   clock,
    input   logic                   reset,
    input   logic                   start,
    output  logic                   done,
    input   logic [DATA_WIDTH-1:0]  x_dout,
    output  logic [ADDR_WIDTH-1:0]  x_addr,
    input   logic [DATA_WIDTH-1:0]  y_dout,
    output  logic [ADDR_WIDTH-1:0]  y_addr,
    output  logic [DATA_WIDTH-1:0]  z_din,
    output  logic [ADDR_WIDTH-1:0]  z_addr,
    output  logic                   z_wr_en
);
endmodule