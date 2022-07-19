module coprocessor(
    input [4:0] addr_reg_in1, addr_reg_in2, addr_destination,
    input[5:0] opcode,
    input clk , 
    output [31:0] outdata_float ,
    input [31:0] inputdata_float   
);

    integer i;
    reg [31:0] registers [31:0];
    reg [31:0] t [0:5];
    reg [23:0] mantisa [2:0];
    reg [23:0] mul_ans,div_ans;
    reg [47:0] extra;
    reg [7:0] exponent [2:0];
    reg sign [2:0];
    reg div_by_zero,lower,higher,equal;
    integer bias = 127;
    integer power;
    // 000111 01010 101010100 => pipeline??
    // adds $ts0,$t1,$t2
    
    // lws $ts0,
    // sws
    
    // opcodes
    // add 110000 --> Done, Tested
    // sub 110001 --> Done, Tested
    // mul 110010 --> Done, Tested
    // div 110011 --> Done, Tested
    // cmp 110100 --> Done
    // rev 110101 --> Done, Tested
    // rnd 110110 --> Done, Tested
    // lw  110111 --> Done
    // sw  111000 --> Done


    //todo: sw and lw and connections (signals: input - output of this module)
    //tested and was correct: add - sub - mul - div - rev
    //not tested: cmp
    //in progress: rnd
    always @(posedge clk) begin
    
        //lw (load word)
        if (opcode == 6'b110111)
            registers[addr_reg_in1] = inputdata_float;

        //sw (store word)
        else if (opcode == 6'b111000)
            outdata_float = registers[addr_reg_in1];

        // add and subtract
        else if (opcode[5:1] == 5'b11000) begin
        mantisa[0] = {1'b1, register[addr_reg_in1][22:0]}; // store the mantisa and exponent of each operand
        mantisa[1] = {1'b1, register[addr_reg_in2][22:0]};
        exponent[0] = register[addr_reg_in1][30:23]; // store the mantisa and exponent of each operand
        exponent[1] = register[addr_reg_in2][30:23];
        sign[0] = register[addr_reg_in1][31];
        sign[1] = register[addr_reg_in2][31];

        if (register[addr_reg_in2] == 0)
            register[addr_destination] = register[addr_reg_in1];
        else begin
            if (register[addr_reg_in1] == 0) begin
                register[addr_destination] = register[addr_reg_in2];
                if (opcode[0]==1'b1)
                    register[addr_destination][31] = ~register[addr_destination][31];
                else
                    register[addr_destination] = register[addr_destination];
            end else begin
                if(exponent[0] > exponent[1]) begin
                    exponent[2] = exponent[0] - exponent[1];
                    register[addr_destination][30:23] = exponent[0];
                    mantisa[1]=(mantisa[1]) >> exponent[2];
                end else begin
                   exponent[2] = exponent[1] - exponent[0];
                   register[addr_destination][30:23] = exponent[1];
                   mantisa[0] = (mantisa[0]) >> exponent[2];
                end
                if((opcode[0] == 0 && !(sign[0] ^ sign[1])) 
                    ||(opcode[0] == 1 && (sign[0] ^ sign[1]))) begin
                        mantisa_sum = mantisa[0] + mantisa[1];
                        if(mantisa_sum[24] == 0) begin
                            register[addr_destination][22:0] = mantisa_sum[22:0];
                            register[addr_destination][31] = register[addr_reg_in1][31];     
                        end
                        else begin
                            mantisa_sum = mantisa_sum >> 1;
                            register[addr_destination][30:23] = register[addr_destination][30:23] + 1;
                            register[addr_destination][22:0] = mantisa_sum[22:0];
                            register[addr_destination][31] = register[addr_reg_in1][31];
                        end

                end else if ((opcode[0] == 1 && !(sign[0] ^ sign[1])) 
                    ||(opcode[0] == 0 && (sign[0] ^ sign[1]))) begin
                        d1 = mantisa[0];
                        d2 = mantisa[1];
                        d2 = ~d2[23:0] +1;
                        d2[24] = 0;
                     mantisa_sum = d1 + (d2 + 1) ;
                     if(mantisa_sum[24] == 1 && mantisa_sum[23:0] == 0)  begin
                         register[addr_destination] = 0;
                     end
                     else begin
                        if(mantisa_sum[24] == 0) begin
                            mantisa_sum[23:0] = ~mantisa_sum[23:0] + 1;
                            register[addr_destination][31] = ~register[addr_destination][31];
                        end
                        for (i = 0; i<23 && mantisa_sum[23] != 1 ;i=i+1 ) begin
                            mantisa_sum[23:0] = mantisa_sum[23:0] << 1;
                            register[addr_destination][30:23] = register[addr_destination][30:23] - 1;
                        end
                        register[addr_destination][22:0] = mantisa_sum[22:0];
                        if(mantisa[0] > mantisa[1])
                            register[addr_destination][31] = sign[0];
                        else
                            register[addr_destination][31] = opcode[0] == 0 ? sign[1]:~sign[1];
                     end
                end
            end
        end

        // multiply
        end else if(opcode == 6'b110010) begin
            mantisa[0] = {1'b1, register[addr_reg_in1][22:0]}; // store the mantisa and exponent of each operand
            mantisa[1] = {1'b1, register[addr_reg_in2][22:0]};
            exponent[0] = register[addr_reg_in1][30:23]; // store the mantisa and exponent of each operand
            exponent[1] = register[addr_reg_in2][30:23];

            if (register[addr_reg_in1] == 0 || register[addr_reg_in2] == 0)
                register[addr_destination] = 0;
            else begin
                mul_ans = 0;
                register[addr_destination][30:23] = exponent[0] + exponent[1] - bias + 1;
                register[addr_destination][31] = register[addr_reg_in1][31] ^ register[addr_reg_in2][31];
                mul_ans = mantisa[0] * mantisa[1];
                for (i = 0;i < 23 && mul_ans[47] != 1 ; i = i+1 ) begin
                    mul_ans = mul_ans << 1;
                    register[addr_destination][30:23] = register[addr_destination][30:23] - 1;
                end
            end

            register[addr_destination][22:0] = mul_ans[46:24];
        end


        else if(opcode == 6'b110011) begin
        div_by_zero = 0;

        mantisa[0] = {1'b1, register[addr_reg_in1][22:0]}; // store the mantisa and exponent of each operand
        mantisa[1] = {1'b1, register[addr_reg_in2][22:0]};
        exponent[0] = register[addr_reg_in1][30:23]; // store the mantisa and exponent of each operand
        exponent[1] = register[addr_reg_in2][30:23];
        if (register[addr_reg_in2] == 0)
            div_by_zero = 1;
        else if(register[addr_reg_in1] == 0)
            register[addr_destination] = 0;
        else begin
            register[addr_destination][31] = register[addr_reg_in1][31] ^ register[addr_reg_in2][31];

            extra = {mantisa[0],24'b0};
            extra = extra / mantisa[1];

            if(extra[24] == 1)
                extra = extra >> 1;
            else
                exponent[0] = exponent[0] - 1;
            div_ans = extra[23:0];
            register[addr_destination][30:23] = exponent[0] - exponent[1] + bias;

            for (i = 0; i<23 && div_ans[23] != 1 ; i = i + 1 ) begin
                div_ans = div_ans << 1;
            end
            register[addr_destination][22:0] = div_ans[22:0];
        end

        // divide
        end else if(opcode == 6'b110100) begin
            mantisa[0] = {1'b1, register[addr_reg_in1][22:0]}; // store the mantisa and exponent of each operand
            mantisa[1] = {1'b1, register[addr_reg_in2][22:0]};
            exponent[0] = register[addr_reg_in1][30:23]; // store the mantisa and exponent of each operand
            exponent[1] = register[addr_reg_in2][30:23];
            sign[0] = register[addr_reg_in1][31];
            sign[1] = register[addr_reg_in2][31];
            lower = 0;
            higher = 0;
            equal = 0;
            if(!sign[0] && !sign[1]) begin
            if(exponent[0] > exponent[1])
                higher = 1;
            else if(exponent[0]<exponent[1])
                lower = 1;
            else begin
                if(mantisa[0] > mantisa[1])
                    higher = 1;
                else if(mantisa[0]<mantisa[1])
                    lower = 1;
                else 
                    equal = 1; 
            end
            end
            else if(!sign[0] && sign[1])
                higher = 1;
            else if(sign[0] && !sign[1])
                lower  = 1;
            else begin
                if(exponent[0] < exponent[1])
                higher = 1;
            else if(exponent[0]>exponent[1])
                lower = 1;
            else begin
                if(mantisa[0] < mantisa[1])
                    higher = 1;
                else if(mantisa[0]>mantisa[1])
                    lower = 1;
                else 
                    equal = 1; 
            end
            end
        end

        // reverse
        else if (opcode == 6'b110101) begin
            div_by_zero = 0;

            mantisa[0] = {1'b1, 23'b00000000000000000000000};
            mantisa[1] = {1'b1, register[addr_reg_in1][22:0]};
            exponent[0] = 8'b01111111;
            exponent[1] = register[addr_reg_in1][30:23];
            if (register[addr_reg_in1] == 0)
                div_by_zero = 1;
            else begin
                register[addr_destination][31] = register[addr_reg_in1][31];

                extra = {mantisa[0], 24'b0};
                extra = extra / mantisa[1];

                if(extra[24] == 1)
                    extra = extra >> 1;
                else
                    exponent[0] = exponent[0] - 1;
                div_ans = extra[23:0];
                register[addr_destination][30:23] = exponent[0] - exponent[1] + bias;

                for (i = 0; i<23 && div_ans[23] != 1 ; i = i + 1 ) begin
                    div_ans = div_ans << 1;
                end
                register[addr_destination][22:0] = div_ans[22:0];
            end
        end

        // round
        else if (opcode = 6'b110110) begin
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
        end
end


endmodule