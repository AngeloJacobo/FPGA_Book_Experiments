`timescale 1ns / 1ps

module heartbeat_TEST
	(
	input clk,rst_n,
	output[7:0] seg_out,
	output[5:0] sel_out
    );
	 wire [7:0] in0,in1,in2,in3,in4,in5;
	 
	 heartbeat #(.turns(6_000_000)) //0.120 sec per pattern = 0.720 sec per heartbeat
	 heartbeat_m0
		(
		.clk(clk),
		.rst_n(rst_n),
		.in0(in0),
		.in1(in1),
		.in2(in2),
		.in3(in3),
		.in4(in4),
		.in5(in5)
		 );
	 LED_mux led_mux_m0
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
