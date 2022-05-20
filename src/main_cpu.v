`include "adder_32b.v"
`include "alu.v"
`include "aluControll.v"
`include "controll.v"
`include "data_memory.v"
`include "instruction_fetch.v"
`include "instruction_memory.v"
`include "multiplexer.v"
`include "registers.v"
`include "sign_extend.v"


module MAIN_CPU(
    input clk,
    input reg [31:0] pc,
    output
);
wire [5:0] write_register;
reg [31:0] instruction;
wire reg_dst,jump,branch,mem_read,mem_to_reg,alu_op,mem_write,alu_src,reg_write;



INSTRUCTION_MEMORY im(.clk(clk),.read_address(pc),.instruction(instruction));


ADDER_32B adder1(.in1(pc),.in2(4),.out(adder1_out));


ADDER_32B adder2(.in1(adder1_out),.in2(shift_out),.out(adder2_out));


SHIFT_LEFT_2 sl_1(.in(instruction[25:0]),out(jump_adr));


SHIFT_LEFT_2 sl_2(.in(sign_extend_out),out(shift_out));

ALU_CONTROLL alu_controll(.clk(clk)
,.instruction(instruction[5:0])
,.alu_op(alu_op)
,.alu_ctl_res(alu_ctl_res));


ALU alu(.clk(clk)
,.in1(read_data1)
,.in2(mux_2_out)
,.alu_ctl_res(alu_ctl_res)
,.zero(zero)
,.(alu_result));


MULTIPLEXER mux1(.in0(instruction[20:16]),.in1(instruction[15:11]),.select(reg_dst),.out(write_register));


MULTIPLEXER mux2(.in0(read_data2),.in1(sign_extend_out),.select(alu_src),.out(mux_2_out));


MULTIPLEXER mux3(.in0(alu_result),.in1(read_data),.select(mem_to_reg),.out(mux_3_out));


MULTIPLEXER mux4(.in0(adder1_out),.in1(adder2_out),.select(mux_4_select),.out(mux_4_out));


MULTIPLEXER mux5(.in0(mux_4_out),.in1(jump_adr),.select(jump),.out(pc));

SIGN_EXTEND sign_extend(instruction(instruction[15:0]),.out(sign_extend_out));

and(mux_4_select,branch,zero);

REGISTERS registers(
    .clk(clk)
    ,.read_register1(instruction[25:21])
    ,.read_registers2(instruction[20:16])
    ,.write_register(write_register)
    ,.write_data(mux_2_out)
    ,read_data1(read_data1)
    ,read_data2(read_data2)
    );



CONTROLL controll(.clk(clk)
,.instruction(instruction[31:26])
,.reg_dst(reg_dst)
,.jump(jump)
,.branch(branch)
,.mem_read(mem_read)
,.mem_write(mem_write)
,.mem_to_reg(mem_to_reg)
,.alu_op(alu_op)
,.alu_src(alu_src)
,.reg_write(reg_write)
);


DATA_MEMORY data_memory(.clk(clk)
,.address(alu_result)
,.write_data(read_data2)
,.read_data(read_data)
);







endmodule