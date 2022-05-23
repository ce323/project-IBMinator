// `include "multiplexer.v"
// `include "adder_32b.v"
// `include "shift_left_2.v"
// `include "sign_extend.v"

module test;

reg [15:0] a, b;
reg [31:0] a,b,out;
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
SIGN_EXTEND se (.in(a), .out(out));
assign jump_adr = {out[25:0],1'b0,1'b0,out[31:28]};
// SIGN_EXTEND se(
//     .in(a),.out(out)
// );
initial begin
    a = 32'b 10010000000000000000000000000000;
    b = 32'd 2;
    out = 32'hcab42113;
    select = 0;
    #10
    // $display("%b\n%b",out,a);
    $display("%b",jump_adr);
end


endmodule