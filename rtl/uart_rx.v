module uart_rx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rx_in,
    output reg  [7:0] rx_data,
    output reg        rx_ready,
    output reg        rx_busy
);
    localparam CLKS_PER_BIT = 434;
    localparam HALF_BIT     = 217;

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;
    reg [8:0] baud_cnt;
    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            baud_cnt  <= 9'd0;
            shift_reg <= 8'd0;
            bit_cnt   <= 3'd0;
            rx_data   <= 8'd0;
            rx_ready  <= 1'b0;
            rx_busy   <= 1'b0;
        end else begin
            rx_ready <= 1'b0;
            case (state)
                IDLE: begin
                    rx_busy  <= 1'b0;
                    baud_cnt <= 9'd0;
                    bit_cnt  <= 3'd0;
                    if (rx_in == 1'b0) begin
                        rx_busy <= 1'b1;
                        state   <= START;
                    end
                end
                START: begin
                    baud_cnt <= baud_cnt + 1;
                    if (baud_cnt == HALF_BIT - 1) begin
                        baud_cnt <= 9'd0;
                        if (rx_in == 1'b0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                end
                DATA: begin
                    baud_cnt <= baud_cnt + 1;
                    if (baud_cnt == CLKS_PER_BIT - 1) begin
                        baud_cnt  <= 9'd0;
                        shift_reg <= {rx_in, shift_reg[7:1]};
                        if (bit_cnt == 3'd7)
                            state <= STOP;
                        else
                            bit_cnt <= bit_cnt + 1;
                    end
                end
                STOP: begin
                    baud_cnt <= baud_cnt + 1;
                    if (baud_cnt == CLKS_PER_BIT - 1) begin
                        baud_cnt <= 9'd0;
                        if (rx_in == 1'b1) begin
                            rx_data  <= shift_reg;
                            rx_ready <= 1'b1;
                        end
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
