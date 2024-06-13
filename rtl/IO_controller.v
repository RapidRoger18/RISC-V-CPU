module IO_controller #(parameter ADDR_WIDTH = 32, PORT_WIDTH = 6)(
    input                    clk, wr_en,
    input  [ADDR_WIDTH-1:0]  wr_addr, 
    input                    wr_data,
    input  [27:0]            GPIO_IN,
    output [27:0]            GPIO_OE,
    output [27:0]            GPIO_OUT,
    output                   rd_io_data
);

assign rd_io_data = GPIO_IN[wr_addr[PORT_WIDTH-1:0] % 28];
always @(posedge clk) begin
    if (wr_en) begin
        GPIO_OE[wr_addr[PORT_WIDTH-1:0] ] <= 1;
        GPIO_OUT[wr_addr[PORT_WIDTH-1:0] ] <= wr_data;
    end
end
endmodule