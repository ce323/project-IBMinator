module test ();

reg [31:0] register [31:0];
reg [23:0] mantisa [2:0];
reg [24:0] mantisa_sum ,d1,d2;
reg sign [2:0] ;
reg [7:0] exponent [2:0]; // 1.011 * 2^2= 10.11 --- 
reg [31:0] in1 [10:0];
reg [31:0] in2 [10:0];
reg [4:0] addr_reg_in1 = 0, addr_reg_in2 = 1, addr_destination = 2;
integer i,k;
integer bias = 127;
reg [5:0] opcode;
initial begin
    in1[0] = 32'b10111111100000000000000000000000; 
    in2[0] = 32'b11000000010000000000000000000000; 
    //11000000100000000000000000000000

    in1[1] = 32'b00111111100000000000000000000000; 
    in2[1] = 32'b01000000010000000000000000000000;
    //01000000100000000000000000000000

    in1[2] = 32'b00111111110000000000000000000000; 
    in2[2] = 32'b01000001101110000000000000000000; 
    //01000001110001000000000000000000

    in1[3] = 32'b01000000101100000000000000000000; 
    in2[3] = 32'b01000000110100000000000000000000; 
    //01000001010000000000000000000000

    in1[4] = 32'b11000000111000000000000000000000; 
    in2[4] = 32'b11000000110100000000000000000000; 
    //11000001010110000000000000000000

    in1[5] = 32'b11000000001000000000000000000000; 
    in2[5] = 32'b10111110100000000000000000000000; 
    //11000000001100000000000000000000

    in1[6] = 32'b10111111000000000000000000000000; 
    in2[6] = 32'b10111111000000000000000000000000; 
    //10111111100000000000000000000000

    in1[7] = 32'b00000000000000000000000000000000; 
    in2[7] = 32'b11000000110000000000000000000000;
    //11000000110000000000000000000000 

    in1[8] = 32'b11000000001000000000000000000000; 
    in2[8] = 32'b01000000010000000000000000000000; 
    //00111111000000000000000000000000

    in1[9] = 32'b11000000110000000000000000000000; 
    in2[9] = 32'b01000000001000000000000000000000; 
    //11000000011000000000000000000000

    in1[10] = 32'b0; 
    in2[10] = 32'b11000000110000000000000000000000; 
    //01000001001100000000000000000000
    for (k = 0; k<11 ;k=k+1 ) begin
    $display("-----------------------------------------------------");
    opcode = 6'b111111;
    register[0] = in1[k]; 
    register[1] = in2[k]; 

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
            // exponent[2] = $signed(exponent[0] + (~exponent[1]) + 1);
            if(exponent[0] > exponent[1]) begin
                exponent[2] = exponent[0] - exponent[1];
                register[addr_destination][30:23] = exponent[0];
                mantisa[1]=(mantisa[1]) >> exponent[2];
                $display("mantisa 1 = %b",mantisa[1]);
            end else begin
               exponent[2] = exponent[1] - exponent[0];
               register[addr_destination][30:23] = exponent[1];
               mantisa[0] = ( mantisa[0] ) >> exponent[2];
                $display("mantisa  = %b",mantisa[0]);
            end
            $display("mantisa0 = %b, mantisa1 = %b",mantisa[0],mantisa[1]);
            if((opcode[0] == 0 && !(sign[0] ^ sign[1])) 
                ||(opcode[0] == 1 && (sign[0] ^ sign[1]))) begin
                    mantisa_sum = mantisa[0] + mantisa[1];
                    if(mantisa_sum[24] == 0) begin
                        $display("cook");
                        register[addr_destination][22:0] = mantisa_sum[22:0];
                        register[addr_destination][31] = register[addr_reg_in1][31];     
                    end
                    else begin
                        $display("rook");
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
                    $display("d2,%b",d2);
                 mantisa_sum = d1 + (d2 + 1) ;
                 $display("mansum = %b",mantisa_sum);
                 if(mantisa_sum[24] == 1 && mantisa_sum[23:0] == 0)  begin
                     $display("looook");
                     register[addr_destination] = 0;
                 end
                 else begin
                    if(mantisa_sum[24] == 0) begin
                        $display("shoooook,mant = %b",mantisa_sum);
                        mantisa_sum[23:0] = ~mantisa_sum[23:0] + 1;
                        $display("mantisa_sum = %b",mantisa_sum);
                        register[addr_destination][31] = ~register[addr_destination][31];
                    end
                    for (i = 0; i<23 && mantisa_sum[23] != 1 ;i=i+1 ) begin
                         $display("mmook");
                        mantisa_sum[23:0] = mantisa_sum[23:0] << 1;
                        register[addr_destination][30:23] = register[addr_destination][30:23] - 1;
                    end
                     $display("dook");
                    register[addr_destination][22:0] = mantisa_sum[22:0];
                    if(mantisa[0] > mantisa[1])
                        register[addr_destination][31] = sign[0];
                    else
                        register[addr_destination][31] = opcode[0] == 0 ? sign[1]:~sign[1];
                 end
            end
        end
    end
    $display("input1: %b,input2= %b,output: %b",in1[k],in2[k], register[addr_destination]);
    end
end
    
endmodule