`timescale 1ns / 1ps

module dual_mode_disp
	(
	input clk,rst_n,
	input rx,
	input[3:0] key, //key[0] to move cursor to right,key[1] to move cursor down,key[2] to write @ current cursor,key[3] to change display mode
	output[4:0] vga_out_r,
	output[5:0] vga_out_g,
	output[4:0] vga_out_b,
	output vga_out_vs,vga_out_hs
    );
	 
	 wire[11:0] pixel_x,pixel_y;
	 wire video_on;
	 wire[2:0] rgb;
	 wire key3_tick;
	 reg mode_q=0;
	 wire[2:0] rgb_vertical,rgb_horizontal;
	
	 //alternates between horizontal and vertical mode
	 always @(posedge clk_out,negedge rst_n) begin 
		if(!rst_n) mode_q<=0;
		else mode_q<= key3_tick? !mode_q:mode_q;
	 end
	 
	 
	 assign rgb= mode_q? rgb_horizontal:rgb_vertical; //chooses which of the two modes will be displayed
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
	 
	mode_vertical m1 //vertical mode
	(
		.clk(clk_out),
		.rst_n(rst_n),
		.rx(rx),
		.key(key[2:0]), //key[0] to move cursor to right,key[1] to move cursor down,key[2] to write new ASCII character to current cursor
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.video_on(video_on),
		.rgb(rgb_vertical)
    );
	
	mode_horizontal m2  //horizontal mode
	(
		.clk(clk_out),
		.rst_n(rst_n),
		.rx(rx),
		.key(key[2:0]), //key[0] to move cursor to right,key[1] to move cursor down,key[2] to write new ASCII character to current cursor
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.video_on(video_on),
		.rgb(rgb_horizontal)
    );
	 
	 dcm_25MHz m3
		(// Clock in ports
		 .clk(clk),      // IN
		 // Clock out ports
		 .clk_out(clk_out),     // OUT
		 // Status and control signals
		 .RESET(RESET),// IN
		 .LOCKED(LOCKED)
	 );  
	 
	debounce_explicit m4
	(
		.clk(clk_out),
		.rst_n(rst_n),
		.sw(key[3]),
		.db_level(),
		.db_tick(key3_tick)
    );
	 
	
endmodule

