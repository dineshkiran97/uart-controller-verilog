module uart_fifo #(
    parameter DEPTH = 8,
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             wr_en,
    input  wire [WIDTH-1:0] wr_data,
    input  wire             rd_en,
    output reg  [WIDTH-1:0] rd_data,
    output wire             full,
    output wire             empty
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;

    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wr_ptr[3] != rd_ptr[3]) && (wr_ptr[2:0] == rd_ptr[2:0]);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wr_ptr <= 4'd0;
        else if (wr_en && !full) begin
            mem[wr_ptr[2:0]] <= wr_data;
            wr_ptr           <= wr_ptr + 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr  <= 4'd0;
            rd_data <= 8'd0;
        end else if (rd_en && !empty) begin
            rd_data <= mem[rd_ptr[2:0]];
            rd_ptr  <= rd_ptr + 1;
        end
    end
endmodule
