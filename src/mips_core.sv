// `include "adder_32b.v"
// `include "alu.v"
// `include "aluControll.v"
// `include "controll.v"
// `include "multiplexer.v"
// `include "registers.v"
// `include "sign_extend.v"


module mips_core(
    inst, //instruction memory drives this
    inst_addr, // we should declare this here **
    mem_addr, //alu results drives this
    mem_data_out, // output of data memory
    mem_data_in, //read data 2 drives this
    mem_write_en, // controll declares this
    halted, // we should declare this here **
    clk, // input from mips machine
    rst_b // we should declare this here **
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
wire reg_dst, jump, branch, mem_read, mem_to_reg, alu_src, reg_write;

wire [31:0] read_data_1;
wire [31:0] read_data_2 = {mem_data_in[0], mem_data_in[1], mem_data_in[2], mem_data_in[3]};
wire [31:0] read_data = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};

wire [4:0] rd_num = reg_dst ? inst[15:11] : inst[20:16];
wire [31:0] rd_data = mem_to_reg ? read_data : mem_addr;

regfile regfile(
    .rs_data(read_data_1),
    .rt_data(read_data_2),
    .rs_num(inst[25:21]),
    .rt_num(inst[20:16]),
    .rd_num(rd_num),
    .rd_data(rd_data),
    .rd_we(reg_write),
    .clk(clk),
    .
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
wire [31:0] sign_extend_out = $signed(inst);
wire [31:0] input_2_alu = alu_src ? sign_extend_out : read_data_2;

ALU alu(
    .in1(read_data_1),
    .in2(input_2_alu),
    .zero(zero),
    .alu_result(mem_addr),
    .clk(clk)
    .alu_op(alu_op), // get the wanted operation from controll
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


wire [5:0] alu_op; //TODO: maybe delete this

controll controll(
    .inst(inst[31:26]),
    .func(inst[5:0]), //??????????????????????????????
    .reg_dst(reg_dst),
    .jump(jump),
    .branch(branch),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_write_en(mem_write_en),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .clk(clk)
);


wire [31:0] PC_plus_4 = inst_addr + 4;
wire [31:0] adder2_out = PC_plus_4 + (sign_extend_out << 2);
wire [31:0] jump_address = {PC_plus_4[31:28], (inst[25:0] << 2)}
// assign jump_adr = {inst[25:0],1'b0,1'b0,PC_plus_4[31:28]};


// mux1 is the mux after "Add" (ALU result)
wire and_out;
and(and_out, zero, branch);
wire [31:0] mux1_out;
assign mux1_out = and_out ? adder2_out : PC_plus_4;

wire [31:0] mux_4_out, jump_adr;

assign pc_input = jump ? jump_adr : mux_4_out;

//program counter
PC pc(.clk(clk),.rst_b(rst_b),.pc_input(pc_input),.pc_output(inst_addr),.halted(halted));


//controll to branch ,jump or neither of them
wire mux_4_select;
assign mux_4_out = mux_4_select ? adder2_out : PC_plus_4;

/*

 pc --> register : inst_addr --- 

 */

endmodule