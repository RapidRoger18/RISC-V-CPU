module top(
    input clk,
    input CPU_start,
    output [7:0] final_output
);
wire MemWrite;
wire [31:0] WriteData, DataAdr, ReadData;                                //Data Mem access for CPU 
wire reset;
wire Ext_MemWrite;
wire [31:0] Ext_WriteData, Ext_DataAdr;

cpu inst1 (.clk(clk), .reset(reset), .Ext_MemWrite(Ext_MemWrite), .Ext_WriteData(Ext_WriteData), .Ext_DataAdr(Ext_DataAdr), .MemWrite(MemWrite), .WriteData(WriteData), .DataAdr(DataAdr), .ReadData(ReadData));
CPU_driver inst2 (.clk(clk), .CPU_start(CPU_start), .MemWrite(MemWrite), .WriteData(WriteData), .DataAdr(DataAdr), .ReadData(ReadData), .reset(reset), .Ext_MemWrite(Ext_MemWrite), .final_output(final_output), .Ext_WriteData(), .Ext_DataAdr());

endmodule