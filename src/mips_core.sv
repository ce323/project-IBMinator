// `include "adder_32b.v"
// `include "alu.v"
// `include "aluControll.v"
// `include "controll.v"
// `include "multiplexer.v"
// `include "registers.v"
// `include "sign_extend.v"


module mips_core(
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

/*    inst_addr --> pc
      adder1 = pc + 4;
      adder2 = (pc+4) + shifter output;

 ---------------mips_core :-----------------
inst         -->   Instruction             : input 32 
inst_addr    -->   pc/Read address         : output 32 
mem_addr     -->   alu_result/Address      : output 32
mem_data_out -->   read_data               : input 4 * 8
mem_data_in  -->   Read data 2/Write data  : output 4 * 8
mem_write_en -->   MemWrite                : output 1        // created by controll
halted       -->   syscall                 : output reg 1
clk          -->   clock                   : input 1
rst_b        -->   reset                   : input 1
-------------------------------------------


----------------regFile :-------------------
rs_data            -->                      : output 32
rt_data            -->                      : output 32
rs_num             -->    read register 1   : input 5
rt_num             -->    read register 2   : input 5
rd_num             -->    write register    : input 5
rd_data            -->                      : input 32
rd_we              -->    regwrite          : input 1
clk                -->    clk               : input 1
rst_b              -->    reset             : input 1
halted             -->    halted            : input 1
--------------------------------------      ------


----------------alu :-------------------
           -->                      : output 
           -->                      : output 
           -->                      : input 
           -->                      : input 
           -->                      : input 
           -->                      : input 
           -->                      : input 
           -->                      : input 
           -->                      : input 
           -->                      : input 
--------------------------------------------

----------------controll :-------------------
            -->                      : output
            -->                      : output
            -->                      : input 
            -->                      : input 
            -->                      : input 
            -->                      : input 
            -->                      : input 
            -->                      : input 
            -->                      : input 
            -->                      : input 
--------------------------------------------


        open value questions ? 

        mem_read?? 

*/


    // wire [5:0] rd_num;
    // reg [31:0] inst;
    // wire reg_dst,jump,branch,mem_read,mem_to_reg,alu_op,mem_write,alu_src,reg_write;

reg[31:0] inst_addr_reg;

wire [31:0] adder1_out,read_data2,adder2_out,read_data,shift_out,sign_extend_out,mux_2_out,mux_4_out,jump_adr,rs_data,rd_data;

wire [5:0] rd_num,alu_op;

wire jump,reg_dst,branch,alu_src,reg_write,mem_to_reg,mux_4_select,zero,mem_read;

// ADDER_32B adder1(.in1(inst_addr),.in2(4),.out(adder1_out)); // pc + 4

assign adder1_out = inst_addr + 4;

// ADDER_32B adder2(.in1(adder1_out),.in2(shift_out),.out(adder2_out)); // pc + 4 + shift_out

assign adder2_out = adder1_out + shift_out;

assign jump_adr = {inst[25:0],1'b0,1'b0,adder1_out[31:28]};

assign read_data = {mem_data_out[0],mem_data_out[1],mem_data_out[2],mem_data_out[3]};

assign read_data2 = {mem_data_in[0],mem_data_in[1],mem_data_in[2],mem_data_in[3]};

// SHIFT_LEFT_2 sl_2(.inst(sign_extend_out),.out(shift_out)); // gives the output to adder2

assign shift_out = sign_extend_out<<2;

// defparam sl_2.bits = 32;

// ALU_CONTROLL alu_controll(.clk(clk) // this is going to be merged with controller
// ,.inst(inst[5:0])
// ,.alu_op(alu_op)
// ,.alu_ctl_res(alu_ctl_res));


ALU alu(.clk(clk)
,.in1(rs_data) //Read data 1
,.in2(mux_2_out) // mux that alu_src controlls
,.alu_op(alu_op) // get the wanted operation from controll
,.zero(zero) // outputs zero 
,.sh.amount(inst[11:7])
,.alu_result(mem_addr)); // the alu result which goes into data memory

//multiplexer that gives write register
// MULTIPLEXER mux1(.in0(inst[20:16]),.in1(inst[15:11]),.select(reg_dst),.out(rd_num));

assign rd_num = reg_dst ? inst[15:11] : inst[20:16];

// defparam mux1.inbits = 4;

//multiplexer that giver the alu its input
// MULTIPLEXER mux2(.in0(read_data2),.in1(sign_extend_out),.select(alu_src),.out(mux_2_out));

assign mux_2_out = alu_src ? sign_extend_out : read_data2;

// defparam mux2.inbits = 32;

//multiplexer after Data memeory
// MULTIPLEXER mux3(.in0(mem_addr),.in1(read_data),.select(mem_to_reg),.out(rd_data));

assign rd_data = mem_to_reg ? read_data : mem_addr;

// defparam mux3.inbits = 32;

//multiplexer with adders input
// MULTIPLEXER mux4(.in0(adder1_out),.in1(adder2_out),.select(mux_4_select),.out(mux_4_out));

assign mux_4_out = mux_4_select ? adder2_out : adder1_out;

// defparam mux4.inbits = 32;

//multiplexer with jump address input 
// MULTIPLEXER mux5(.in0(mux_4_out),.in1(jump_adr),.select(jump),.out(inst_addr));

assign inst_addr = jump ? jump_adr : mux_4_out;

// defparam mux5.inbits = 32;

//sign extender :D
// SIGN_EXTEND sign_extend(.in(inst[15:0]),.out(sign_extend_out));

assign sign_extend_out = inst[15:0]; 


//controll to branch ,jump or neither of them
and(mux_4_select,branch,zero);

// register file that is given
regfile regfile(
    .rs_data(rs_data), // read data 1
    .rt_data(mem_data_in), // read data 2
    .rs_num(inst[25:21]), //read register 1
    .rt_num(inst[20:16]), // read register 2
    .rd_num(rd_num), // write register
    .rd_data(rd_data), //write data
    .rd_we(reg_write), // RegWrite
    .clk(clk), // got from input
    .rst_b(rst_b), //got from input
    .halted(halted) //got from input
);    



controll controll(.clk(clk)
,.inst(inst[31:26]) //input opcode
,.func(inst[5:0]) //input function
,.reg_dst(reg_dst)
,.jump(jump)
,.branch(branch)
,.mem_write_en(mem_write_en)
,.mem_to_reg(mem_to_reg)
,.alu_op(alu_op)
,.alu_src(alu_src)
,.reg_write(reg_write)
);


always_ff @(posedge clk, negedge rst_b) begin
    if(rst_b == 0) begin
        inst_addr <= 1;
        halted <= 0;
    end
end



endmodule