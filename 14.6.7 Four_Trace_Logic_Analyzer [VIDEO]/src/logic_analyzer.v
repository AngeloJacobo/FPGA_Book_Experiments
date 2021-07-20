`timescale 1ns / 1ps

module logic_analyzer
	(
	input clk,rst_n,
	input key,
	input[3:0] in_q,//4-trace square-wave inputs to be displayed on screen via VGA
	output[4:0] vga_out_r,
	output[5:0] vga_out_g,
	output[4:0] vga_out_b,
	output vga_out_vs,vga_out_hs,
	output reg[3:0] out_q //square-wave output test-signal (10kHz , 20kHz , 40kHz , 100kHz)
    );
	 
	 wire[11:0] pixel_x,pixel_y;
	 wire video_on;
	 wire[2:0] rgb;
	 wire clk_out;
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
	 
	full_screen_gen m1 //displays the four input square wave signals 
	(
		.clk(clk_out),
		.rst_n(rst_n),
		.key(key),
		.in(in_q),
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
		
	
	
	
	 //logic for free-running square test-signals 
	 reg[6:0] counter_100kHz=0; //mod_125 
	 reg[8:0] counter_40kHz=0; //mod_312
	 reg[9:0] counter_20kHz=0; //mod_625
	 reg[10:0] counter_10kHz=0; //mod_1250
	 
	 initial begin
		out_q=0;
	 end
	 
	 always @(posedge clk_out) begin
		counter_100kHz<=(counter_100kHz==124)? 0:counter_100kHz+1;
		counter_40kHz<=(counter_40kHz==311)? 0:counter_40kHz+1;
		counter_20kHz<=(counter_20kHz==624)? 0:counter_20kHz+1;
		counter_10kHz<=(counter_10kHz==1249)? 0:counter_10kHz+1;	 
		out_q[0] <= (counter_100kHz==0)? !out_q[0]:out_q[0]; //reverse the signal every restart of the free running counter to form a square
		out_q[1] <= (counter_40kHz==0)? !out_q[1]:out_q[1];
		out_q[2] <= (counter_20kHz==0)? !out_q[2]:out_q[2];
		out_q[3] <= (counter_10kHz==0)? !out_q[3]:out_q[3];
	 end
	 

endmodule

