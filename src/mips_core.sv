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

wire [31:0] read_data_1;
wire [31:0] read_data_2;
wire [31:0] read_data;

wire hit, cache_done, write_signal;
wire [31:0] cache_adr_input;


cache cache (
    .address_input(cache_adr_input),              // address that goes into cache generated from alu
    .address_output(mem_addr),                    // address that cache gives to memory
    .cache_input(read_data_2),                    // input data of cache 
    .cache_data_out(read_data),                // output of cache
    .mem_data_in(mem_data_in),                    // output of cache to memory
    .mem_data_out(mem_data_out),                  // input of memory to cache
    .write_en_in(write_signal),                   // input signal of write or read to cache
    .write_en_out(mem_write_en),                  // output signal to main memory to write or read
    .is_word(is_word),
    .clk(clk), 
    .cache_done(cache_done),
    .reset(rst_b),
    .is_mem_inst(is_mem_inst)
);

wire [4:0] rd_num = reg_dst ? inst[15:11] : inst[20:16];
wire [31:0] rd_data = mem_to_reg ? read_data : cache_adr_input;


regfile regfile (
    .rs_data(read_data_1),
    .rt_data(read_data_2),
    .rs_num(inst[25:21]),
    .rt_num(inst[20:16]),
    .rd_num(rd_num),
    .rd_data(rd_data),
    .rd_we(reg_write),
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
wire [31:0] sign_extend_out = {{16{inst[15]}}, inst[15:0]};
wire [31:0] input_2_alu = alu_src ? sign_extend_out : read_data_2;
wire [5:0] alu_op;

alu alu (
    .input1w(read_data_1),
    .input2w(input_2_alu),
    .zero(zero),
    .out(cache_adr_input), // goes in cache 
    .funcw(alu_op),
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
    .inst(inst[31:26]),
    .func(inst[5:0]),
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
wire [31:0] adder2_out = PC_plus_4 + (sign_extend_out << 2);
wire [31:0] jump_address = {PC_plus_4[31:28], inst[25:0], 2'b0};

wire and_out;
and(and_out, zero, branch);
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