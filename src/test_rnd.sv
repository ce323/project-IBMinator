module test ();

reg [31:0] register [31:0];
reg [23:0] mantisa [2:0];
reg [7:0] exponent [2:0];
reg sign [2:0];
reg [31:0] in1 = 32'b0_10000001_01100000000000000000000; // 5.5 . 101.100000000000000000000
reg [4:0] addr_reg_in1 = 0, addr_reg_in2 = 1, addr_destination = 2;
integer i;
integer bias = 127;
integer power;
reg [22:0] dummy;

initial begin
    register[addr_reg_in1] = in1;
    
    // mantisa[0] = {1'b1,23'b00000000000000000000000}; // store the mantisa and exponent of each operand
    // mantisa[1] = {1'b1,register[addr_reg_in2][22:0]};
    // exponent[0] = 8'b01111111; // store the mantisa and exponent of each operand
    // exponent[1] = register[addr_reg_in2][30:23];

    // if (register[addr_reg_in2] == 0)
    //     div_by_zero = 1;
    // else begin
    //     register[addr_destination][31] = register[addr_reg_in2][31];
        
    //     extra = {mantisa[0],24'b0};
    //     extra = extra / mantisa[1];
        
    //     if(extra[24] == 1)
    //         extra = extra >> 1;
    //     else
    //         exponent[0] = exponent[0] - 1;
    //     div_ans = extra[23:0];
    //     register[addr_destination][30:23] = exponent[0] - exponent[1] + 127;

    //     for (i = 0; i<23 && div_ans[23] != 1 ; i = i + 1 ) begin
    //         div_ans = div_ans << 1;
    //     end
    //     register[addr_destination][22:0] = div_ans[22:0];
    //     $display("aa = %b",register[addr_destination]);
    // end

    mantisa[0] = register[addr_reg_in1][22:0];
    exponent[0] = register[addr_reg_in1][30:23];
    sign[0] = register[addr_reg_in1][31];

    register[addr_destination] = register[addr_reg_in1];

    power = exponent[0] - bias;
    if (0 <= power && power <= 22) begin
        if (mantisa[0][23 - power] == 1) begin
            dummy = 1;
            dummy = dummy << (22 - power);

            if (sign[0])
                register[addr_destination][22:0] = mantisa[0] - dummy;
            else
                register[addr_destination][22:0] = mantisa[0] + dummy;
        end

        for (i = power; i < 23; i = i + 1)
                mantisa[0][i] = 0;
    end else if (power < 0) begin
        if (power == -1) begin
            register[addr_destination][30:23] = bias; // to power equal to 0
            register[addr_destination][22:0] = 0; // mantisa
        end else
            register[addr_destination] = 0; // all number
    end

    $display("result = %b", register[addr_destination]);
    // 01000000101000000000000000000000 = 5, in1
    // 01000000101100000000000000000000
end
    
endmodule