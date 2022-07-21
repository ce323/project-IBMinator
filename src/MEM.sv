module MEM (
	cache_done,
    clk,
	
	alu_result,
	mem_to_reg,
	read_data,
	rd_num,
	reg_write,
	halted,
	addr_reg_2,
    addr_reg_2_out,

	alu_result_out,
	mem_to_reg_out,
	read_data_out,
	rd_num_out,
	reg_write_out,
	halted_out,
	reg_write_coprocessor,
	reg_write_coprocessor_out
);



input cache_done,clk, mem_to_reg, reg_write, halted;
input [31:0] alu_result, read_data;
input [4:0] rd_num;
input[4:0] addr_reg_2;
output reg [4:0] addr_reg_2_out;
output reg mem_to_reg_out, reg_write_out, halted_out;
output reg [31:0] alu_result_out, read_data_out;
output reg [4:0] rd_num_out;

input reg_write_coprocessor;
output reg reg_write_coprocessor_out;

always @(posedge clk) begin
	if(!cache_done) begin
	
	mem_to_reg_out <= mem_to_reg;
	reg_write_out <= reg_write;
	alu_result_out <= alu_result;
	read_data_out <= read_data;
	rd_num_out <= rd_num;
	addr_reg_2_out <= addr_reg_2;
	reg_write_coprocessor_out <= reg_write_coprocessor;
	halted_out <= halted;
	end
end

endmodule