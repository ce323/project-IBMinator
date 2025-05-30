module mips_core (
    inst,
    inst_addr,
    mem_addr,
    mem_data_out,
    mem_data_in,
    mem_write_en,
    halted,
    clk,
    rst_b
);

output  [31:0] inst_addr;
input   [31:0] inst;
output  [31:0] mem_addr;
input   [7:0]  mem_data_out[0:3];
output  [7:0]  mem_data_in[0:3];
output         mem_write_en;
output reg     halted;
input          clk;
input          rst_b;

/*
----------------mips_core :------------------------
inst            -->        Instruction             : input   32 
inst_addr       -->        pc/Read address         : output  32 
mem_addr        -->        alu_result/Address      : output  32
mem_data_out    -->        read_data               : input   4 * 8
mem_data_in     -->        Read data 2/Write data  : output  4 * 8
mem_write_en    -->        MemWrite                : output  1
halted          -->        syscall                 : output  reg 1
clk             -->        clock                   : input   1
rst_b           -->        reset                   : input   1
---------------------------------------------------
*/

// controll outputs
wire reg_dst, jump, branch, mem_read, mem_to_reg, alu_src, reg_write, is_mem_inst, is_word;

wire [31:0] read_data_1, read_data_2, read_data;

wire hit, cache_done, write_signal;
wire [31:0] cache_adr_input;

//instance of coprocessor
//this part is used to connect main core and coprocessor
wire [4:0] addr_reg_in1, addr_reg_in2, addr_destination; //input of module
wire [5:0] opcode; //input of module
wire [31:0] outdata_float; //output of module
wire [31:0] inputdata_float; //input of module
coprocessor coprocessor (
    .addr_reg_in1(addr_reg_in1_id_out),
    .addr_reg_in2(addr_reg_in2_id_out),
    .addr_destination(addr_destination_id_out),
    .opcode(alu_op_id_out),
    .clk(clk), 
    .outdata_float(outdata_float),
    .inputdata_float(rd_data),
    .write_data_enable(reg_write_coprocessor_mem_out),
    .cache_done(cache_done),
    .write_address(addr_reg_2_mem_out)
);



//wires for ID module
wire [5:0] alu_op_id_out;        
wire reg_dst_id_out, branch_id_out, write_signal_id_out, mem_to_reg_id_out, alu_src_id_out, 
    reg_write_id_out, is_mem_inst_id_out, is_word_id_out, halted_wire_id_out;
wire [31:0] read_data_1_id_out;
wire [31:0] read_data_2_id_out ;
wire [31:0] sign_extend_out_id_out, PC_plus_4_id_out, alu_result_ex_out,alu_result_mem_out,read_data_mem_out,inst_id_out;
wire [4:0] instruction_20_to_16_id_out, instruction_15_to_11_id_out,rd_num_ex_out, rd_num_mem_out,addr_reg_in1_id_out,addr_reg_in2_id_out,addr_destination_id_out;
wire reg_write_coprocessor_id_out,reg_write_coprocessor_mem_out,reg_write_coprocessor_ex_out;
wire sw_coprocessor_copy;
ID id (
    .reg_write_coprocessor(reg_write_coprocessor),
    .cache_done(cache_done),
    .clk(clk),
    .inst(inst_if_out),
    .reg_dst(reg_dst),
    .branch(branch),
    .write_signal(write_signal),
    .mem_to_reg(mem_to_reg),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .is_mem_inst(is_mem_inst),
    .is_word(is_word),
    .halted_wire(halted_wire),
    .alu_op(alu_op),

    .PC_plus_4(PC_plus_4_if_output),
    // .pc(inst_if_out),
    .read_data_1(read_data_1),  // 4 * 8
    .read_data_2(read_data_2),
    .sign_extend_out(sign_extend_out),
    .instruction_20_to_16(inst_if_out[20:16]),
    .instruction_15_to_11(inst_if_out[15:11]),
    .inst_out(inst_id_out),
    .addr_reg_in1(inst_if_out[25:21]),
    .addr_reg_in2(inst_if_out[20:16]),
    .addr_destination(inst_if_out[15:11]),

    .reg_dst_copy(reg_dst_id_out),
    .branch_copy(branch_id_out),
    .write_signal_copy(write_signal_id_out),
    .mem_to_reg_copy(mem_to_reg_id_out),
    .alu_src_copy(alu_src_id_out), 
    .reg_write_copy(reg_write_id_out),
    .is_mem_inst_copy(is_mem_inst_id_out),
    .is_word_copy(is_word_id_out),
    .halted_wire_copy(halted_wire_id_out),
    .alu_op_copy(alu_op_id_out),
    .reg_write_coprocessor_out(reg_write_coprocessor_id_out),
    .PC_plus_4_copy(PC_plus_4_id_out),
    .addr_reg_in1_id_out(addr_reg_in1_id_out),
    .addr_reg_in2_id_out(addr_reg_in2_id_out),
    .addr_destination_id_out(addr_destination_id_out),
    // .pc_copy(inst_id_out),
    .read_data_1_copy(read_data_1_id_out),
    .read_data_2_copy(read_data_2_id_out),
    .sign_extend_out_copy(sign_extend_out_id_out),
    .instruction_20_to_16_copy(instruction_20_to_16_id_out),
    .instruction_15_to_11_copy(instruction_15_to_11_id_out),
    .sw_coprocessor(sw_coprocessor),
	.sw_coprocessor_copy(sw_coprocessor_copy)
);



