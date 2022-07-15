module IF (
    input [31:0] PC_plus_4_input,
    output reg [31:0] PC_plus_4_output,
    input [31:0] inst_in,
    output reg [31:0] inst_out,
    input clk,cache_done,
    output jmp_freeze
);

integer counter=0;

always @(posedge clk) begin
    if(!cache_done) begin
    if(((inst_in[31:26] == 6'b000000) && (inst_in[5:0] == 6'b001000)) 
    || (inst_in[31:26] == 6'b000100) || (inst_in[31:26] == 6'b000101) || (inst_in[31:26] == 6'b000110) || (inst_in[31:26] == 6'b000111) || (inst_in[31:26] == 6'b000001)
    || (inst_in[31:26] == 6'b000010) || (inst_in[31:26] == 6'b000011)) begin
        jmp_freeze = 1;
        counter = counter + 1;
    end
    if(counter == 3) begin
        jmp_freeze = 0;
        counter = 0;
    end
    else begin
    PC_plus_4_output <= PC_plus_4_input;
    inst_out <= inst_in;
    end
    end
end



endmodule