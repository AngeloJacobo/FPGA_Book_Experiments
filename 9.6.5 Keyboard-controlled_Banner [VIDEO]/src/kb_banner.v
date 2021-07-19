`timescale 1ns / 1ps

module kb_banner(
	input clk,rst_n,
	input ps2d,ps2c,
	output[7:0] seg_out,
	output[5:0] sel_out
    );
	 
	wire[4:0] in0,in1,in2,in3,in4,in5;
	
	rotating_LED m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.in0(in0),
		.in1(in1),
		.in2(in2),
		.in3(in3),
		.in4(in4),
		.in5(in5) //{decimalpoint,hexadecimal}
    );
	 
	LED_mux m1
	(
		.clk(clk),
		.rst(rst_n),
		.in0({1'b0,in0}),
		.in1({1'b0,in1}),
		.in2({1'b0,in2}),
		.in3({1'b0,in3}),
		.in4({1'b0,in4}),
		.in5({1'b0,in5}),
		.seg_out(seg_out),
		.sel_out(sel_out)
    );


endmodule
