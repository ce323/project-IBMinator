module controll (
	clk,
	inst,
	func,
	reg_dst,
	
	jump,
	branch,
	mem_write_en,
	
	mem_to_reg,
	alu_op,
	alu_src,
	reg_write,
	is_mem_inst,
	is_word,
	halted,
	reg_write_coprocessor,
	sw_coprocessor
);


input clk, inst;
output reg reg_dst, jump, branch, mem_write_en, mem_to_reg, alu_src, reg_write, is_mem_inst, is_word, halted;

wire [5:0] inst;
input  [5:0] func;
output reg [5:0] alu_op;
output reg reg_write_coprocessor, sw_coprocessor;

`define XOR_1 6'b100110
`define SLL_2 6'b000000
`define SLLV_3 6'b000100
`define SRL_4 6'b000010
`define SUB_5 6'b100010
`define SRLV_6 6'b000110
`define SLT_7 6'b101010
`define ANDI_8 6'b001100
`define SUBU_9 6'b100011
`define OR_10 6'b100101
`define NOR_11 6'b100101
`define ADDU_12 6'b100001
`define MULT_13 6'b011000
`define DIV_14 6'b011010
`define AND_15 6'b100100
`define ADD_16 6'b100000
`define SRA_17 6'b000011
`define I_Type_6_BEQ 6'b111000
`define I_Type_7_BNE 6'b111001
`define I_Type_8_BLEZ 6'b111010
`define I_Type_9_BGTZ 6'b111011
`define I_Type_10_BGEZ 6'b111100
`define I_Type_16_LUI 6'b111101
// coprocessor opcodes
`define add_coprocessor 6'b110000 //--> Done, Tested
`define sub_coprocessor 6'b110001 //--> Done, Tested
`define mul_coprocessor 6'b110010 //--> Done, Tested
`define div_coprocessor 6'b110011 //--> Done, Tested
`define cmp_coprocessor 6'b110100 //--> Done, Tested
`define rev_coprocessor 6'b110101 //--> Done, Tested
`define rnd_coprocessor 6'b110110 //--> Done, Tested
`define lw_coprocessor  6'b110111 //--> Done
`define sw_coprocessor_opcode  6'b001011 //--> Done



