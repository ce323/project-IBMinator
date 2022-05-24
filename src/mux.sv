module mux(
    input select,
    input [31:0] in0,in1,
    output reg [31:0] out
);

always @(*) begin
    case (select)
        0: begin
            out = in0;
        end
        1: begin
            out = in1;
        end
    endcase
end

endmodule