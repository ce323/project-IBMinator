module alu(input1w , input2w  , out , funcw , zero, clk);
	output reg zero;
	input[31:0] input1w , input2w ;
	reg [4:0] sh_amountw;
	input[5:0] funcw;
    	reg[5:0] func;// this wasnt declared
	output reg[31:0] out; // if out is needed
    input clk;
	reg [4:0] sh_amount;
	reg[31:0] input1 , input2;
	reg[5:0] xorr , sll , sllv , srl , sub , srlv , slt , suscall , subu , orr , norr , addu , mult , div , andd , jr , sra , I_Type_6_BEQ ,I_Type_7_BNE ,I_Type_8_BLEZ ,I_Type_9_BGTZ ,I_Type_10_BGEZ,I_Type_16_LUI;
	reg signed [31:0] hold1 , hold2;
    
	initial begin
		xorr = 6'b100110;
 		sll = 6'b000000;
 		sllv =6'b000100;
 		srl =6'b000010;
 		sub =6'b100010;
 		srlv =6'b000110;
 		slt =6'b101010;
		subu =6'b100011;
 		orr =6'b100101;
 		norr = 6'b100111;
 		addu =6'b100001;
		mult =6'b011000;
  		div =6'b011010;
  		andd =6'b100100;
 		sra = 6'b000011;
		I_Type_6_BEQ =6'b111000;
		I_Type_7_BNE =6'b111001;
		I_Type_8_BLEZ= 6'b111010;
		I_Type_9_BGTZ =6'b111011;
		I_Type_10_BGEZ= 6'b111100;
		I_Type_16_LUI =6'b111101;
	end

	always@(posedge clk/*input1 or input2 or func*/) begin


		input1 = input1w;
		input2 =  input2w ;
		sh_amount = sh_amountw;
		func = funcw;

		sh_amountw[4:0] = input2[10:6];


		hold1 = input1;
		hold2 = input2;
		case (func)
		xorr :
			out = input1 ^ input2;
 		sll :
			out = input2 << sh_amount ;
 		sllv :
			out = input2 << input1;
 		srl :
			out = input2 >> sh_amount;
 		sub :
			out = hold1 - hold2;
 		srlv:
			out = input2 >> input1;
 		slt :
			if(hold1<hold2)
            begin
                out = 1;
            end
			// else beginout = 0;  /// was this a typing error?
            else out=0;
		subu :
			out = input1 - input2;
 		orr :
			out = input1 | input2;
 		norr :
			out = ~(input1 | input2);
 		addu :
			out = input1 + input2;
		mult :
			out = hold1 * hold2;
  		div :
			out = hold1 / hold2;
  		andd :
			out = input1 & input2;
 		sra :
			out = input2 >>> sh_amount;
		I_Type_6_BEQ :begin
			if(input1 == input2)begin zero = 1;end end
		I_Type_7_BNE :begin
			if(input1 != input2)begin zero = 1;end
		end
		I_Type_8_BLEZ : begin
			if(input1 <= 0)begin
				zero = 1;
			end
		end
		I_Type_9_BGTZ: begin
			if(input1>0)begin
				zero = 1;
			end
		end
		I_Type_10_BGEZ: begin
			if($signed(input1)>=0)begin zero = 1; end
		end
		I_Type_16_LUI: begin
			out = {input2[15:0] , 16'b000000};
		end
	endcase
		if(out == 0)begin
			zero = 1;
		end
	else begin
	zero = 0;
	end
 	end


endmodule