always_latch @(inst) begin
	case(inst)
		`add_coprocessor:
			begin
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;
				assign alu_op =`add_coprocessor; 	
			end
         
		`sub_coprocessor:
			begin
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;
				assign alu_op = `sub_coprocessor;
			end
		
		`mul_coprocessor:
			begin
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;	
				assign alu_op =`mul_coprocessor;

				assign reg_write = 0;
				assign reg_dst = 0;
				assign alu_src = 0;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;
			end
		`div_coprocessor:
			begin
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;
				assign alu_op =`div_coprocessor;

				assign reg_write = 0;
				assign reg_dst = 0;
				assign alu_src = 0;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;
			end
		`cmp_coprocessor:
			begin
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;	
				assign alu_op =`cmp_coprocessor;

				assign reg_write = 0;
				assign reg_dst = 0;
				assign alu_src = 0;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;
			end
		`rev_coprocessor:
			begin
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;
				assign alu_op =`rev_coprocessor;

				assign reg_write = 0;
				assign reg_dst = 0;
				assign alu_src = 0;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;
			end
		`rnd_coprocessor :
			begin
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0; 
				assign alu_op =`rnd_coprocessor;

				assign reg_write = 0;
				assign reg_dst = 0;
				assign alu_src = 0;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;
			end
		`lw_coprocessor : 
			begin
				assign reg_write_coprocessor = 1;
				assign sw_coprocessor = 0;
				//assign alu_op =`lw_coprocessor;
				assign alu_op = `ADD_16;
				assign reg_write = 0;
				assign reg_dst = 0;
				assign alu_src = 1;
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 1;
				assign is_word = 1;
			end
		`sw_coprocessor_opcode: 
			begin
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 1;
				assign alu_op =`sw_coprocessor_opcode;

				assign reg_write = 0;
				assign reg_dst = 1'bx;
				assign alu_src = 1;
				assign mem_to_reg = 1'bx;
				assign mem_write_en = 1;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 1;
				assign is_word = 1;
			end 

		`SLL_2:
			begin
				assign reg_write = 1;
				assign reg_dst = 1;
				assign alu_src = 0;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;
				if (func == `ANDI_8) begin
					assign halted = 1;
					assign reg_write = 0;
					assign reg_dst = 0;
					assign alu_src = 0;
					assign mem_to_reg = 0;
					assign mem_write_en = 0;
					assign jump = 0;
					assign branch = 0;
					assign is_mem_inst = 0;
					assign is_word = 0;
				end
				else
					assign halted = 0;
				
				assign alu_op = func;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;
			end


		
		`SRL_4:
			begin
				assign reg_write = 0;
				assign reg_dst = 0;
				assign alu_src = 0;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 1;
				assign branch = 0;
				assign halted = 0;
				assign alu_op = `ADD_16;
				assign is_mem_inst = 0;
				assign is_word = 0;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;
			end

		//J-Type (2): JAL
		`SRA_17:
			begin
				assign reg_write = 0;
				assign reg_dst = 0;
				assign alu_src = 0;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 1;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;

				assign alu_op = `ADD_16;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;
			end

		//I-Type instructions
//***********************************//
		//I-Type (1): ADDi
		6'b001000:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;

				assign alu_op = `ADD_16;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;



			end
//***********************************//
		//I-Type (2): ADDiu
		6'b001001:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;

				assign alu_op = `ADDU_12;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;


				assign mem_to_reg = 0;
			end
//***********************************//
		//I-Type (3): ANDi
		`ANDI_8:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;
				assign alu_op = `AND_15;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (4): XORi
		6'b001110:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;
				assign alu_op = `XOR_1;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (5): ORi
		6'b001101:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;

				assign alu_op = `OR_10;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (6): BEQ
		`SLLV_3:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				assign alu_src = 0;
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 1;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;

				assign alu_op = `I_Type_6_BEQ;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (7): BNE
		6'b000101:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				assign alu_src = 0;
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 1;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;

				assign alu_op = `I_Type_7_BNE;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (8): BLEZ
		`SRLV_6:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				assign alu_src = 0;
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 1;
				assign alu_op = `I_Type_8_BLEZ;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (9): BGTZ
		6'b000111:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				assign alu_src = 0;
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 1;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;

				assign alu_op = `I_Type_9_BGTZ;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (10): BGEZ
		6'b000001:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				assign alu_src = 0;
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 1;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;

				assign alu_op = `I_Type_10_BGEZ;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;



			end
//***********************************//
		//I-Type (11): LW
		`SUBU_9:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1;
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 1;
				assign is_word = 1;

				assign alu_op = `ADD_16;

				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;



			end
//***********************************//
		//I-Type (12): SW
		6'b101011:
			begin
				assign reg_write = 0;
				assign reg_dst = 1'bx;
				assign alu_src = 1;
				assign mem_to_reg = 1'bx;
				assign mem_write_en = 1;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 1;
				assign is_word = 1;

				assign alu_op = `ADD_16;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (13): LB
		`ADD_16:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1;
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 1;
				assign is_word = 0;

				assign alu_op = `ADD_16;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (14): SB
		6'b101000:
			begin
				assign reg_write = 0;
				assign reg_dst = 1'bx;
				assign alu_src = 1;
				assign mem_to_reg = 1'bx;
				assign mem_write_en = 1;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 1;
				assign is_word = 0;

				assign alu_op = `ADD_16;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (15): SLTi
		6'b001010:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;

				assign alu_op = `SLT_7;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;

			end	
//***********************************//
		//I-Type (16): Lui
		6'b001111:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				assign alu_src = 1;
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				assign jump = 0;
				assign branch = 0;
				assign halted = 0;
				assign is_mem_inst = 0;
				assign is_word = 0;

				assign alu_op = `I_Type_16_LUI;
				assign reg_write_coprocessor = 0;
				assign sw_coprocessor = 0;


			end	
//***********************************//
		default:
			begin
			end



	endcase

end
endmodule
