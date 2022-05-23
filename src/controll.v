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


//این بخش از کد برای سادگی در نوشتن ادامۀ دستورات نوشته شده
// دستورات اینجا به صورت دایرکتیو خلاصه سازی شده اند که به خوانایی کد کمک میکند
//`define  


//اینجا حالت بندی بر روی آپکد انجام شده که بر اساس اینکه آپکد چیست، به ماژول های دیگر دستور داده می شود
always @(*) begin
	case(inst)
		//R-Type instructions دستورات آر تایپ
		//This part of the code is written for handling R-Format instructions
		6'b000000:
			begin




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




			end
//***********************************//
		//I-Type (2): ADDiu
		6'b001001:
			begin




			end
//***********************************//
		//I-Type (3): ANDi
		6'b001100:
			begin


			end	
//***********************************//
		//I-Type (4): XORi
		6'b001110:
			begin


			end	
//***********************************//
		//I-Type (5): ORi
		6'b001101:
			begin


			end	
//***********************************//
		//I-Type (6): BEQ
		6'b000100:
			begin


			end	
//***********************************//
		//I-Type (7): BNE
		6'b000101:
			begin


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