wire mem_to_reg_mem_out, reg_write_mem_out;
MEM mem (
    .cache_done(cache_done),
    .clk(clk),
    .reg_write_coprocessor(reg_write_coprocessor_ex_out),
    .alu_result(alu_result_ex_out),
    .mem_to_reg(mem_to_reg_ex_out),
	.read_data(read_data),
	.rd_num(rd_num_ex_out),
	.reg_write(reg_write_ex_out),
    .halted(halted_ex_out),
    .addr_reg_2(addr_reg_2_ex_out),

    .addr_reg_2_out(addr_reg_2_mem_out),
    .reg_write_coprocessor_out(reg_write_coprocessor_mem_out),
	.alu_result_out(alu_result_mem_out),
	.mem_to_reg_out(mem_to_reg_mem_out),
	.read_data_out(read_data_mem_out),
	.rd_num_out(rd_num_mem_out),
	.reg_write_out(reg_write_mem_out),
    .halted_out(halted_mem_out)
);

wire mem_write_en_ex_out, mem_to_reg_ex_out, reg_write_ex_out, is_mem_inst_ex_out, is_word_ex_out, halted_ex_out, halted_mem_out,jmp_freeze;
wire [4:0] addr_reg_2_ex_out,addr_reg_2_mem_out;
wire [31:0] read_data_2_ex_out;
EX ex (
    .reg_write_coprocessor(reg_write_coprocessor_id_out),
    .cache_done(cache_done),
    .clk(clk),
	.mem_write_en(write_signal_id_out),
	.mem_to_reg(mem_to_reg_id_out), 
	.reg_write(reg_write_id_out),
    .alu_result(cache_adr_input),
    .read_data_2(memory_select),
    .rd_num(rd_num),
    .is_mem_inst(is_mem_inst_id_out),
    .is_word(is_word_id_out),
    .halted(halted_wire_id_out),
    .addr_reg_2(addr_reg_in2_id_out),
    
    .addr_reg_2_out(addr_reg_2_ex_out),
    .reg_write_coprocessor_out(reg_write_coprocessor_ex_out),
	.mem_write_en_out(mem_write_en_ex_out),
	.mem_to_reg_out(mem_to_reg_ex_out),
	.reg_write_out(reg_write_ex_out),
    .alu_result_out(alu_result_ex_out),
    .read_data_2_out(read_data_2_ex_out),
    .rd_num_out(rd_num_ex_out),
    .is_mem_inst_out(is_mem_inst_ex_out),
    .is_word_out(is_word_ex_out),
    .halted_out(halted_ex_out)
);

wire [31:0] PC_plus_4_if_output, inst_if_out;

IF fetch (
    .cache_done(cache_done),
    .PC_plus_4_input(PC_plus_4),
    .PC_plus_4_output(PC_plus_4_if_output),
    .inst_in(inst),
    .inst_out(inst_if_out),
    .clk(clk),
    .jmp_freeze(jmp_freeze)
);

