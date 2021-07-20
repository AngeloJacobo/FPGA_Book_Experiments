`timescale 1ns / 1ps

module vga_mouse(
	input clk,rst_n,
	input[2:0] key,
	inout ps2c,ps2d,
	output reg[4:0] vga_out_r,
	output reg[5:0] vga_out_g,
	output reg[4:0] vga_out_b,
	output vga_out_vs,vga_out_hs
    );
					//screen boundary for 256x256 resolution at the center of screen
	localparam  MAX_X=447,
					MIN_X=192,
					MIN_Y=112,
					MAX_Y=367,
					SIZE=255; //screen box size
	 
	 wire[8:0] x,y;
	 wire[2:0] btn;
	 wire m_done_tick;
	 wire video_on;
	 wire mouse_on;
	 wire[11:0] pixel_x,pixel_y;
	 reg[7:0] mouse_x_q=0,mouse_x_d; //stores x-value(left part) of mouse, 
	 reg[7:0] mouse_y_q=0,mouse_y_d; //stores y-value(upper part) of mouse, 
	 reg we;
	 reg[15:0] wr_addr,rd_addr;
	 wire[15:0] addr;
	 wire[2:0] dout;
	 reg mouse_L_q=0,mouse_L_d; //left click turns on/off the trace movement
	 reg mouse_R_q=0, mouse_R_d; //right click clears the screen of all traces
	 reg[15:0] counter_q=0,counter_d;
	 wire[2:0] din;
	 
	 //register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			mouse_x_q<=0;
			mouse_y_q<=0;
			mouse_L_q<=0;
			mouse_R_q<=0;
			counter_q<=0;
		end
		else begin
			mouse_x_q<=mouse_x_d;
			mouse_y_q<=mouse_y_d;
			mouse_L_q<=mouse_L_d;
			mouse_R_q<=mouse_R_d;
			counter_q<=counter_d;
		end
	 end
	 
	 //logic for updating mouse location(by dragging the mouse) and mouse pointer color(by left/right click)
	 always @* begin
		mouse_x_d=mouse_x_q;
		mouse_y_d=mouse_y_q;
		mouse_L_d=mouse_L_q;
		mouse_R_d=mouse_R_q;
		counter_d=counter_q;
		we=0;
		wr_addr=0;
			
			if(!mouse_R_q) begin
						//update mouse location
				if(m_done_tick) begin 
						if(!mouse_L_q) begin
							mouse_x_d=x[8]? mouse_x_q - 1 -{~{x[7:0]}} : mouse_x_q+x[7:0] ; //new x value of pointer
							mouse_y_d=y[8]? mouse_y_q + 1 +{~{y[7:0]}} : mouse_y_q-y[7:0] ; //new y value of pointer
								
							//stays at the border and does not wrap around
							mouse_x_d=(!x[8] && (mouse_x_q+x[7:0])>=SIZE)? (SIZE-1): mouse_x_d; //right boundary
							mouse_x_d=(x[8] && (mouse_x_q<=(1+{~{x[7:0]}})))? 0: mouse_x_d;  //left boundary
							mouse_y_d=(y[8] && (mouse_y_q + 1 +{~{y[7:0]}})>=SIZE)? (SIZE-1): mouse_y_d; //bottom boundary
							mouse_y_d=(!y[8] && (mouse_y_q<=y[7:0]))? 0: mouse_y_d; //top boundary
						end
						mouse_L_d=btn[0]? ~mouse_L_q:mouse_L_q; //left click  turns on/off trace	
						mouse_R_d=btn[1]; 
				end
				
				
				//write new trace location at single port ram when video is surely off(i.e. ram is not being read)
				if(pixel_y==500 && pixel_x==0 && !mouse_L_q) begin
					we=1;
					wr_addr={mouse_x_q,mouse_y_q};	
				end
			end
			
			else begin //right click clears the screen by writing zero TO ALL ADDRESSES of RAM
				we=1;
				wr_addr=counter_q;
				counter_d=counter_q+1;
				if(counter_q=={16{1'b1}}) begin
					counter_d=0;
					mouse_R_d=0;
				end
			end
	 end
	 
	 
	 assign addr=we? wr_addr:rd_addr;
	 assign din=mouse_R_q? 3'b000:key;

	 //display logic
	 always @* begin
			vga_out_r=0;
			vga_out_g=0;
			vga_out_b=0;
			rd_addr=0;
		if(video_on) begin
			if(MIN_X<=pixel_x && pixel_x<=MAX_X && MIN_Y<=pixel_y && pixel_y<=MAX_Y) begin //if inside the box
				if(!mouse_R_q) begin //read data from block ram if and only if we are not writing on it(i.e. when clearing the screen after right click)
					rd_addr[15:8]=pixel_x-MIN_X;
					rd_addr[7:0]=pixel_y-MIN_Y;
					if(dout[0]) vga_out_r=5'b111_11;
					if(dout[1]) vga_out_g=6'b111_111;
					if(dout[2]) vga_out_b=5'b111_11;
				end
			end
			else begin //desired color outside box
				vga_out_g=6'b111_111;
				vga_out_b=5'b111_11;
			end
		end
	 end
	 
	 
	 
	 
	 
	 
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
	 
	vga_core m2
	(
		.clk(clk_out),
		.rst_n(rst_n), //clock must be 25MHz for 640x480 
		.hsync(vga_out_hs),
		.vsync(vga_out_vs),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y)
    );	
	 
	 single_port_syn m3//128k by 3 single port sync ram(uses block ram)
	(
		.clk(clk),
		.we(we),
		.addr(addr),
		.din(din),
		.dout(dout)
	);
	

	 


endmodule
