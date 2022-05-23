module controll(
	clk,
	inst,
	func,
	reg_dst,
	
	jump,
	branch,
	mem_read,
	mem_write_en,
	
	mem_to_reg,
	alu_op,
	alu_src,
	reg_write
);

//اینجا ورودی ها و خروجی ها تعیین شده اند

input clk, inst, func;
output reg_dst, jump, branch, mem_read, mem_write_en, mem_to_reg, alu_op, alu_src, reg_write;

//اینجا پهنای دو ورودی که یک بیتی نیستند تعیین شده است
wire [5:0] inst;
wire [5:0] func;
wire [5:0] alu_op;


//این بخش از کد برای سادگی در نوشتن ادامۀ دستورات نوشته شده
// دستورات اینجا به صورت دایرکتیو خلاصه سازی شده اند که به خوانایی کد کمک میکند
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



//اینجا حالت بندی بر روی آپکد انجام شده که بر اساس اینکه آپکد چیست، به ماژول های دیگر دستور داده می شود
always @(*) begin
	case(inst)
		//R-Type instructions دستورات آر تایپ
		//This part of the code is written for handling R-Format instructions
		6'b000000:
			begin
				assign reg_write = 1;
				assign reg_dst = 1;
				asign alu_src = 0; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;

				assign alu_op = func;

			end


		//J-Type instructions دستورات جی تایپ
		//This part of the code is written for handling J-Format instructions
		
		//J-Type (1): j
		6'b000010:
			begin
				

			end

		//J-Type (2): JAL
		6'b000011:
			begin

			end

		//I-Type instructions دستورات آی تایپ
//***********************************//
		//I-Type (1): ADDi
		6'b001000:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				asign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;

				assign alu_op = `ADD_16;



			end
//***********************************//
		//I-Type (2): ADDiu
		6'b001001:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				asign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;

				assign alu_op = `ADDU_12;



			end
//***********************************//
		//I-Type (3): ANDi
		6'b001100:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				asign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;

				assign alu_op = `AND_15;

			end	
//***********************************//
		//I-Type (4): XORi
		6'b001110:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				asign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;

				assign alu_op = `XOR_1;

			end	
//***********************************//
		//I-Type (5): ORi
		6'b001101:
			begin
				assign reg_write = 1;
				assign reg_dst = 0;
				asign alu_src = 1; // sign extend
				assign mem_to_reg = 0;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;

				assign alu_op = `OR_10;

			end	
//***********************************//
		//I-Type (6): BEQ
		6'b000100:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				asign alu_src = 0; // sign extend
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;

				assign alu_op = `SUB_5;

			end	
//***********************************//
		//I-Type (7): BNE
		6'b000101:
			begin
				assign reg_write = 0;
				assign reg_dst = 1;
				asign alu_src = 0; // sign extend
				assign mem_to_reg = 1;
				assign mem_write_en = 0;
				//assign mem_read = 0;
				assign jump = 0;
				assign branch = 0;

				assign alu_op = `SUB_5;

			end	
//***********************************//
		//I-Type (8): BLEZ
		6'b000110:
			begin


			end	
//***********************************//
		//I-Type (9): BGTZ
		6'b000111:
			begin


			end	
//***********************************//
		//I-Type (10): BGEZ
		6'b000001:
			begin




			end
//***********************************//
		//I-Type (11): LW
		6'b100011:
			begin




			end
//***********************************//
		//I-Type (12): SW
		6'b101011:
			begin


			end	
//***********************************//
		//I-Type (13): LB
		6'b100000:
			begin


			end	
//***********************************//
		//I-Type (14): SB
		6'b101000:
			begin


			end	
//***********************************//
		//I-Type (15): SLTi
		6'b001010:
			begin


			end	
//***********************************//
		//I-Type (16): Lui
		6'b001111:
			begin


			end	
//***********************************//






endcase
end

endmodule;