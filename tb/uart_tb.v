`timescale 1ns/1ps

module uart_tb;

    reg        clk;
    reg        rst_n;
    wire       tick;
    reg        tx_start;
    reg  [7:0] tx_data;
    wire       tx_out;
    wire       tx_busy;
    wire [7:0] rx_data;
    wire       rx_ready;
    wire       rx_busy;
    wire       fifo_full;
    wire       fifo_empty;
    reg        rd_en;
    wire [7:0] rd_data;

    // Instantiate
    uart_baud_gen #(.CLK_FREQ(50000000), .BAUD_RATE(115200)) baud_gen (
        .clk(clk), .rst_n(rst_n), .tick(tick)
    );

    uart_tx tx (
        .clk(clk), .rst_n(rst_n), .tick(tick),
        .tx_start(tx_start), .tx_data(tx_data),
        .tx_out(tx_out), .tx_busy(tx_busy)
    );

    uart_rx rx (
        .clk(clk), .rst_n(rst_n), .rx_in(tx_out),
        .rx_data(rx_data), .rx_ready(rx_ready), .rx_busy(rx_busy)
    );

    uart_fifo #(.DEPTH(8), .WIDTH(8)) fifo (
        .clk(clk), .rst_n(rst_n),
        .wr_en(rx_ready), .wr_data(rx_data),
        .rd_en(rd_en), .rd_data(rd_data),
        .full(fifo_full), .empty(fifo_empty)
    );

    // 50 MHz clock
    initial clk = 0;
    always #10 clk = ~clk;

    // stimulus
    initial begin
        rst_n    = 0;
        tx_start = 0;
        tx_data  = 8'h00;
        rd_en    = 0;

        repeat(10) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);

        // send 0xA5
        tx_data  = 8'hA5;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        // wait for RX done
        @(posedge rx_ready);
        repeat(4) @(posedge clk);

        // read FIFO
        rd_en = 1;
        @(posedge clk);
        rd_en = 0;
        repeat(2) @(posedge clk);

        if (rd_data == 8'hA5)
            $display("PASS: received 0x%0h", rd_data);
        else
            $display("FAIL: expected 0xA5, got 0x%0h", rd_data);

        repeat(5) @(posedge clk);
        $finish;
    end

    initial begin
        $dumpfile("uart_tb.vcd");
        $dumpvars(0, uart_tb);
    end

endmodule
