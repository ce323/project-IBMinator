module EX (
	clk,
	mem_write_en,
	mem_to_reg,
	reg_write,
    alu_result,
    read_data_2,
    rd_num,
	is_mem_inst,
	is_word,

	mem_write_en_out,
	mem_to_reg_out,
	reg_write_out,
    alu_result_out,
    read_data_2_out,
    rd_num_out,
	is_mem_inst_out,
	is_word_out
);

input clk, mem_write_en, mem_to_reg, reg_write, is_mem_inst, is_word;
output [4:0] rd_num;
input [31:0]alu_result;
input [7:0] read_data_2 [3:0];
output reg mem_write_en_out, mem_to_reg_out, reg_write_out, is_mem_inst_out, is_word_out;
output reg [4:0] rd_num_out;
output reg [31:0] alu_result_out;
output reg [7:0] read_data_2_out [3:0];

always @(posedge clk) begin
	$display("##################################################################");
	$display("EX");
	$display("mem_write_en:%b, mem_to_reg:%b, reg_write:%b rd_num:%b, alu_result:%b, read_data_2:%b",
			mem_write_en, mem_to_reg, reg_write, rd_num, alu_result, read_data_2);

	mem_write_en_out <= mem_write_en;
	mem_to_reg_out <= mem_to_reg; //debugged
	reg_write_out <= reg_write;
	rd_num_out <= rd_num;
	alu_result_out <= alu_result;
	read_data_2_out <= read_data_2;
	is_mem_inst_out <= is_mem_inst;
	is_word_out <= is_word;
end



endmodule