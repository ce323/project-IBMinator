module test ();

reg [31:0] register [31:0];
reg [23:0] mantisa [2:0];
reg [7:0] exponent [2:0]; // 1.011 * 2^2= 10.11 --- 
reg [31:0] in1 = 32'b 01000000110100000000000000000000, in2 = 32'b 01000000101100000000000000000000;
reg [4:0] addr_reg_in1 = 0, addr_reg_in2 = 1, addr_destination = 2;
reg [47:0] mul_ans;
integer i;
integer bias = 127;

initial begin
    register[addr_reg_in1] = in1; // 5.5
    register[addr_reg_in2] = in2; // 6.5

    mantisa[0] = {1'b1,register[addr_reg_in1][22:0]}; // store the mantisa and exponent of each operand
    mantisa[1] = {1'b1,register[addr_reg_in2][22:0]};
    exponent[0] = register[addr_reg_in1][30:23]; // store the mantisa and exponent of each operand
    exponent[1] = register[addr_reg_in2][30:23];
    
    if (register[addr_reg_in1] == 0 || register[addr_reg_in2] == 0)
        register[addr_destination] = 0;
    else begin
        mul_ans = 0;
        register[addr_destination][30:23] = exponent[0] + exponent[1] - 127 + 1;
        register[addr_destination][31] = register[addr_reg_in1][31] ^ register[addr_reg_in2][31];
        mul_ans = mantisa[0] * mantisa[1];
        for (i = 0;i < 23 && mul_ans[47] != 1 ; i = i+1 ) begin
            mul_ans = mul_ans << 1;
            register[addr_destination][30:23] = register[addr_destination][30:23] - 1;
        end
    end
    register[addr_destination][22:0] = mul_ans[46:24];
    $display("%b",register[addr_destination]);
end
    
endmodule