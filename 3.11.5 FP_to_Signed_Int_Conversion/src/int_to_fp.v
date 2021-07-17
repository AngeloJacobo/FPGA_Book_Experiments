`timescale 1ns / 1ps

module int_to_fp(
	input wire[7:0] integ,
	output reg[12:0] fp	
    );
	 integer i; 
	 reg finish;
	 
	 always @(integ) begin
	 fp=13'b0;
	 i=0;
	 finish=1'b0;
	 fp[12]=integ[7];  //sign bit of fp is same with integ
	 for(i=6;i>=0;i=i-1)   //find loc of first bit 1 in the integ
		 if(integ[i]==1'b1 && finish==1'b0) begin
		 	fp[7:0] = {1'b0,integ[6:0]}<<(7-i); //8 bit frac value of fp must be normalized so the first bit "1"(excluding the signed bit) of integ must moved to 8th bit
			fp[11:8] = i+1;   // 4 bit exp value e.g. integ 0000_1111(i=3) willl become fp frac of .1111_0000 when normalized so an exp must be 3+1=4
			finish=1'b1;
		 end
	 end
	 


endmodule
