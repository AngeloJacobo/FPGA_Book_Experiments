`timescale 1ns / 1ps

module vga_mouse(
	input clk,rst_n,
	inout ps2c,ps2d,
	output reg[4:0] vga_out_r,
	output reg[5:0] vga_out_g,
	output reg[4:0] vga_out_b,
	output vga_out_vs,vga_out_hs
    );
	 localparam SIZE=16; //mouse pointer width and height
	 
	 wire[8:0] x,y;
	 wire[2:0] btn;
	 wire m_done_tick;
	 wire video_on;
	 wire mouse_on;
	 wire[11:0] pixel_x,pixel_y;
	 reg[9:0] mouse_x_q=0,mouse_x_d; //stores x-value(left part) of mouse, 
	 reg[9:0] mouse_y_q=0,mouse_y_d; //stores y-value(upper part) of mouse, 
	 reg[2:0] mouse_color_q=0,mouse_color_d; //stores current mouse color and can be changed by right/left click 
	 
	 //register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			mouse_x_q<=0;
			mouse_y_q<=0;
			mouse_color_q<=0;
		end
		else begin
			mouse_x_q<=mouse_x_d;
			mouse_y_q<=mouse_y_d;
			mouse_color_q<=mouse_color_d;
		end
	 end
	 
	 //logic for updating mouse location(by dragging the mouse) and mouse pointer color(by left/right click)
	 always @* begin
		mouse_x_d=mouse_x_q;
		mouse_y_d=mouse_y_q;
		mouse_color_d=mouse_color_q;
		if(m_done_tick) begin
			mouse_x_d=x[8]? mouse_x_q - 1 -{~{x[7:0]}} : mouse_x_q+x[7:0] ; //new x value of pointer
			mouse_y_d=y[8]? mouse_y_q + 1 +{~{y[7:0]}} : mouse_y_q-y[7:0] ; //new y value of pointer
			
			mouse_x_d=(mouse_x_d>640)? (x[8]? 640:0): mouse_x_d; //wraps around when reaches border
			mouse_y_d=(mouse_y_d>480)? (y[8]? 0:480): mouse_y_d; //wraps around when reaches border
			
			
			if(btn[1]) mouse_color_d=mouse_color_q+1;//right click to change color(increment)
			else if(btn[0]) mouse_color_d=mouse_color_q-1;//left click to change color(decrement)
		end
	 end
	 
	 assign mouse_on = (mouse_x_q<=pixel_x) && (pixel_x<=mouse_x_q+SIZE) && (mouse_y_q<=pixel_y) && (pixel_y<=mouse_y_q+SIZE);
	 
	 //display logic
	 always @* begin
				vga_out_r=0;
				vga_out_g=0;
				vga_out_b=0;
		if(video_on) begin
			if(mouse_on) begin //mouse color
				vga_out_r={5{mouse_color_q[0]}};
				vga_out_g={6{mouse_color_q[1]}};
				vga_out_b={5{mouse_color_q[2]}};
			end
			else begin //background color
				vga_out_g=6'b111_111;
				vga_out_b=5'b111_11;
			end
		end
	 end
	 

	 
	 //module instantiations
	 
	 dcm_25MHz m0
   (// Clock in ports
    .clk(clk),      // IN
    // Clock out ports
    .clk_out(clk_out),     // OUT
    // Status and control signals
    .RESET(RESET),// IN
    .LOCKED(LOCKED));      // OUT
	 
	 
	 mouse m1
	(
		.clk(clk),
		.rst_n(rst_n),
		.ps2c(ps2c),
		.ps2d(ps2d),
		.x(x),
		.y(y),
		.btn(btn),
		.m_done_tick(m_done_tick)
    );
	 
	vga_core m2 //clock must be 25MHz for 640x480 
	(
		.clk(clk_out),
		.rst_n(rst_n), 
		.hsync(vga_out_hs),
		.vsync(vga_out_vs),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y)
    );	
	 


endmodule
