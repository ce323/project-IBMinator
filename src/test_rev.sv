module test ();

reg [31:0] register [31:0];
reg [23:0] mantisa [2:0];
reg [7:0] exponent [2:0]; // 1.011 * 2^2= 10.11 --- 
reg [31:0] in1 = 32'b 01000000101100000000000000000000;
reg [4:0] addr_reg_in1 = 0, addr_reg_in2 = 1, addr_destination = 2;
reg [23:0] div_ans;
reg [24:0] dummy;
reg [47:0] extra;
reg div_by_zero;
integer i;
integer bias = 127;

initial begin
    div_by_zero = 0;
    register[addr_reg_in1] = 32'b0_01111111_00000000000000000000000; // 5.5
    register[addr_reg_in2] = in1; // 6.5
    
    mantisa[0] = {1'b1,23'b00000000000000000000000}; // store the mantisa and exponent of each operand
    mantisa[1] = {1'b1,register[addr_reg_in2][22:0]};
    exponent[0] = 8'b01111111; // store the mantisa and exponent of each operand
    exponent[1] = register[addr_reg_in2][30:23];
    if (register[addr_reg_in2] == 0)
        div_by_zero = 1;
    else begin
        register[addr_destination][31] = register[addr_reg_in2][31];
        
        extra = {mantisa[0],24'b0};
        extra = extra / mantisa[1];
        
        if(extra[24] == 1)
            extra = extra >> 1;
        else
            exponent[0] = exponent[0] - 1;
        div_ans = extra[23:0];
        register[addr_destination][30:23] = exponent[0] - exponent[1] + 127;

        for (i = 0; i<23 && div_ans[23] != 1 ; i = i + 1 ) begin
            div_ans = div_ans << 1;
        end
        register[addr_destination][22:0] = div_ans[22:0];
        $display("aa = %b",register[addr_destination]);
    end
end
    
endmodule