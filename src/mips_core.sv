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


//wires for ID module
wire [5:0] alu_op_id_out;        
wire reg_dst_id_out, branch_id_out, write_signal_id_out, mem_to_reg_id_out, alu_src_id_out, 
    reg_write_id_out, is_mem_inst_id_out, is_word_id_out, halted_wire_id_out;
wire [7:0] read_data_1_id_out [3:0];
wire [7:0] read_data_2_id_out [3:0];
wire [31:0] sign_extend_out_id_out, PC_plus_4_id_out, alu_result_ex_out,alu_result_mem_out,read_data_mem_out;
wire [4:0] instruction_20_to_16_id_out, instruction_15_to_11_id_out,rd_num_ex_out, rd_num_mem_out;


ID id (
    .clk(clk),

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
    .read_data_1(mem_data_out),  // 4 * 8
    .read_data_2(mem_data_in),
    .sign_extend_out(sign_extend_out),
    .instruction_20_to_16(inst_if_out[20:16]),
    .instruction_15_to_11(inst_if_out[15:11]),

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

    .PC_plus_4_copy(PC_plus_4_id_out),
    // .pc_copy(inst_id_out),
    .read_data_1_copy(read_data_1_id_out),
    .read_data_2_copy(read_data_2_id_out),
    .sign_extend_out_copy(sign_extend_out_id_out),
    .instruction_20_to_16_copy(instruction_20_to_16_id_out),
    .instruction_15_to_11_copy(instruction_15_to_11_id_out)
);

wire mem_to_reg_mem_out, reg_write_mem_out;
MEM mem (
    .clk(clk),

    .alu_result(alu_result_ex_out),
    .mem_to_reg(mem_to_reg_ex_out),
	.read_data(read_data),
	.rd_num(rd_num_ex_out),
	.reg_write(reg_write_ex_out),

	.alu_result_out(alu_result_mem_out),
	.mem_to_reg_out(mem_to_reg_mem_out),
	.read_data_out(read_data_mem_out),
	.rd_num_out(rd_num_mem_out),
	.reg_write_out(reg_write_mem_out)
);

wire mem_write_en_ex_out, mem_to_reg_ex_out, reg_write_ex_out, is_mem_inst_ex_out, is_word_ex_out;

wire [7:0] read_data_2_ex_out [3:0];
EX ex (
    .clk(clk),
	.mem_write_en(write_signal_id_out),
	.mem_to_reg(mem_to_reg_id_out), 
	.reg_write(reg_write_id_out),
    .alu_result(cache_adr_input),
    .read_data_2(read_data_2_id_out),
    .rd_num(rd_num),
    .is_mem_inst(is_mem_inst_id_out),
    .is_word(is_word_id_out),
    
	.mem_write_en_out(mem_write_en_ex_out),
	.mem_to_reg_out(mem_to_reg_ex_out),
	.reg_write_out(reg_write_ex_out),
    .alu_result_out(alu_result_ex_out),
    .read_data_2_out(read_data_2_ex_out),
    .rd_num_out(rd_num_ex_out),
    .is_mem_inst_out(is_mem_inst_ex_out),
    .is_word_out(is_word_ex_out)
);

wire [31:0] PC_plus_4_if_output, inst_if_out;

IF fetch (
    .PC_plus_4_input(PC_plus_4),
    .PC_plus_4_output(PC_plus_4_if_output),
    .inst_in(inst),
    .inst_out(inst_if_out),
    .clk(clk)
);

wire [31:0] read_data_2_cache = {read_data_2_ex_out[3],read_data_2_ex_out[2],read_data_2_ex_out[1],read_data_2_ex_out[3]};
cache cache (
    .address_input(alu_result_ex_out),              // address that goes into cache generated from alu
    .address_output(mem_addr),                    // address that cache gives to memory
    .cache_input(read_data_2_cache),                    // input data of cache 
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

wire [4:0] rd_num = reg_dst_id_out ? inst[15:11] : inst[20:16];
wire [31:0] rd_data = mem_to_reg_mem_out ? read_data_mem_out : alu_result_mem_out;


regfile regfile (
    .rs_data(read_data_1),
    .rt_data(read_data_2),
    .rs_num(inst_if_out[25:21]),
    .rt_num(inst_if_out[20:16]),
    .rd_num(rd_num),
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
wire [31:0] input_2_alu = alu_src_id_out ? sign_extend_out_id_out : read_data_2;
wire [5:0] alu_op;

alu alu (
    .input1w(read_data_1),
    .input2w(input_2_alu),
    .zero(zero),
    .out(cache_adr_input), // goes in cache 
    .funcw(alu_op_id_out),
    .clk(clk),
    .rst_b(rst_b),
    .inst(inst),
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
    .halted(halted_wire)
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
    .pc_output(inst_addr)
);



always_latch @(rst_b, halted_wire) begin
    if(rst_b == 0)
        halted = 0;

    if(halted_wire == 1)
        halted = 1;
end

endmodule