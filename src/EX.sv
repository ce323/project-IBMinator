module EX (
	cache_done,
	clk,
	mem_write_en,
	mem_to_reg,
	reg_write,
    alu_result,
    read_data_2,
    rd_num,
	is_mem_inst,
	is_word,
	halted,

	addr_reg_2,
    addr_reg_2_out,
	reg_write_coprocessor,
	reg_write_coprocessor_out,
	mem_write_en_out,
	mem_to_reg_out,
	reg_write_out,
    alu_result_out,
    read_data_2_out,
    rd_num_out,
	is_mem_inst_out,
	is_word_out,
	halted_out
);


input[4:0] addr_reg_2;
output reg[4:0] addr_reg_2_out;
input cache_done,clk, mem_write_en, mem_to_reg, reg_write, is_mem_inst, is_word,halted;
output [4:0] rd_num;
input [31:0]alu_result;
input [31:0] read_data_2;
output reg mem_write_en_out, mem_to_reg_out, reg_write_out, is_mem_inst_out, is_word_out,halted_out;
output reg [4:0] rd_num_out;
output reg [31:0] alu_result_out;
output reg [31:0] read_data_2_out;
input reg_write_coprocessor;
output reg reg_write_coprocessor_out;
always @(posedge clk) begin
	if(!cache_done) begin

	mem_write_en_out <= mem_write_en;
	mem_to_reg_out <= mem_to_reg; //debugged
	reg_write_out <= reg_write;
	rd_num_out <= rd_num;
	addr_reg_2_out <= addr_reg_2;
	alu_result_out <= alu_result;
	read_data_2_out <= read_data_2;
	is_mem_inst_out <= is_mem_inst;
	reg_write_coprocessor_out <= reg_write_coprocessor;
	is_word_out <= is_word;
	halted_out <= halted;
	end
end



endmodule