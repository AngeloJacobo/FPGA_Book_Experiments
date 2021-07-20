`timescale 1ns / 1ps

module top_module
	(
		input clk, rst_n,
		input[1:0] key, //key[1] is for changing  ball speed, key[0] for changing location of ball(randomly)
		output[4:0] vga_out_r,
		output[5:0] vga_out_g,
		output[4:0] vga_out_b,
		output vga_out_vs,vga_out_hs
    );
	 
	wire clk_out;
	wire video_on;
	wire[11:0] pixel_x,pixel_y;
	
	dcm_25MHz m0
   (// Clock in ports
		 .clk(clk),      // IN
		 // Clock out ports
		 .clk_out(clk_out),     // OUT
		 // Status and control signals
		 .RESET(RESET),// IN
		 .LOCKED(LOCKED)
	 );
	 vga_core m1
	(
		.clk(clk_out), //clock must be 25MHz for 640x480 resolution
		.rst_n(rst_n), 
		.hsync(vga_out_hs),
		.vsync(vga_out_vs),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y)
    );
	 
	 ball_in_a_box m2 //logic for self-bouncing ball
	 (
		.clk(clk_out),
		.rst_n(rst_n),
		.key(key),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.r(vga_out_r),
		.g(vga_out_g),
		.b(vga_out_b)
    );	
	 
	 
	 
endmodule 
