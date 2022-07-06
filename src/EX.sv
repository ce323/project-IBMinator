module EX (
	clk,
	mem_write_en,
	mem_to_reg,
	reg_write,
    alu_result,
    read_data_2,
    rd_num,
	mem_write_en_out,
	mem_to_reg_out,
	reg_write_out,
    alu_result_out,
    read_data_2_out,
    rd_num_out,
	)

input clk, branch, mem_write_en, mem_to_reg, reg_write, zero;
output [4:0] rd_num;
input [31:0]alu_result, read_data_2;
output reg branch_out, mem_write_en_out, mem_to_reg_out, reg_write_out, zero_out;
output[4:0] rd_num_out;
output reg [31:0] alu_result_out, read_data_2_out;

always@(posedge clk){
 mem_write_en_out <= mem_write_en;
 mem_to_reg_out <= mem_to_reg_out;
 reg_write_out <= reg_write;
 zero_out <= zero;
 rd_num_out <= rd_num;
 alu_result <= alu_result_out;
 read_data_2 <= read_data_2_out
}



endmodule