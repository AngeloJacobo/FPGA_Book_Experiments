`timescale 1ns / 1ps

module bitmap_gen(
	input clk,rst_n,
	input[3:0] key,
	input video_on,
	input[11:0] pixel_x,pixel_y,
	output reg[4:0] vga_out_r,
	output reg[5:0] vga_out_g,
	output reg[4:0] vga_out_b
    );
	 
					//screen boundary for a 256x256 box at the center of screen
	localparam  MAX_X=447,
					MIN_X=192,
					MIN_Y=112,
					MAX_Y=367,
					SIZE=256, //screen box size
					ball_V=1;//ball velocity
	
	reg[15:0] rd_addr,wr_addr;
	wire[15:0] addr; //read and write address for the 128k by 3 single port ram
	reg we;
	reg[7:0] ball_x_q=0,ball_x_d; //stores X value of the dot
	reg[7:0] ball_y_q=0,ball_y_d; //stores Y value of the dot
	reg ball_xdelta_q=0,ball_xdelta_d;
	reg ball_ydelta_q=0,ball_ydelta_d;
	wire[2:0] dout;
	wire key3_tick;
	
	 
	 //register for tracing dot
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			ball_x_q<=0;
			ball_y_q<=0;
			ball_xdelta_q<=0;
			ball_xdelta_q<=0;
		end
		else begin
			ball_x_q<=ball_x_d;
			ball_y_q<=ball_y_d;
			ball_xdelta_q<=ball_xdelta_d;
			ball_ydelta_q<=ball_ydelta_d;
		end
	 end
	 
	 //bouncing ball location logic
	 always @* begin
		ball_x_d=ball_x_q;
		ball_y_d=ball_y_q;
		ball_xdelta_d=ball_xdelta_q;
		ball_ydelta_d=ball_ydelta_q;
		wr_addr=0;
		we=0;
		
		if(key3_tick) begin //if key3 is pushed, the ball will move to the current location of scan(which would appear random to our eyes)
			ball_x_d=pixel_x;
			ball_y_d=pixel_y;
		end
		else if(pixel_y==500 && pixel_x==0) begin//1 tick when video is surely off
			//bouncing ball logic
			if(ball_x_q<=ball_V) ball_xdelta_d=1; //bounce from left wall
			else if((SIZE-ball_V-1)<=ball_x_q) ball_xdelta_d=0; //bounce from right wall
			if(ball_y_q<=ball_V) ball_ydelta_d=1; //bounce from top
			else if((SIZE-ball_V-1)<=ball_y_q) ball_ydelta_d=0; //bounce from bottom
			
			ball_x_d=ball_xdelta_d? (ball_x_q+ball_V):(ball_x_q-ball_V);
			ball_y_d=ball_ydelta_d? (ball_y_q+ball_V):(ball_y_q-ball_V);
			wr_addr={ball_x_q,ball_y_q}; //write the new trace location during refresh period i.e. when not reading
			we=1;
		end
	 end
	 
	
	//display logic
	always @* begin
		vga_out_r=0;
		vga_out_g=0;
		vga_out_b=0;
		rd_addr=0;
		if(video_on) begin
			if(MIN_X<=pixel_x && pixel_x<=MAX_X && MIN_Y<=pixel_y && pixel_y<=MAX_Y) begin //if inside the box
				rd_addr[15:8]=pixel_x-MIN_X;
				rd_addr[7:0]=pixel_y-MIN_Y;
				if(dout[0]) vga_out_r=5'b111_11;
				if(dout[1]) vga_out_g=6'b111_111;
				if(dout[2]) vga_out_b=5'b111_11;
			end
			else begin //color outside box
				vga_out_r=5'b111_11;
				vga_out_g=6'b111_111;
				vga_out_b=5'b111_11;
			end
		end
	end
	
	assign addr=we? wr_addr : rd_addr; 
	
	single_port_syn m0 //64k by 3
	(
		.clk(clk),
		.we(we),
		.addr(addr),
		.din((~key[2:0])),
		.dout(dout)
	);
	
	debounce_explicit m1
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(!key[3]),
		.db_level(),
		.db_tick(key3_tick)
    );

					
endmodule






