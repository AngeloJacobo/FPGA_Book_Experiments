`timescale 1ns / 1ps

module rotate_sq_TEST(
	input clk,rst_n,
	input cw,en,
	output [7:0] seg_out,
	output [5:0] sel_out
    );
	 wire[7:0] in0,in1,in2,in3,in4,in5;
	 
	 rotate_sq rot_sq(
	 .clk(clk),
	 .rst_n(rst_n),
	 .cw(cw),
	 .en(en),
	 .in0(in0),
	 .in1(in1),
	 .in2(in2),
	 .in3(in3),
	 .in4(in4),
	 .in5(in5) 
    );
	 LED_mux led_mux(
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
