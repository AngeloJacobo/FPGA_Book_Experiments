`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:04:40 02/27/2021 
// Design Name: 
// Module Name:    ehn_stopwatch_TEST 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ehn_stopwatch_TEST(
	input clk,rst_n,
	input up,go,
	output[7:0] seg_out,
	output[5:0] sel_out
    );
	 wire [4:0] in0,in1,in2,in3,in4,in5;
	 
	 Enhanced_Stopwatch ehn_stopwatch(   
	.clk(clk),
	.rst_n(rst_n),
	.up(up),
	.go(go), 
	.in0(in0),
	.in1(in1),
	.in2(in2),
	.in3(in3),
	.in4(in4),
	.in5(in5)
    );
	 
	 LED_mux led_mux
		(
		.clk(clk),
		.rst(rst_n),
		.in0(in0),
		.in1(in1),
		.in2(in2),
		.in3(in3),
		.in4(in4),
		.in5(in5),
		.seg_out(seg_out),
		.sel_out(sel_out)
		 );



endmodule
