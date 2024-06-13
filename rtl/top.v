module top (
    input clk, reset,
    input Ext_MemWrite,
    input [31:0] Ext_WriteData, Ext_DataAdr,
    input [27:0] GPIO_IN_1,
    output MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [27:0] GPIO_OUT_1, GPIO_OE_1,
);

// wire lines from other modules
wire [31:0] PC, Instr;
wire MemWrite_rv32, IO_flag, IOWrite;
wire [31:0] DataAdr_rv32, WriteData_rv32, IOAdr, WriteIO, ReadIO; 
reg [31:0] ReadData_rv32;

// instantiate processor and memories
riscv_cpu rvsingle (clk, reset, PC, Instr, MemWrite_rv32, DataAdr_rv32, WriteData_rv32, ReadData_rv32);
instr_mem imem (PC, Instr);
data_mem dmem (clk, MemWrite, DataAdr, WriteData, ReadData);
IO_controller io(clk, IOWrite, IOAdr, WriteIO, GPIO_IN_1, GPIO_OE_1, GPIO_OUT_1, ReadIO);

always @* begin
    if (DataAdr_rv32 > 32'h03000000) begin
        ReadData_rv32 = ReadIO; // Assuming ReadIO is an external input
    end else begin
        ReadData_rv32 = ReadData; // Assuming ReadData is from data memory
    end
end
// output assignments
assign MemWrite =  ( DataAdr_rv32 < 32'h03000000 ) ? MemWrite_rv32 : 0;
assign WriteData = ( DataAdr_rv32 < 32'h03000000 ) ? WriteData_rv32 : 0;
assign DataAdr =   ( DataAdr_rv32 < 32'h03000000 ) ? DataAdr_rv32 : 0;

assign IOWrite = ( DataAdr_rv32 >= 32'h03000000 ) ? MemWrite_rv32 : 0;
assign IOAdr =   ( DataAdr_rv32 >= 32'h03000000 ) ? DataAdr_rv32 : 0;
assign WriteIO = ( DataAdr_rv32 >= 32'h03000000 ) ? WriteData_rv32 : 0;

endmodule
