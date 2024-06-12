module IO_controller #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 1)(
    input                    clk, wr_en,
    input  [ADDR_WIDTH-1:0]  wr_addr, wr_data,
    input  [27:0]            GPIO_IN,
    output [27:0]            GPIO_OE,
    output [27:0]            GPIO_OUT,
    output [DATA_WIDTH-1:0]  rd_data
);

assign rd_data = GPIO_IN[6];
always @(posedge clk) begin
    assign
end
endmodule