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
    reg [22:0] mantisa [2:0];
    reg [7:0] exponent [2:0];
    reg sign [2:0];
    // 000111 01010 101010100 => pipeline??
    // adds $ts0,$t1,$t2
    
    // lws $ts0,
    // sws
    
    // opcodes
    // add 110000
    // sub 110001
    // mul 110010
    // div 110011
    // cmp 110100
    // rev 110101
    // rnd 110110
    // lw  110111
    // sw  111000


    // add and subtract
    always@(posedge clk) begin

    if (opcode[5:1] == 6'b11000) begin
    mantisa[0] = {1'b1,register[addr_reg_in1][22:0]}; // store the mantisa and exponent of each operand
    mantisa[1] = {1'b1,register[addr_reg_in2][22:0]};
    exponent[0] = register[addr_reg_in1][30:23]; // store the mantisa and exponent of each operand
    exponent[1] = register[addr_reg_in2][30:23];
    sign[0] =register[addr_reg_in1][31];
    sign[1] =register[addr_reg_in2][31];

    if(register[addr_reg_in2] == 0)
        register[addr_destination] = register[addr_reg_in1];
    else begin
        if(register[addr_reg_in1]==0) begin
            register[addr_destination] = register[addr_reg_in2];
            if(opcode[0]==1'b1)
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
               mantisa[0] = ( mantisa[0] ) >> exponent[2];
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


    end else if(opcode)
    
    end


endmodule