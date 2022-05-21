`include "multiplexer.v"
`include "adder_32b.v"
module test;

reg [31:0] a,b;
reg select;
output[31:0] out;
// MULTIPLEXER mux(.in0(a),.in1(b),.select(select),.out(out));
ADDER_32B adder1(
    .in1(a),.in2(b),
    .out(out)
    );
// defparam mux.inbits = 1;
initial begin
    a = 32'd 112;
    b = 32'd 5;
    select = 0;
    #10
    $display(out);
end


endmodule