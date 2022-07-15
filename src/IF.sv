module IF (
    input [31:0] PC_plus_4_input,
    output reg [31:0] PC_plus_4_output,
    input [31:0] inst_in,
    output reg [31:0] inst_out,
    input clk,cache_done
);


always @(posedge clk) begin
    if(!cache_done) begin
    // $display("##################################################################");
    // $display("IF");
    // $display("PC_plus_4_input: %b inst_in: %b", PC_plus_4_input, inst_in);

    PC_plus_4_output <= PC_plus_4_input;
    inst_out <= inst_in;
    end
end



endmodule