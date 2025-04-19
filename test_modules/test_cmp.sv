module test ();

reg [31:0] register [31:0];
reg [23:0] mantisa [2:0];
reg [7:0] exponent [2:0];
reg sign [2:0];

reg [31:0] in1 [19:0];
reg [31:0] in2 [19:0];
reg [4:0] addr_reg_in1 = 0, addr_reg_in2 = 1, addr_destination = 2;
reg lower, higher, equal;

initial begin
    in1[0] = 32'b11000001101110001110000101001000; // -23.11
    in2[0] = 32'b0; // 0

    in1[1] = 32'b0; // 0
    in2[1] = 32'b11000001101110001110000101001000; // -23.11

    in1[2] = 32'b11000001101110010100011110101110; // -23.16
    in2[2] = 32'b11000001101110001110000101001000; // -23.11

    in1[3] = 32'b11000001101110001110000101001000; // -23.11
    in2[3] = 32'b11000001101110010100011110101110; // -23.16

    in1[4] = 32'b01000000100011101001011110001101; // 4.456
    in2[4] = 32'b11000001101110010100011110101110; // -23.16

    in1[5] = 32'b11000001101110010100011110101110; // -23.16
    in2[5] = 32'b01000000100011101001011110001101; // 4.456

    in1[6] = 32'b01000011011010101010011101101101; // 234.654
    in2[6] = 32'b01000000100011101001011110001101; // 4.456

    in1[7] = 32'b01000000100011101001011110001101; // 4.456
    in2[7] = 32'b01000011011010101010011101101101; // 234.654

    in1[8] = 32'b01000000100011101001011110001101; // 4.456
    in2[8] = 32'b01000000100011101001011110001101; // 4.456

    in1[9] = 32'b0; // 0
    in2[9] = 32'b01000000100011101001011110001101; // 4.456
    
    in1[10] = 32'b01000000100011101001011110001101; // 4.456
    in2[10] = 32'b0; // 0

    in1[11] = 32'b11000001101110010100011110101110; // -23.16
    in2[11] = 32'b11000001101110010100011110101110; // -23.16

    in1[12] = 32'b0; // 0
    in2[12] = 32'b0; // 0

    in1[13] = 32'b01001011000110011011111111011110; // 10076126.0
    in2[13] = 32'b01001011000100011011111111011110; // 9551838.0
    
    in1[14] = 32'b01001011000100011011111111011110; // 9551838.0
    in2[14] = 32'b01001011000110011011111111011110; // 10076126.0

    in1[15] = 32'b11001011000100011011111111011110; // -9551838.0
    in2[15] = 32'b11001010000100011011111111011110; // -2387959.5
    
    in1[16] = 32'b11001010000100011011111111011110; // -2387959.5
    in2[16] = 32'b11001011000100011011111111011110; // -9551838.0
    
    register[addr_reg_in1] = in1[0];
    register[addr_reg_in2] = in2[0];
    
    mantisa[0] = {1'b1, register[addr_reg_in1][22:0]}; // store the mantisa and exponent of each operand
    mantisa[1] = {1'b1, register[addr_reg_in2][22:0]};
    exponent[0] = register[addr_reg_in1][30:23]; // store the mantisa and exponent of each operand
    exponent[1] = register[addr_reg_in2][30:23];
    sign[0] = register[addr_reg_in1][31];
    sign[1] = register[addr_reg_in2][31];

    lower = 0;
    higher = 0;
    equal = 0;

    if (!sign[0] && !sign[1]) begin
        if (exponent[0] > exponent[1])
            higher = 1;
        else if (exponent[0] < exponent[1])
            lower = 1;
        else begin
            if (mantisa[0] > mantisa[1])
                higher = 1;
            else if (mantisa[0] < mantisa[1])
                lower = 1;
            else
                equal = 1; 
        end
    end
    else if (!sign[0] && sign[1])
        higher = 1;
    else if (sign[0] && !sign[1])
        lower  = 1;
    else begin
        if (exponent[0] < exponent[1])
            higher = 1;
        else if (exponent[0] > exponent[1])
            lower = 1;
        else begin
            if (mantisa[0] < mantisa[1])
                higher = 1;
            else if (mantisa[0] > mantisa[1])
                lower = 1;
            else
                equal = 1; 
        end
    end

    $display("lower = %b, higher = %b, equal = %b", lower, higher, equal);
end
    
endmodule