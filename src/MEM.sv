module MEM(
    clk,
	mem_write_en,
	alu_result,
	mem_to_reg,
	read_data,
	rd_num,
	reg_write,
	mem_write_en_,ut
	alu_result,_out
	mem_to_reg,_out
	read_data,_out
	rd_num,_out
	reg_write,_out
);



input clk , mem_write_en , mem_to_reg , reg_write;

input[31:0] alu_result , read_data;
input[4:0] rd_num;

output reg mem_write_en_out , mem_to_reg_out , reg_write_out;
output[31:0] alu_result_out , read_data_out;
output[4:0] rd_num_out;

always@(posedge clk){
	mem_write_en_out <= mem_write_en;
	mem_to_reg_out <= mem_to_reg;
	reg_write_out <= reg_write;
	alu_result_out <= alu_result;
	read_data_out <= read_data;
	rd_num_out <= rd_num;
}

endmodule