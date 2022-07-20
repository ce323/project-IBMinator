module test ();

reg [31:0] register [31:0];
reg [23:0] mantisa [2:0];
reg [7:0] exponent [2:0];
reg sign [2:0];

reg [31:0] in1 = 32'b01000000101100000000000000000000; // 5.5
reg [31:0] in2 = 32'b01000000101110000000000000000000; // 5.75
reg [31:0] in3 = 32'b01000000101010000000000000000000; // 5.25
reg [31:0] in4 = 32'b00111111100000000000000000000000; // 1.0
reg [31:0] in5 = 32'b10111111100000000000000000000000; // -1.0
reg [31:0] in6 = 32'b11000010000011100000000000000000; // -35.5
reg [31:0] in7 = 32'b11000010001101101100110011001101; // -45.7000007629
reg [31:0] in8 = 32'b11000010001101010011001100110011; // -45.2999992371
reg [31:0] in9 = 32'b01001010100110011011111111011101; // 5038062.5
reg [31:0] in10 = 32'b00111111001100110011001100110011; // 0.7
reg [31:0] in11 = 32'b00010000001100010111100010011001; // 3.5e-29
reg [31:0] in12 = 32'b01001100000110011011111111011101; // 40304500.0
reg [31:0] in13 = 32'b01001011000110011011111111011110; // 10076126.0

reg [4:0] addr_reg_in1 = 0, addr_reg_in2 = 1, addr_destination = 2;
integer i;
integer bias = 127;
integer power;
reg [22:0] dummy;

initial begin
    register[addr_reg_in1] = in1;
    // register[addr_reg_in1] = in2;
    // register[addr_reg_in1] = in3;
    // register[addr_reg_in1] = in4;
    // register[addr_reg_in1] = in5;
    // register[addr_reg_in1] = in6;
    // register[addr_reg_in1] = in7;
    // register[addr_reg_in1] = in8;
    // register[addr_reg_in1] = in9;
    // register[addr_reg_in1] = in10;
    // register[addr_reg_in1] = in11;
    // register[addr_reg_in1] = in12;
    // register[addr_reg_in1] = in13;
    
    mantisa[0] = register[addr_reg_in1][22:0];
    exponent[0] = register[addr_reg_in1][30:23];
    sign[0] = register[addr_reg_in1][31];

    register[addr_destination] = register[addr_reg_in1];

    power = exponent[0] - bias;
    if (0 <= power && power <= 22) begin
        if (mantisa[0][22 - power] == 1) begin
            dummy = 1;
            dummy = dummy << (22 - power);
            register[addr_destination][22:0] = mantisa[0] + dummy;
        end

        for (i = 0; i <= 22 - power; i = i + 1)
                register[addr_destination][i] = 0;
    end else if (power < 0) begin
        if (power == -1) begin
            register[addr_destination][30:23] = bias; // to power equal to 0
            register[addr_destination][22:0] = 0; // mantisa
        end else
            register[addr_destination] = 0; // all number
    end

    $display("result = %b", register[addr_destination]);
    // 01000000110000000000000000000000 = 6, in1
    // 01000000110000000000000000000000 = 6, in2
    // 01000000101000000000000000000000 = 5, in3
    // 00111111100000000000000000000000 = 1, in4
    // 10111111100000000000000000000000 = -1, in5
    // 11000010000100000000000000000000 = -36, in6
    // 11000010001110000000000000000000 = -46, in7
    // 11000010001101000000000000000000 = -45, in8
    // 01001010100110011011111111011110 = 5038063, in9
    // 00111111100000000000000000000000 = 1, in10
    // 00000000000000000000000000000000 = 0, in11
    // 01001100000110011011111111011101 = 40304500, in12
    // 01001011000110011011111111011110 = 10076126, in13
end
    
endmodule