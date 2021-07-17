`timescale 1ns / 1ps

module barrel_shifter_16(
		input wire[15:0] num,
		input wire[3:0] amt,
		input wire LR,
		output wire[15:0] real_out);
		wire[15:0] out_1,out_2;
		Rotate_R16 m0(num,amt,out_1);
		Rotate_L16 m1(num,amt,out_2);
		assign real_out=LR?out_2:out_1;  //MUX for left or right 16-bit shifter
endmodule


module Rotate_R16(
	input wire[15:0] num, 
	input wire[3:0] amt,
	output wire[15:0] out
    );
	 wire[15:0] s0,s1,s2,s3;
	 assign s0=amt[0]?{num[0],num[15:1]}:num; //1 move
	 assign s1=amt[1]?{s0[1:0],s0[15:2]}:s0;   //2 moves
	 assign s2=amt[2]?{s1[3:0],s1[15:4]}:s1;   //4 moves
	 assign s3=amt[3]?{s2[7:0],s2[15:8]}:s2;   //8 moves
	 assign out=s3;
	 
endmodule

module Rotate_L16(
	input wire[15:0] num, 
	input wire[3:0] amt,
	output wire[15:0] out
    );
	 wire[15:0] s0,s1,s2,s3;
	 assign s0=amt[0]?{num[14:0],num[15]}:num; //1 move
	 assign s1=amt[1]?{s0[13:0],s0[15:14]}:s0;  //2 moves
	 assign s2=amt[2]?{s1[11:0],s1[15:12]}:s1;  //4 moves
	 assign s3=amt[3]?{s2[7:0],s2[15:8]}:s2;  //8 moves
	 assign out=s3;

endmodule