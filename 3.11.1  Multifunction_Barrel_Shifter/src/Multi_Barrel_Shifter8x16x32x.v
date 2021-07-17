`timescale 1ns / 1ps

module Multi_Barrel_Shifter8x16x32x    //adjust param M and N for 8,16,or 32 bits
#( parameter N=32,
   parameter M=5)
	(  input wire[N-1:0] num,
		input wire[M-1:0] amt,
		input wire LR,
		output wire[N-1:0] out	
		 );
		 generate 
			if(N==8) barrel_shifter_8 m0(num,amt,LR,out);
			else if(N==16) barrel_shifter_16 m1(num,amt,LR,out);
			else if(N==32) barrel_shifter_32 m2(num,amt,LR,out);			
		 endgenerate

endmodule
