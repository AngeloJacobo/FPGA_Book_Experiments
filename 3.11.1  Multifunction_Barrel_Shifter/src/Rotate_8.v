`timescale 1ns / 1ps

module barrel_shifter_8(  
		input wire[7:0] num,
		input wire[2:0] amt,
		input wire LR,
		output wire[7:0] real_out);
		wire[7:0] out_1,out_2;
		Rotate_R8 m0(num,amt,out_1);
		Rotate_L8 m1(num,amt,out_2);
		assign real_out=LR?out_2:out_1;   //MUX for left or right 8-bit shifter
endmodule	 

module Rotate_R8(
	input wire[7:0] num, 
	input wire[2:0] amt,
	output wire[7:0] out
    );
	 wire[7:0] s0,s1,s2;
	 assign s0=amt[0]?{num[0],num[7:1]}:num; //1 move
	 assign s1=amt[1]?{s0[1:0],s0[7:2]}:s0;  //2 moves
	 assign s2=amt[2]?{s1[3:0],s1[7:4]}:s1;  //4 moves
	 assign out=s2;
endmodule

module Rotate_L8(
	input wire[7:0] num, 
	input wire[2:0] amt,
	output wire[7:0] out
    );
	 wire[7:0] s0,s1,s2;
	 assign s0=amt[0]?{num[6:0],num[7]}:num; //1 move
	 assign s1=amt[1]?{s0[5:0],s0[7:6]}:s0;  //2 moves
	 assign s2=amt[2]?{s1[3:0],s1[7:4]}:s1;  //4 moves
	 assign out=s2;
endmodule






