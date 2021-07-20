`timescale 1ns / 1ps

module vga_test(
	input clk, rst_n,
	input[2:0] key, //key[0] for selecting vertical or horizontal mode adjustment. key[2:1] to move the screen up/down(if vertical mode) or left/right(if horizontal mode)
	output reg[4:0] vga_out_r,
	output reg[5:0] vga_out_g,
	output reg[4:0] vga_out_b,
	output vga_out_vs,vga_out_hs
    );
	 
	
	wire clk_out;
	wire video_on;
	
		//display logic
		always @* begin
			vga_out_r=0;
			vga_out_g=0;
			vga_out_b=0;
			if(video_on) begin
				vga_out_g=6'b111_111; //display screen color is green
			end
		end
		
		dcm_25MHz m0
   (// Clock in ports
		 .clk(clk),      // IN
		 // Clock out ports
		 .clk_out(clk_out),     // OUT
		 // Status and control signals
		 .RESET(RESET),// IN
		 .LOCKED(LOCKED)
	 );
	 
	vga_core m1 //VGA controller(640x480) with adjustable screen position
	(
		.clk(clk_out),  //clock must be 25MHz for 640x480 
		.rst_n(rst_n),
		.key(key),
		.hsync(vga_out_hs),
		.vsync(vga_out_vs),
		.video_on(video_on),
		.pixel_x(),
		.pixel_y()
    );


endmodule
