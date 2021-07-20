`timescale 1ns / 1ps

module top_module(
	input clk,rst_n,
	input key,
	output vga_out_vs,vga_out_hs,
	output[4:0] vga_out_r,
	output[5:0] vga_out_g,
	output[4:0] vga_out_b	
    );
	 
	wire video_on;
	wire[11:0] pixel_x,pixel_y;
	
	//module instantiations
	clk_25MHz m0
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
		.clk(clk_out),
		.rst_n(rst_n), //clock must be 25MHz for 640x480 
		.hsync(vga_out_hs),
		.vsync(vga_out_vs),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y)
    );
	 
	 vga_test_pattern m2 //generates horizontal or vertical strip pattern
	 (								//depending if key is pressed or not
		.key(key),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.r(vga_out_r),
		.g(vga_out_g),
		.b(vga_out_b)
    ); 


endmodule
