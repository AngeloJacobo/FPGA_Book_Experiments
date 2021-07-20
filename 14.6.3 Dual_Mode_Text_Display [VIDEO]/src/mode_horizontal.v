`timescale 1ns / 1ps

module mode_horizontal(
	input clk,rst_n,
	input rx,
	input[2:0] key, //key[0] to move cursor to right,key[1] to move cursor down,key[2] to write new ASCII character to current cursor
	input[9:0] pixel_x,pixel_y,
	input video_on,
	output reg[2:0] rgb
    );
	 
	 wire key0_tick,key1_tick,key2_tick;
	 wire[6:0] rd_data,ascii_char;
	 wire[7:0] font_data;
	 wire font_bit;
	 wire underline_on,cursor_on;
	 reg[4:0] y_cursor_q,y_cursor_d; 
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
		end
		else begin
			y_cursor_q<=y_cursor_d;
			x_cursor_q<=x_cursor_d;
			pixel_x_q<=pixel_x;
			pixel_x_q2<=pixel_x_q;
			pixel_y_q<=pixel_y;
			pixel_y_q2<=pixel_y_q;
		end
	 end
	 //combinational logic to update cursor position via pushbuttons
	 always @* begin
		x_cursor_d=x_cursor_q;
		y_cursor_d=y_cursor_q;
		if(key0_tick) x_cursor_d= (x_cursor_q<80)? x_cursor_q+1:0; //wrap around if beyond the display range(0-to-79 characters for x-axis)
		if(key1_tick) y_cursor_d= (y_cursor_q<30)? y_cursor_q+1:0;  //wrap around if beyond the display range(0-to-29 characters for y-axis)
	 end
	  
	  
	  assign font_bit=font_data[~pixel_x_q2[2:0]];
	  assign cursor_on= (pixel_y_q2[8:4]==y_cursor_q && pixel_x_q2[9:3]==x_cursor_q); //current cursor
	  assign underline_on= cursor_on && (pixel_y_q2[3:1]==3'b111); //current scan is at the last 2 rows of the current cursor
	  
	 //rgb logic 
	 always @* begin
		rgb=0;
		if(!video_on) 	rgb=0;
		else if(underline_on) rgb=3'b011; //underline the current cursor
		else rgb=font_bit? 3'b010:3'b000;
	 end
	 
	 
	 //module instantiations
	  uart #(.DBIT(8),.SB_TICK(16),.DVSR(326),.DVSR_WIDTH(9),.FIFO_W(10)) m0 //Baud rate of 4800 for a 25MHz clock
	(
		.clk(clk),
		.rst_n(rst_n),
		.rd_uart(key2_tick),
		.wr_uart(),
		.wr_data(),
		.rx(rx),
		.tx(),
		.rd_data(rd_data),
		.rx_empty(),
		.tx_full()
    );
	 
	 font_rom m1
   (
		.clk(clk),
		.addr({ascii_char,pixel_y[3:0]}), //[10:4] for ASCII char code, [3:0] for choosing what row to read on a given character  
		.data(font_data)
   );
	
	dual_port_syn #(.ADDR_WIDTH(12),.DATA_WIDTH(8)) m2
	(
		.clk(clk),
		.we(key2_tick),
		.din(rd_data), //write data
		.addr_a({y_cursor_q,x_cursor_q}), //write addr
		.addr_b({pixel_y[8:4],pixel_x[9:3]}), //read addr
		.dout_a(),
		.dout_b(ascii_char) //read data	
	);
	
	
	debounce_explicit m3
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(key[0]),
		.db_level(),
		.db_tick(key0_tick)//move right
    );
	 
	 
	debounce_explicit m4
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(key[1]),
		.db_level(),
		.db_tick(key1_tick)//move down
    );
	 
	debounce_explicit m5
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(key[2]),
		.db_level(),
		.db_tick(key2_tick)//write to current cursor
    );


endmodule

