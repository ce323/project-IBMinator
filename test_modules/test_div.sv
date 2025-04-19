module test ();

reg [31:0] register [31:0];
reg [23:0] mantisa [2:0];
reg [7:0] exponent [2:0]; // 1.011 * 2^2= 10.11 --- 
reg [31:0] in1 = 32'b 01000000110100000000000000000000, in2 = 32'b 01000000101100000000000000000000;
reg [4:0] addr_reg_in1 = 0, addr_reg_in2 = 1, addr_destination = 2;
reg [23:0] div_ans;
reg [24:0] dummy;
reg [47:0] aa;
reg div_by_zero;
integer i;
integer bias = 127;

initial begin
    div_by_zero = 0;
    register[addr_reg_in1] = in1; // 5.5
    register[addr_reg_in2] = in2; // 6.5

    mantisa[0] = {1'b1,register[addr_reg_in1][22:0]}; // store the mantisa and exponent of each operand
    mantisa[1] = {1'b1,register[addr_reg_in2][22:0]};
    exponent[0] = register[addr_reg_in1][30:23]; // store the mantisa and exponent of each operand
    exponent[1] = register[addr_reg_in2][30:23];
    if (register[addr_reg_in2] == 0)
        div_by_zero = 1;
    else if(register[addr_reg_in1] == 0)
        register[addr_destination] = 0;
    else begin
        register[addr_destination][31] = register[addr_reg_in1][31] ^ register[addr_reg_in2][31];
        
        aa = {mantisa[0],24'b0};
        aa = aa / mantisa[1];
        
        if(aa[24] == 1)
            aa = aa >> 1;
        else
            exponent[0] = exponent[0] - 1;
        div_ans = aa[23:0];
        register[addr_destination][30:23] = exponent[0] - exponent[1] + 127;

        for (i = 0; i<23 && div_ans[23] != 1 ; i = i + 1 ) begin
            div_ans = div_ans << 1;
        end
        register[addr_destination][22:0] = div_ans[22:0];
        $display("%b",register[addr_destination]);
    end
end
    
endmodule