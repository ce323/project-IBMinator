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

    always@(posedge clk) begin

    if (opcode[5:1] == 6'b11000) begin
        mantisa[0] = registers[addr_reg_in1][22:0]; // store the mantisa and exponent of each operand
        mantisa[1] = registers[addr_reg_in2][22:0];
        exponent[0] = registers[addr_reg_in1][30:23]; // store the mantisa and exponent of each operand
        exponent[1] = registers[addr_reg_in2][30:23];
        exponent[2] = exponent[0] - exponent[1];
        if(exponent[2]>0) begin
            register[addr_destination][30:23] = exponent[0];
            for ( i = 0;i<exponent[2] ;i=i+1 ) begin
                mantisa[1] >> 1;
            end
        end else begin
            register[addr_destination][30:23] = exponent[1];
            for ( i = 0;i<-exponent[2] ;i=i+1 ) begin
                mantisa[0] >> 1;
            end
        end
        mantisa[0] = registers[addr_reg_in1][31] == 0 ? mantisa[0] : ~ mantisa[0] + 1;
        mantisa[1] = registers[addr_reg_in2][31] == 0 ? mantisa[1] : ~ mantisa[1] + 1;
        if(opcode[0] == 0)
            register[addr_destination][22:0] = mantisa[0] + mantisa[1];
        else
            register[addr_destination][22:0] = mantisa[0] + (~mantisa[1])+ 1;
        register[addr_destination][31] = $signed(register[addr_destination][22:0]) < 0 ? 1 : 0;
    end else if(opcode)
    
    end


endmodule