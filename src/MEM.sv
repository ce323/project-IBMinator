module MEM (
    clk,
	
	alu_result,
	mem_to_reg,
	read_data,
	rd_num,
	reg_write,

	alu_result_out,
	mem_to_reg_out,
	read_data_out,
	rd_num_out,
	reg_write_out
);



input clk, mem_to_reg, reg_write;
input [31:0] alu_result, read_data;
input [4:0] rd_num;

output reg mem_to_reg_out, reg_write_out;
output reg [31:0] alu_result_out, read_data_out;
output reg [4:0] rd_num_out;

always @(posedge clk) begin
	$display("##################################################################");
	$display("MEM");
	$display("mem_to_reg: %b reg_write: %b alu_result: %b read_data: %b rd_num: %b", mem_to_reg, reg_write, alu_result, read_data, rd_num);
	
	mem_to_reg_out <= mem_to_reg;
	reg_write_out <= reg_write;
	alu_result_out <= alu_result;
	read_data_out <= read_data;
	rd_num_out <= rd_num;
end

endmodule