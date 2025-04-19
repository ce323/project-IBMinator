module alu(input1w , input2w  , out , funcw , zero, clk, rst_b, inst, cache_done);
	output reg zero;
	input[31:0] input1w , input2w ;
	reg [4:0] sh_amountw;
	input[5:0] funcw;
    	reg[5:0] func;
	output reg[31:0] out;
    input clk, rst_b;
	reg [4:0] sh_amount;
	reg[31:0] input1 , input2;
	reg signed [31:0] hold1 , hold2;
	input [31:0] inst;
	input cache_done;
    
	`define xorr 6'b100110
 	`define sll 6'b000000
 	`define sllv 6'b000100
 	`define srl 6'b000010
 	`define sub 6'b100010
 	`define srlv 6'b000110
 	`define slt 6'b101010
	`define subu 6'b100011
 	`define orr 6'b100101
 	`define norr 6'b100111
 	`define addiu 6'b100001
	`define add  6'b100000
	`define sws  6'b001011
	`define mult 6'b011000
  	`define div 6'b011010
  	`define andd 6'b100100
 	`define sra 6'b000011
	`define I_Type_6_BEQ 6'b111000
	`define I_Type_7_BNE 6'b111001
	`define I_Type_8_BLEZ 6'b111010
	`define I_Type_9_BGTZ 6'b111011
	`define I_Type_10_BGEZ 6'b111100
	`define I_Type_16_LUI 6'b111101
	

	always_latch @(*) begin
		zero = 0;

		input1 = input1w;
		input2 =  input2w ;
		func = funcw;

		sh_amountw[4:0] = inst[10:6];
		sh_amount = sh_amountw;


		hold1 = input1;
		hold2 = input2;

		case (func)
			`xorr :
				out = input1 ^ input2;
 			`sll :
				out = input2 << sh_amount;
 			`sllv :
				out = input2 << input1;
 			`srl :
				out = input2 >> sh_amount;
 			`sub :
				out = hold1 - hold2;
 			`srlv:
				out = input2 >> input1;
 			`slt :
				if(hold1 < hold2)
        	        out = 1;
        	    else
					out=0;
			`subu :
				out = input1 - input2;
 			`orr :
				out = input1 | {16'b0, input2[15:0]};
 			`norr :
				out = ~(input1 | input2);
			`add :
				out = $signed(input1) + $signed(input2);
			`sws:
				out = $signed(input1) + $signed(input2);
 			`addiu :
				out = input1 + {16'b0, input2[15:0]};
			`mult :
				out = hold1 * hold2;
  			`div :
				out = hold1 / hold2;
  			`andd :
				out = input1 & input2;
 			`sra :
				out = $signed(input2) >>> sh_amount;
			`I_Type_6_BEQ: begin
				if(input1 == input2)
					zero = 1;
				else
					zero = 0;
				end
			`I_Type_7_BNE: begin
				if(input1 != input2)
					zero = 1;
				else
					zero = 0;
			end
			`I_Type_8_BLEZ: begin
				if(input1 <= 0)
					zero = 1;
			end
			`I_Type_9_BGTZ: begin
				if(input1>0)
					zero = 1;
			end
			`I_Type_10_BGEZ: begin
				if($signed(input1)>=0)
					zero = 1;
			end
			`I_Type_16_LUI:
				out = {input2[15:0], 16'b0};
			default:
				begin
				end
		endcase
	end

endmodule
