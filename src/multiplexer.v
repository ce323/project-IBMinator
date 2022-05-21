module MULTIPLEXER( //tested and its fine
    in0,in1,select,out
);
parameter inbits = 4;

input [inbits-1:0] in0, in1;

input select;

output [inbits-1:0] out;

assign out = select ? in1 : in0;


endmodule