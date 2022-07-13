module ID(
    clk,

    //control inputs
    reg_dst,
    /*jump,*/
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
    PC_plus_4,
    // pc,
    read_data_1,
    read_data_2,
    sign_extend_out,
    instruction_20_to_16,
    instruction_15_to_11,

    //control outputs
    reg_dst_copy, 
    // jump_copy, 
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
    PC_plus_4_copy,
    // pc_copy,
    read_data_1_copy,
    read_data_2_copy,
    sign_extend_out_copy,
    instruction_20_to_16_copy,
    instruction_15_to_11_copy
);

//inputs
input [5:0] alu_op;
input clk, reg_dst, /*jump,*/ branch, write_signal, mem_to_reg, alu_src, 
    reg_write, is_mem_inst, is_word, halted_wire;

//outputs (we copy inputs into outputs without any change)
output reg [5:0] alu_op_copy;        
output reg reg_dst_copy, /*jump_copy,*/ branch_copy, write_signal_copy, mem_to_reg_copy, alu_src_copy, 
    reg_write_copy, is_mem_inst_copy, is_word_copy, halted_wire_copy;

//other inputs
input [7:0] read_data_1 [3:0];
input [7:0] read_data_2 [3:0];
input [31:0] PC_plus_4, sign_extend_out;
input [4:0] instruction_20_to_16, instruction_15_to_11;

//other outputs
output reg [7:0] read_data_1_copy [3:0], read_data_2_copy [3:0];
output reg [31:0] PC_plus_4_copy, sign_extend_out_copy;
output reg [4:0] instruction_20_to_16_copy, instruction_15_to_11_copy;

always @(posedge clk) begin
    $display("##################################################################");
    $display("ID");
    $display("reg_dst: %b branch: %b write_signal: %b mem_to_reg: %b alu_src: %b reg_write: %b is_mem_inst: %b is_word: %b halted_wire: %b alu_op: %b PC_plus_4: %b read_data_1: %b read_data_2: %b sign_extend_out: %b instruction_20_to_16: %b instruction_15_to_11: %b is_mem_inst: %b is_word: %b", 
        reg_dst, branch, write_signal, mem_to_reg, alu_src, reg_write, is_mem_inst, is_word, halted_wire, alu_op, PC_plus_4, read_data_1, read_data_2, sign_extend_out, instruction_20_to_16, instruction_15_to_11,is_mem_inst,is_word);

    //control assignments
    reg_dst_copy <= reg_dst;
    // jump_copy <= jump;
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
    PC_plus_4_copy <= PC_plus_4;

    read_data_1_copy <= read_data_1;
    read_data_2_copy <= read_data_2;
    sign_extend_out_copy <= sign_extend_out;
    instruction_20_to_16_copy <= instruction_20_to_16;
    instruction_15_to_11_copy <= instruction_15_to_11;
end

endmodule;