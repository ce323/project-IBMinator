// `include "multiplexer.v"
// `include "adder_32b.v"
// `include "shift_left_2.v"
// `include "sign_extend.v"
`include "control.v"

module test;

reg [15:0] a, b;
// reg [31:0] a,b,out;
reg select;
wire [31:0] jump_adr;
// MULTIPLEXER mux(.in0(a),.in1(b),.select(select),.out(out));
// ADDER_32B adder1(
//     .in1(a),.in2(b),
//     .out(out)
//     );
// SHIFT_LEFT_2 sl(
//     .inst(a),.out(out)
// );
// defparam sl.bits = 32;
// defparam mux.inbits = 1;
// SIGN_EXTEND se (.in(a), .out(out));
// assign jump_adr = {out[25:0],1'b0,1'b0,out[31:28]};
// SIGN_EXTEND se(
//     .in(a),.out(out)
// );

reg clk;
reg reg_dst, jump, branch, mem_write_en, mem_to_reg, alu_src, reg_write, halted;
// output mem_read;

wire [31:0] inst;
reg [5:0] alu_op;
wire 


always #1 begin
  clk = ~clk;
end

controll controll(
    .inst(inst[31:26]),
    .func(inst[5:0]),
    .reg_dst(reg_dst),
    .jump(jump),
    .branch(branch),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_write_en(mem_write_en),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .clk(clk),
    .halted(halted_wire)
);



assign jump_adr = a;
initial begin
    a = 32'b 0;
    b = 15'd 2;
    // out = 32'hcab42113;
    select = 0;
    #10
    // $display("%b\n%b",out,a);
    $display("%b\n%b",jump_adr,a);
end


endmodule