`timescale 1ns / 1ps

module top_module(
	input clk,rst_n,
	input go,
	output[7:0] seg_out,
	output[5:0] sel_out	
    );
	 wire[3:0] ms0,s0,s1;
	 
	alt_bcd_counter m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.go(go),
		.s1(s1),
		.s0(s0),
		.ms0(ms0)
    );
	 LED_mux m1
	 (
		.clk(clk),
		.rst(rst_n),
		.in0({1'b0,ms0}),
		.in1({1'b1,s0}),
		.in2({1'b0,s1}),
		.in3(0),
		.in4(0),
		.in5(0), //format: {dp,hex[3:0]}
		.seg_out(seg_out),
		.sel_out(sel_out)
    );


endmodule
