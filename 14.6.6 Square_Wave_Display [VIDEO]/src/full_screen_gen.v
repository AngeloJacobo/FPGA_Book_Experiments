`timescale 1ns / 1ps

module full_screen_gen(
	input clk,rst_n,
	input rx,
	input[2:0] key, //key[0] to move cursor to right,key[1] to move cursor down, key[2] to change waveform pattern
	input[9:0] pixel_x,pixel_y,
	input video_on,
	output reg[2:0] rgb
    );
	 
	 wire key0_tick,key1_tick,key2_tick;
	 reg[1:0] din_q=0;
	 wire[1:0] dout;
	 wire on;
	 wire[7:0] font_data;
	 wire font_bit;
	 wire underline_on,cursor_on;
	 reg[2:0] y_cursor_q,y_cursor_d; 
	 reg[6:0] x_cursor_q,x_cursor_d;
	 reg[9:0] pixel_x_q,pixel_x_q2,pixel_y_q,pixel_y_q2; //buffer to delay the pixel_x and pixel_y by two clk times,
																					//retrieving data from syn_rom and syn_dualport_ram causes 2 clk
																							//delays so we need to delay the pixel_x and pixel_y by 2 clk delays too
																							
	 
	 //register operation to update current cursor
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			y_cursor_q<=0;
			x_cursor_q<=0;
			pixel_x_q<=0;
			pixel_x_q2<=0;
			pixel_y_q<=0;
			pixel_y_q2<=0;
			din_q<=0;
		end
		else begin
			y_cursor_q<=y_cursor_d;
			x_cursor_q<=x_cursor_d;
			pixel_x_q<=pixel_x;
			pixel_x_q2<=pixel_x_q;
			pixel_y_q<=pixel_y;
			pixel_y_q2<=pixel_y_q;
			din_q<=key2_tick? din_q+1:din_q;
		end
	 end
	 always @* begin
		x_cursor_d=x_cursor_q;
		y_cursor_d=y_cursor_q;
		if(key0_tick) x_cursor_d= (x_cursor_q<80)? x_cursor_q+1:0; //wrap around if beyond the display range(0-to-79 patterns for x-axis)
		if(key1_tick) y_cursor_d= (y_cursor_q<7)? y_cursor_q+1:0;  //wrap around if beyond the display range(0-to-6 patterns for y-axis)
	 end
	  
	  
	  assign font_bit=on && font_data[~pixel_x_q2[2:0]];
	  assign cursor_on= (pixel_y_q2[8:6]==y_cursor_q && pixel_x_q2[9:3]==x_cursor_q); //current cursor
	  assign underline_on= cursor_on && (pixel_y_q2[5:0]>=60); //current scan is at the last 4 rows(60-to-63) of the current cursor
	  
	 //rgb logic 
	 always @* begin
		rgb=0;
		if(!video_on) 	rgb=0;
		else if(underline_on) rgb=3'b011; //underline the current cursor
		else rgb=font_bit? 3'b010:3'b000;
	 end
	 
	 
	 //module instantiations
	 
	squarewave_rom m0
	(
		.clk(clk),
		.addr({dout,pixel_y[5:0]}), //7:6 for square-wave pattern , 5:0 for column address of that pattern
		.data(font_data)
    );
	
	dual_port_syn #(.ADDR_WIDTH(10),.DATA_WIDTH(3)) m1
	(
		.clk(clk),
		.we(1),
		.din({1'b1,din_q}), //write data
		.addr_a({y_cursor_q,x_cursor_q}), //write addr
		.addr_b({pixel_y[8:6],pixel_x[9:3]}), //read addr
		.dout_a(),
		.dout_b({on,dout}) //read data	
	);
	
	
	debounce_explicit m2
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw({!key[0]}),
		.db_level(),
		.db_tick(key0_tick)//move right
    );
	 
	 
	debounce_explicit m3
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw({!key[1]}),
		.db_level(),
		.db_tick(key1_tick)//move down
    );
	 
	debounce_explicit m4
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw({!key[2]}),
		.db_level(),
		.db_tick(key2_tick)//write to current cursor
    );


endmodule

module dual_port_syn
	#(
		parameter ADDR_WIDTH=11, 
					 DATA_WIDTH=8
	)
	(
		input clk,
		input we, //if write:write data based on addr_a , if read:read data for both addr_a and addr_b
		input[DATA_WIDTH-1:0] din,
		input[ADDR_WIDTH-1:0] addr_a,addr_b,
		output[DATA_WIDTH-1:0] dout_a,dout_b	
	);
	
	reg[DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	reg[ADDR_WIDTH-1:0] addr_a_q,addr_b_q;
	
	always @(posedge clk) begin
		if(we) ram[addr_a]<=din;
		addr_a_q<=addr_a;
		addr_b_q<=addr_b;	
	end
	assign dout_a=ram[addr_a_q];
	assign dout_b=ram[addr_b_q];
endmodule
