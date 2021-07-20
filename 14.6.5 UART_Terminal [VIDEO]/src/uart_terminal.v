`timescale 1ns / 1ps

module uart_teminal
	(
	input clk,rst_n,
	input rx, //ascii characters will come from pc serial port via UART
	output[4:0] vga_out_r,
	output[5:0] vga_out_g,
	output[4:0] vga_out_b,
	output vga_out_vs,vga_out_hs
    );
	 
	 wire[11:0] pixel_x,pixel_y;
	 wire video_on;
	 wire[2:0] rgb;
	 
	 
	 assign vga_out_r=rgb[2]? 5'b111_11:0 ;
	 assign vga_out_g=rgb[1]? 6'b111_111:0 ;
	 assign vga_out_b=rgb[0]? 5'b111_11:0 ;
	 

	 vga_core m0
	(
		.clk(clk_out),  //clock must be 25MHz for 640x480 
		.rst_n(rst_n),
		.hsync(vga_out_hs),
		.vsync(vga_out_vs),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y)
    );	
	 
	full_screen_gen m1 //generates the characters to be displayed on screen, the ASCII characters will come from pc serial port via UART
	(
		.clk(clk_out),
		.rst_n(rst_n),
		.rx(rx),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.video_on(video_on),
		.rgb(rgb)
    );
	
	 dcm_25MHz m2
		(// Clock in ports
		 .clk(clk),      // IN
		 // Clock out ports
		 .clk_out(clk_out),     // OUT
		 // Status and control signals
		 .RESET(RESET),// IN
		 .LOCKED(LOCKED)
	 );      
	
endmodule

