`timescale 1ns / 1ps

module fp_to_int(
	input wire[12:0] fp,
	output reg[7:0] integ,
	output reg over,under
    );
	 reg[3:0] exp;
	 reg[7:0] frac;
	 always@(fp) begin
		 integ=8'b0;
		 over=1'b0;
		 under=1'b0;
		 frac=fp[7:0];
		 exp=fp[11:8];
		 
		 integ[7]=fp[12];   //sign bit of fp is same with int
		 
		 if(exp>7 && frac[7]) begin //overflow
			integ[6:0]=7'b111_1111;  
			over=1'b1;
		 end
		 else if(exp==0 && frac[7]) begin //underflow
			integ[6:0]=7'b000_0000;
			under=1'b1;
		 end
		 else if(exp<=7 && frac[7]) begin
			integ[6:0]=frac>>(8-exp);
		 end
	 end
	 
endmodule
