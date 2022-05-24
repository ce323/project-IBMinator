module mux(
    input select,
    input [31:0] in0,in1,
    output reg [31:0] out
);

always @(*) begin
    case (select)
        0: out = in0;
        1: out = in1;
    endcase
end

endmodule