cache cache (
    .address_input(alu_result_ex_out),              // address that goes into cache generated from alu
    .address_output(mem_addr),                    // address that cache gives to memory
    .cache_input(read_data_2_ex_out),                    // input data of cache 
    .cache_data_out(read_data),                // output of cache
    .mem_data_in(mem_data_in),                    // output of cache to memory
    .mem_data_out(mem_data_out),                  // input of memory to cache
    .write_en_in(mem_write_en_ex_out),                   // input signal of write or read to cache
    .write_en_out(mem_write_en),                  // output signal to main memory to write or read
    .is_word(is_word_ex_out),
    .clk(clk), 
    .cache_done(cache_done),
    .reset(rst_b),
    .is_mem_inst(is_mem_inst_ex_out)
);

wire [4:0] rd_num = reg_dst_id_out ? instruction_15_to_11_id_out : instruction_20_to_16_id_out;
wire [31:0] rd_data = mem_to_reg_mem_out ? read_data_mem_out : alu_result_mem_out;

wire [31:0] memory_select = sw_coprocessor_copy ? outdata_float : read_data_2_id_out;

regfile regfile (
    .rs_data(read_data_1),
    .rt_data(read_data_2),
    .rs_num(inst_if_out[25:21]),
    .rt_num(inst_if_out[20:16]),
    .rd_num(rd_num_mem_out),
    .rd_data(rd_data),
    .rd_we(reg_write_mem_out),
    .clk(clk),
    .rst_b(rst_b),
    .halted(halted)
);    

/*
----------------regFile   :------------------------
rs_data         -->        Read data 1             : output  32
rt_data         -->        Read data 2             : output  32
rs_num          -->        Read register 1         : input   5
rt_num          -->        Read register 2         : input   5
rd_num          -->        Write register          : input   5
rd_data         -->        Write data              : input   32
rd_we           -->        RegWrite                : input   1
clk             -->        clk                     : input   1
rst_b           -->        reset                   : input   1
halted          -->        halted                  : input   1
---------------------------------------------------
*/


wire zero;
wire [31:0] sign_extend_out = {{16{inst_if_out[15]}}, inst_if_out[15:0]};
wire [31:0] input_2_alu = alu_src_id_out ? sign_extend_out_id_out : read_data_2_id_out;
wire [5:0] alu_op;

alu alu (
    .input1w(read_data_1_id_out),
    .input2w(input_2_alu),
    .zero(zero),
    .out(cache_adr_input), // goes in cache 
    .funcw(alu_op_id_out),
    .clk(clk),
    .rst_b(rst_b),
    .inst(inst_id_out),
    .cache_done(cache_done)
);

/*
----------------alu       :------------------------
in1             -->        Read data               : input  32
in2             -->        mux(0: Read data 2, 1: Sign extended out)  : input  32
zero            -->        Zero                    : output  1
alu_result      -->        ALU result (in ALU)     : output  32
clk             -->        clk                     : input   1
---------------------------------------------------
*/

wire halted_wire;
wire reg_write_coprocessor, sw_coprocessor;
controll controll (
    .inst(inst_if_out[31:26]),
    .func(inst_if_out[5:0]),
    .reg_dst(reg_dst),
    .jump(jump),
    .branch(branch),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_write_en(write_signal),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .is_mem_inst(is_mem_inst),
    .is_word(is_word),
    .clk(clk),
    .halted(halted_wire),
    .reg_write_coprocessor(reg_write_coprocessor),
    .sw_coprocessor(sw_coprocessor)
);


wire [31:0] PC_plus_4 = inst_addr + 4;
wire [31:0] adder2_out = PC_plus_4_id_out + (sign_extend_out_id_out << 2);
wire [31:0] jump_address = {PC_plus_4[31:28], inst[25:0], 2'b0};


wire and_out;
and(and_out, zero, branch_id_out);
wire [31:0] mux1_out = and_out ? adder2_out : PC_plus_4;
wire [31:0] pc_input = jump ? jump_address : mux1_out;

pc pc(
    .clk(clk),
    .rst_b(rst_b),
    .pc_input(pc_input),
    .cache_done(cache_done),
    .pc_output(inst_addr),
    .jmp_freeze(jmp_freeze)
);



always_latch @(rst_b, halted_mem_out) begin
    if(rst_b == 0)
        halted = 0;

    if(halted_mem_out == 1)
        halted = 1;
end

endmodule