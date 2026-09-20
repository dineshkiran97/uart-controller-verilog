module uart_tx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tick,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx_out,
    output reg        tx_busy
);
    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            tx_out    <= 1'b1;
            tx_busy   <= 1'b0;
            shift_reg <= 8'd0;
            bit_cnt   <= 3'd0;
        end else begin
            case (state)
                IDLE: begin
                    tx_out  <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        shift_reg <= tx_data;
                        tx_busy   <= 1'b1;
                        state     <= START;
                    end
                end
                START: begin
                    if (tick) begin
                        tx_out  <= 1'b0;
                        bit_cnt <= 3'd0;
                        state   <= DATA;
                    end
                end
                DATA: begin
                    if (tick) begin
                        tx_out    <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        if (bit_cnt == 3'd7)
                            state <= STOP;
                        else
                            bit_cnt <= bit_cnt + 1;
                    end
                end
                STOP: begin
                    if (tick) begin
                        tx_out  <= 1'b1;
                        tx_busy <= 1'b0;
                        state   <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
