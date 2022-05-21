module controll(clk,inst,func,reg_dst,
jump,branch,mem_read,mem_write_en,
mem_to_reg,alu_op,alu_src,reg_write);

//اینجا ورودی ها و خروجی ها تعیین شده اند

input clk;
input inst;
input func;
output reg_dst;
output jump;
output branch;
output mem_read;
output mem_write_en;
output mem_to_reg;
output alu_op;
output alu_src;
output reg_write;

//اینجا پهنای دو ورودی که یک بیتی نیستند تعیین شده است
wire [5:0] inst;
wire [5:0] func;


//این بخش از کد برای سادگی در نوشتن ادامۀ دستورات نوشته شده
// دستورات اینجا به صورت دایرکتیو خلاصه سازی شده اند که به خوانایی کد کمک میکند
//`define  


//اینجا حالت بندی بر روی آپکد انجام شده که بر اساس اینکه آپکد چیست، به ماژول های دیگر دستور داده می شود
case(inst)
	begin
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
		6'001001:
			begin




			end
//***********************************//
		//I-Type (3): ANDi
		6'001100:
			begin


			end	
//***********************************//
		//I-Type (4): XORi
		6'001110:
			begin


			end	
//***********************************//
		//I-Type (5): ORi
		6'001101:
			begin


			end	
//***********************************//
		//I-Type (6): BEQ
		6'000100:
			begin


			end	
//***********************************//
		//I-Type (7): BNE
		6'000101:
			begin


			end	
//***********************************//
		//I-Type (8): BLEZ
		6'000110:
			begin


			end	
//***********************************//
		//I-Type (9): BGTZ
		6'000111:
			begin


			end	
//***********************************//
		//I-Type (10): BGEZ
		6'000001:
			begin




			end
//***********************************//
		//I-Type (11): LW
		6'100011:
			begin




			end
//***********************************//
		//I-Type (12): SW
		6'101011:
			begin


			end	
//***********************************//
		//I-Type (13): LB
		6'100000:
			begin


			end	
//***********************************//
		//I-Type (14): SB
		6'101000:
			begin


			end	
//***********************************//
		//I-Type (15): SLTi
		6'001010:
			begin


			end	
//***********************************//
		//I-Type (16): Lui
		6'001111:
			begin


			end	
//***********************************//






	end

endmodule;