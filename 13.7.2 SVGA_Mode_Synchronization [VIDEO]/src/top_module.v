`timescale 1ns / 1ps

module top_module(
	input clk,rst_n,
	input key, //swicthes between VGA(640x480) and SVGA(800x600) modes
	output reg vga_out_vs,vga_out_hs,
	output[4:0] vga_out_r,
	output[5:0] vga_out_g,
	output[4:0] vga_out_b
    );
	 
	 wire key_tick;
	 reg video_on;
	 reg[11:0] pixel_x,pixel_y;
	 
	 wire a_hsynx,a_vsync,a_video_on;
	 wire[11:0] a_pixel_x,a_pixel_y;
	 wire b_hsynx,b_vsync,b_video_on;
	 wire[11:0] b_pixel_x,b_pixel_y;
	 
	 reg vga_q=0; //switch between VGA and SVGA
	 
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) vga_q<=0;
		else if(key_tick) vga_q<=!vga_q;
	 end
	 
	 //logic for alternating the output resolution
	 always @* begin
		if(vga_q) begin
			vga_out_vs=a_vsync;
			vga_out_hs=a_hsync;
			video_on=a_video_on;
			pixel_x=a_pixel_x;
			pixel_y=a_pixel_y;
		end
		else begin
			vga_out_vs=b_vsync;
			vga_out_hs=b_hsync;
			video_on=b_video_on;
			pixel_x=b_pixel_x;
			pixel_y=b_pixel_y;
		end
	 end


	 clk_25MHz m0
   (// Clock in ports
		 .clk(clk),      // IN
		 // Clock out ports
		 .clk_out(clk_out),     // OUT
		 // Status and control signals
		 .RESET(RESET),// IN
		 .LOCKED(LOCKED)
	 ); 
	 
	 vga_core_640x480 m1
	 (
		.clk(clk_out), //clock must be 25MHz for 640x480 
		.rst_n(rst_n), 
		.hsync(a_hsync),
		.vsync(a_vsync),
		.video_on(a_video_on),
		.pixel_x(a_pixel_x),
		.pixel_y(a_pixel_y)
    );	
	 
	  vga_core_800x600 m2
	 (
		.clk(clk),
		.rst_n(rst_n), //clock must be 50MHz for 640x480 
		.hsync(b_hsync),
		.vsync(b_vsync),
		.video_on(b_video_on),
		.pixel_x(b_pixel_x),
		.pixel_y(b_pixel_y)
    );
	 
	debounce_explicit m3
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(key),
		.db_level(),
		.db_tick(key_tick)
    );
	 
	 grid_pixel m4 //generates 100x100 grid pixel pattern
	(
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.r(vga_out_r),
		.g(vga_out_g),
		.b(vga_out_b)
	);
endmodule


