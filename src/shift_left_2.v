// tested and working perfect

module SHIFT_LEFT_2 (
    inst,
    out
);

parameter bits = 4;
input [bits-1:0] inst;
output [bits-1:0] out;

assign out = inst << 2;

endmodule