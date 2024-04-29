module CPU_driver(
	input clk,CPU_start, MemWrite,
	input [31:0] WriteData, DataAdr, ReadData,                                //Data Mem access for CPU 
	output reg reset,
	output reg Ext_MemWrite,
	output reg [3:0] led,
	output reg [31:0] Ext_WriteData, Ext_DataAdr
);
reg CPU_state_flag = 0;
reg CPU_start_state = 0;
reg [1:0] CPU_state_counter = 0;
reg [3:0] index = 0, index2 = 0;
reg [1:0] state = 0;
reg [3:0] final_output [15:0];
reg [23:0] counter;
always @(posedge clk) begin
	if ( CPU_start && !CPU_state_flag) begin                                       //This loop makes sure that the CPU counter is switched only for 8 cycles
		if( CPU_state_counter == 3 ) begin                                         //i.e., until all required data is stored into memory
			CPU_state_counter <= 0;												   //This will also make sure the CPU is runnig only once for a set of SP and EP
			CPU_start_state <= 0;
			CPU_state_flag <= 1;
		end
		else begin
			CPU_state_counter <= CPU_state_counter + 1;
			CPU_start_state <= 1;
		end
	end
	else if( !CPU_start ) CPU_state_flag <= 0;
	if (CPU_start_state) begin
		reset <= 1;
		case (state)
		2'b00: begin
			Ext_MemWrite <= 1; Ext_WriteData <= 0; Ext_DataAdr <= 32'h02000000;
			state <= 2'b01;
		end 
		2'b01: begin
			Ext_MemWrite <= 0; Ext_WriteData <= 0; Ext_DataAdr <= 32'h0;
			state <= 2'b10;
		end
		2'b10: begin
			Ext_MemWrite <= 1; Ext_WriteData <= 0; Ext_DataAdr <= 32'h02000004;
			state <= 2'b11;
		end
		2'b11: begin
			Ext_MemWrite <= 0; Ext_WriteData <= 0; Ext_DataAdr <= 32'h0;
			state <= 2'b00;
			reset <= 0; 
		end 
		endcase
	end
	else if (MemWrite && !reset ) begin
		if(DataAdr === 32'h02000000) begin
			final_output [index] <= WriteData;
			index <= 1; 
		end
	end
	if (counter == 2000000) begin
        led <= final_output[index2];
		index2 <= index2 + 1;
        counter <= 0;
    end
	else counter <= counter + 1;
end

endmodule