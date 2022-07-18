module test ();

reg [31:0] register [31:0];
reg [22:0] mantisa [2:0];
reg [7:0] exponent [2:0]; // 1.011 * 2^2= 10.11 --- 
reg [31:0] in1 = 32'b0_10000011_01110000000000000000000, in2 = 32'b001111111_10000000000000000000000;
reg [4:0] addr_reg_in1 = 0, addr_reg_in2 = 1, addr_destination = 2;
integer i;
integer bias = 127;

initial begin
    register[addr_reg_in1] = in1; // 5.5
    register[addr_reg_in2] = in2; // 6.5

    mantisa[0] = register[addr_reg_in1][22:0]; // store the mantisa and exponent of each operand
    mantisa[1] = register[addr_reg_in2][22:0];
    exponent[0] = register[addr_reg_in1][30:23]; // store the mantisa and exponent of each operand
    exponent[1] = register[addr_reg_in2][30:23];
    
    if (register[addr_reg_in1] == 0 || register[addr_reg_in2] == 0)
        register[addr_destination] = 0;
    else begin
        register[addr_destination][30:23] = exponent[0] + exponent[1] - 7'b1111111;
        $display("exponent[0] = %d , exponent[1] = %d , result = %d", exponent[0], exponent[1], register[addr_destination][30:23]);
        register[addr_destination][31] = register[addr_reg_in1][31] ^ register[addr_reg_in2][31];

        {register[addr_destination][22:0], register[addr_reg_in1][22:0]} = mantisa[0] * mantisa[1];
        // $display("matisa[0] = %b, mantisa[1] = %b, result = %b", mantisa[0], mantisa[1], {register[addr_destination][22:0], register[addr_reg_in1][22:0]});
        if (register[addr_destination][22] == 0) begin
            {register[addr_destination][22:0], register[addr_reg_in1][22:0]} = {register[addr_destination][22:0], register[addr_reg_in1][22:0]} << 1;
            register[addr_destination][30:23] = register[addr_destination][30:23] - 1;
        end
    end

    $display("%b", register[addr_destination]);
    // 0_10000100_00011110000000000000000 = 35.75
end
    
endmodule