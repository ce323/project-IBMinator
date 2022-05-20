`include "adder_32b.v"
`include "alu.v"
`include "aluControll.v"
`include "controll.v"
`include "multiplexer.v"
`include "registers.v"
`include "sign_extend.v"


module mips_core(
    inst_addr,
    inst,
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


    // wire [5:0] write_register;
    // reg [31:0] inst;
    // wire reg_dst,jump,branch,mem_read,mem_to_reg,alu_op,mem_write,alu_src,reg_write;


ADDER_32B adder1(.in1(inst_addr),.in2(4),.out(adder1_out));


ADDER_32B adder2(.in1(adder1_out),.in2(shift_out),.out(adder2_out));


SHIFT_LEFT_2 sl_1(.in(inst[25:0]),out(jump_adr));


SHIFT_LEFT_2 sl_2(.in(sign_extend_out),out(shift_out));

ALU_CONTROLL alu_controll(.clk(clk)
,.inst(inst[5:0])
,.alu_op(alu_op)
,.alu_ctl_res(alu_ctl_res));


ALU alu(.clk(clk)
,.in1(read_data1)
,.in2(mux_2_out)
,.alu_ctl_res(alu_ctl_res)
,.zero(zero)
,.(mem_addr));


MULTIPLEXER mux1(.in0(inst[20:16]),.in1(inst[15:11]),.select(reg_dst),.out(write_register));


MULTIPLEXER mux2(.in0(mem_data_in),.in1(sign_extend_out),.select(alu_src),.out(mux_2_out));


MULTIPLEXER mux3(.in0(mem_addr),.in1(mem_data_out),.select(mem_to_reg),.out(mux_3_out));


MULTIPLEXER mux4(.in0(adder1_out),.in1(adder2_out),.select(mux_4_select),.out(mux_4_out));


MULTIPLEXER mux5(.in0(mux_4_out),.in1(jump_adr),.select(jump),.out(inst_addr));

SIGN_EXTEND sign_extend(inst(inst[15:0]),.out(sign_extend_out));

and(mux_4_select,branch,zero);

REGISTERS registers(
    .clk(clk)
    ,.read_register1(inst[25:21])
    ,.read_registers2(inst[20:16])
    ,.write_register(write_register)
    ,.write_data(mux_2_out)
    ,read_data1(read_data1)
    ,read_data2(mem_data_in)
    );



CONTROLL controll(.clk(clk)
,.inst(inst[31:26])
,.reg_dst(reg_dst)
,.jump(jump)
,.branch(branch)
,.mem_read(mem_read)
,.mem_write_en(mem_write_en)
,.mem_to_reg(mem_to_reg)
,.alu_op(alu_op)
,.alu_src(alu_src)
,.reg_write(reg_write)
);


always_ff @(posedge clk,negedge rst_b) begin
    if(rst_b == 0) begin
        inst_addr <= 1;
        halted <= 0;
    end
    else begin
        inst_addr += 4;
    end
end



endmodule
