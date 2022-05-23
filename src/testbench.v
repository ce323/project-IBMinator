// `include "multiplexer.v"
// `include "adder_32b.v"
// `include "shift_left_2.v"
// `include "sign_extend.v"
module test;

reg [15:0] a,b;
reg select;
output[31:0] out;
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
SIGN_EXTEND se(
    .in(a),.out(out)
);
initial begin
    a = 15'b 101;
    b = 32'd 2;
    select = 0;
    #10
    $display("%b\n%b",out,a);
end


endmodule