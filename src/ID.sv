module ID(
    cache_done,
    clk,
    inst,
    //control inputs
    reg_dst,
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
    inst_out,
    //other outputs
    PC_plus_4_copy,
    read_data_1_copy,
    read_data_2_copy,
    sign_extend_out_copy,
    instruction_20_to_16_copy,
    instruction_15_to_11_copy
);

//inputs
input [5:0] alu_op;
input cache_done,clk, reg_dst, /*jump,*/ branch, write_signal, mem_to_reg, alu_src, 
    reg_write, is_mem_inst, is_word, halted_wire;

//outputs (we copy inputs into outputs without any change)
output reg [5:0] alu_op_copy;        
output reg reg_dst_copy, branch_copy, write_signal_copy, mem_to_reg_copy, alu_src_copy, 
    reg_write_copy, is_mem_inst_copy, is_word_copy, halted_wire_copy;

//other inputs
input [31:0] read_data_1,inst;
input [31:0] read_data_2;
input [31:0] PC_plus_4, sign_extend_out;
input [4:0] instruction_20_to_16, instruction_15_to_11;

//other outputs
output reg [31:0] read_data_1_copy,inst_out;
output reg [31:0]read_data_2_copy;
output reg [31:0] PC_plus_4_copy, sign_extend_out_copy;
output reg [4:0] instruction_20_to_16_copy, instruction_15_to_11_copy;

always @(posedge clk) begin
    if(!cache_done) begin
    //control assignments
    reg_dst_copy <= reg_dst;
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
    inst_out <= inst;
    end
end

endmodule;