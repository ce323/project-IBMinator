module controll (
	clk,
	inst,
	func,
	reg_dst,
	
	jump,
	branch,
	// mem_read,
	mem_write_en,
	
	mem_to_reg,
	alu_op,
	alu_src,
	reg_write, 
	halted
);


input clk, inst;
output reg reg_dst, jump, branch, mem_write_en, mem_to_reg, alu_src, reg_write, halted;
// output mem_read;

wire [5:0] inst;
input  [5:0] func;
output reg [5:0] alu_op;

`define XOR_1 6'b100110
`define SLL_2 6'b000000
`define SLLV_3 6'b000100
`define SRL_4 6'b000010
`define SUB_5 6'b100010
`define SRLV_6 6'b000110
`define SLT_7 6'b101010
`define Syscall_8 6'b001100
`define SUBU_9 6'b100011
`define OR_10 6'b100101
`define NOR_11 6'b100101
`define ADDU_12 6'b100001
`define MULT_13 6'b011000
`define DIV_14 6'b011010
`define AND_15 6'b100100
`define ADD_16 6'b100000
`define I_Type_6_BEQ 6'b111000
`define I_Type_7_BNE 6'b111001
`define I_Type_8_BLEZ 6'b111010
`define I_Type_9_BGTZ 6'b111011
`define I_Type_10_BGEZ 6'b111100
`define I_Type_16_LUI 6'b111101



always @(posedge clk) begin
	case(inst)
		6'b000000:
			begin
				assign reg_write = 1;
				assign reg_dst = 1;
				assign alu_src = 0; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;
				if (func == `Syscall_8) 
					assign halted = 1;
				else
					assign halted = 0;	

				assign alu_op = func;

			end


		
		6'b000010:
			begin
				assign reg_write = 0;
				assign reg_dst = 0;
				assign alu_src = 0; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 1;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `ADD_16;

			end

		//J-Type (2): JAL
		6'b000011:
			begin
				assign reg_write = 0;
				assign reg_dst = 0;
				assign alu_src = 0; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 1;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `ADD_16;
			end

		//I-Type instructions
//***********************************//
		//I-Type (1): ADDi
		6'b001000:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `ADD_16;



			end
//***********************************//
		//I-Type (2): ADDiu
		6'b001001:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1; // sign exte
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `ADDU_12;


				assign mem_to_reg = 0;
			end
//***********************************//
		//I-Type (3): ANDi
		6'b001100:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `AND_15;

			end	
//***********************************//
		//I-Type (4): XORi
		6'b001110:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `XOR_1;

			end	
//***********************************//
		//I-Type (5): ORi
		6'b001101:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `OR_10;

			end	
//***********************************//
		//I-Type (6): BEQ
		6'b000100:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				assign alu_src = 0; // sign extend
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 1;//??
				assign halted = 0;


				assign alu_op = `I_Type_6_BEQ;

			end	
//***********************************//
		//I-Type (7): BNE
		6'b000101:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				assign alu_src = 0; // sign extend
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 1;//??
				assign halted = 0;

				assign alu_op = `I_Type_7_BNE;

			end	
//***********************************//
		//I-Type (8): BLEZ
		6'b000110:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				assign alu_src = 0; // sign extend
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 1;//??
				assign alu_op = `I_Type_8_BLEZ;
				assign halted = 0;

			end	
//***********************************//
		//I-Type (9): BGTZ
		6'b000111:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				assign alu_src = 0; // sign extend
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 1;//??
				assign halted = 0;

				assign alu_op = `I_Type_9_BGTZ;

			end	
//***********************************//
		//I-Type (10): BGEZ
		6'b000001:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				assign alu_src = 0; // sign extend
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 1;//??
				assign halted = 0;

				assign alu_op = `I_Type_10_BGEZ;



			end
//***********************************//
		//I-Type (11): LW
		6'b100011:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1; // sign extend
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				//assign mem_read = 1;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `ADD_16;



			end
//***********************************//
		//I-Type (12): SW
		6'b101011:
			begin
				assign reg_write = 0;
				assign reg_dst = 1'bx;
				assign alu_src = 1; // sign extend
				assign mem_to_reg = 1'bx;
				assign mem_write_en = 1;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `ADD_16;

			end	
//***********************************//
		//I-Type (13): LB
		6'b100000:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1; // sign extend
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				//assign mem_read = 1;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `ADD_16;

			end	
//***********************************//
		//I-Type (14): SB
		6'b101000:
			begin
				assign reg_write = 0;
				assign reg_dst = 1'bx;
				assign alu_src = 1; // sign extend
				assign mem_to_reg = 1'bx;
				assign mem_write_en = 1;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `ADD_16;

			end	
//***********************************//
		//I-Type (15): SLTi
		6'b001010:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `SLT_7;

			end	
//***********************************//
		//I-Type (16): Lui
		6'b001111:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;

				assign alu_op = `I_Type_16_LUI;


			end	
//***********************************//
		default:
			begin
			end



endcase
end
endmodule
