module uart_baud_gen #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 115200
)(
    input  wire clk,
    input  wire rst_n,
    output reg  tick
);
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE; // 434

    reg [8:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 9'd0;
            tick    <= 1'b0;
        end else begin
            if (counter == CLKS_PER_BIT - 1) begin
                counter <= 9'd0;
                tick    <= 1'b1;
            end else begin
                counter <= counter + 1;
                tick    <= 1'b0;
            end
        end
    end
endmodule
