module matmul()
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 6,
    parameter VECTOR_SIZE = 8,
    parameter IDX_SIZE = 3
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

typedef enum logic [1:0] { s0, s1, s2, s3 } state_t;
state_t state, state_c;
logic [IDX_SIZE:0] j, k, j_c, k_c;
logic [IDX_SIZE:0] i, i_c;
logic done_c;
logic [DATA_WIDTH-1:0] sum, sum_c;

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        state <= s0;
        i <= '0;
        j <= '0;
        k <= '0;
        done <= 1'b0;
        sum <= '0;
    end else begin
        state <= state_c;
        i <= i_c;
        j <= j_c;
        k <= k_c;
        done <= done_c;
        sum <= sum_c;
    end
end

always_comb begin
    x_addr = 'b0;
    y_addr = 'b0;
    z_addr = 'b0;
    z_din = 'b0;
    z_wr_en = 'b0;
    done_c = done;
    i_c = i;
    j_c = j;
    k_c = k;
    state_c = state;
    sum_c = sum;

    case (state)
        s0: begin
            i_c = '0;
            j_c = '0;
            k_c = '0;
            sum_c = '0;
            if (start == 1'b1) begin
                state_c = s1;
                done_c = 1'b0;
            end
        end
        s1: begin
            x_addr = ($unsigned(i) * VECTOR_SIZE) + $unsigned(k);
            y_addr = ($unsigned(k) * VECTOR_SIZE) + $unsigned(j);
            state_c = s2; 
        end
        s2: begin
            x_addr = ($unsigned(i) * VECTOR_SIZE) + $unsigned(k);
            y_addr = ($unsigned(k) * VECTOR_SIZE) + $unsigned(j);
            sum_c = sum + ($unsigned(x_dout) * $unsigned(y_dout));
            k_c = k + 1;
        
            if ($unsigned(k) == VECTOR_SIZE - 1) begin
                k_c = '0;
                state_c = s3;
            end else begin
                state_c = s2;
            end
        end
        s3: begin
            z_din = sum;
            z_addr = ($unsigned(i) * VECTOR_SIZE) + $unsigned(j);
            z_wr_en = 1'b1;

            if ($unsigned(j) == $unsigned(VECTOR_SIZE) - 1 && $unsigned(i) == $unsigned(VECTOR_SIZE) - 1) begin
                done_c = 1'b1;
                state_c = s0;
            end else if ($unsigned(j) == $unsigned(VECTOR_SIZE) - 1) begin
                j_c = '0;
                i_c = i + 1;
            end else begin
                j_c = j + 1;
                i_c = i;
            end
            
            sum_c = '0;
            state_c = s1;

        end

        default: begin
            x_addr = 'x;
            y_addr = 'x;
            z_addr = 'x;
            z_din = 'x;
            z_wr_en = 'x;
            done_c = 'x;
            i_c = 'x;
            j_c = 'x;
            k_c = 'x;
            state_c = s0;
            sum_c = 'x;
        end
    endcase

end

endmodule
