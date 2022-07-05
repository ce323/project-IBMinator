module ID(
    clk,
    //control inputs
    reg_dst,
    jump,
    branch,
    write_signal, 
    mem_to_reg,
    alu_src, 
    reg_write, 
    is_mem_inst, 
    is_word, 
    halted_wire, 
    alu_op, 
    
    //other inputs
    pc,
    read_data_1,
    read_data_2,
    sign_extend_out,
    instruction_20_to_16,
    instruction_15_to_11,

    //control outputs
    reg_dst_copy, 
    jump_copy, 
    branch_copy, 
    write_signal_copy, 
    mem_to_reg_copy,
    alu_src_copy, 
    reg_write_copy, 
    is_mem_inst_copy, 
    is_word_copy, 
    halted_wire_copy, 
    alu_op_copy,

    //other outputs
    pc_copy,
    read_data_1_copy,
    read_data_2_copy,
    sign_extend_out_copy,
    instruction_20_to_16_copy,
    instruction_15_to_11_copy
);

//inputs
input [5:0] alu_op;
input clk, reg_dst, jump, branch, write_signal, mem_to_reg, alu_src, 
    reg_write, is_mem_inst, is_word, halted_wire;

//outputs (we copy inputs into outputs without any change)
output reg [5:0] alu_op_copy;        
output reg reg_dst_copy, jump_copy, branch_copy, write_signal_copy, mem_to_reg_copy, alu_src_copy, 
    reg_write_copy, is_mem_inst_copy, is_word_copy, halted_wire_copy;

//other inputs
input [31:0] pc;
input [31:0] read_data_1;
input [31:0] read_data_2;
input [31:0] sign_extend_out;
input [4:0] instruction_20_to_16;
input [4:0] instruction_15_to_11;

//other outputs
input [31:0] pc_copy;
input [31:0] read_data_1_copy;
input [31:0] read_data_2_copy;
input [31:0] sign_extend_out_copy;
input [4:0] instruction_20_to_16_copy;
input [4:0] instruction_15_to_11_copy;

always@(posedge clk) begin
    //control assignments
    reg_dst_copy <= reg_dst;
    jump_copy <= jump;
    branch_copy <= branch;
    write_signal_copy <= write_signal;
    mem_to_reg_copy <= mem_to_reg;
    alu_src_copy <= alu_src; 
    reg_write_copy <= reg_write;
    is_mem_inst_copy <= is_mem_inst;
    is_word_copy <= is_word;
    halted_wire_copy <= halted_wire;
    alu_op_copy <= alu_op;
    //other aasignments
    pc_copy <= pc;
    read_data_1_copy <= read_data_1;
    read_data_2_copy <= read_data_2;
    sign_extend_out_copy <= sign_extend_out;
    instruction_20_to_16_copy <= instruction_20_to_16;
    instruction_15_to_11_copy <= instruction_15_to_11;
end
endmodule;