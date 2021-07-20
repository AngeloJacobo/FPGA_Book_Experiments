`timescale 1ns / 1ps

module full_screen_gen(
	input clk,rst_n,
	input ps2c,ps2d, //ascii characters will come from ps2 keboard
	input[9:0] pixel_x,pixel_y,
	input video_on,
	output reg[2:0] rgb
    );
	 //FSM state for retrieving data from ps2 keyboard
	 localparam first=0, 
					second=1;
					
	 wire[8:0] rd_data;
	 reg rd_fifo;
	 wire fifo_empty;
	 reg state_q=0,state_d;
	 reg up,down,left,right; //reg connected to up,down,left,and right arrows of ps2 keyboard. Use to move the cursor
	 reg we;
	 wire breakcode; //
	 wire[6:0] ascii_char,ascii;
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
			state_q<=0;
		end
		else begin
			y_cursor_q<=y_cursor_d;
			x_cursor_q<=x_cursor_d;
			pixel_x_q<=pixel_x;
			pixel_x_q2<=pixel_x_q;
			pixel_y_q<=pixel_y;
			pixel_y_q2<=pixel_y_q;
			state_q<=state_d;
		end
	 end
	 //Combinational logic for updating cursor location via keyboard arrow keys
	 always @* begin
		x_cursor_d=x_cursor_q;
		y_cursor_d=y_cursor_q;
		if(right) x_cursor_d= (x_cursor_q<80)? x_cursor_q+1:0; //wrap around if beyond the display range(0-to-79 characters for x-axis)
		else if(left) x_cursor_d= (x_cursor_q<80)? x_cursor_q-1:79;
		else if(down) y_cursor_d= (y_cursor_q<30)? y_cursor_q+1:0;  //wrap around if beyond the display range(0-to-29 characters for y-axis)
		else if(up) y_cursor_d= (y_cursor_q<30)? y_cursor_q-1:29;  
	 end
	  
	  
	  //ps2 keyboard receiving logic
	  always @* begin
		state_d=state_q;
		rd_fifo=0;
		we=0;
		up=0;
		down=0;
		left=0;
		right=0;
		
		if(state_q==second && breakcode) state_d=first; //if breakcdode comes while waiting for special key,go back to default
		if(!fifo_empty ) begin
			case(state_q)
				first:  if(rd_data[7:0]==8'he0) state_d=second; //if special key is coming(arrow keys are preceded by hex "E0")	
						  else we=1;
				second: begin //after hex "E0" is the command for which arrow key is pressed
								if(rd_data==8'h75) up=1;
								else if(rd_data==8'h74) right=1;
								else if(rd_data==8'h6b) left=1;
								else if(rd_data==8'h72) down=1;
								state_d=first;
						  end
				default: state_d=first;
			endcase
			rd_fifo=1; //remove the data from fifo
		end
	  end
	  
	  assign font_bit=font_data[~pixel_x_q2[2:0]];
	  assign cursor_on= (pixel_y_q2[8:4]==y_cursor_q && pixel_x_q2[9:3]==x_cursor_q); //current cursor location
	  assign underline_on= cursor_on && (pixel_y_q2[3:1]==3'b111); //current scan is at the last 2 rows of the current cursor
	  
	 //rgb logic 
	 always @* begin
		rgb=0;
		if(!video_on) 	rgb=0;
		else if(underline_on) rgb=3'b011; //underline the current cursor
		else rgb=font_bit? 3'b010:3'b000;
	 end
	 
	 
	 
	 kb m0 //extract only the real bytes from received packets of data(no break code,only the command)
	 (   
		.clk(clk),
		.rst_n(rst_n),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.rd_fifo(rd_fifo),
		.rd_data(rd_data),
		.fifo_empty(fifo_empty),
		.breakcode(breakcode)
    );
	 
	 ascii_conv m1 //converts the real data from kb module to ASCII
	 ( 
		.rd_data(rd_data),
		.ascii(ascii)
    );
	 
	 font_rom m2
   (
		.clk(clk),
		.addr({ascii_char,pixel_y[3:0]}), //[10:4] for ASCII char code, [3:0] for choosing what row to read on a given character  
		.data(font_data)
   );
	
	dual_port_syn #(.ADDR_WIDTH(12),.DATA_WIDTH(7)) m3
	(
		.clk(clk),
		.we(we),
		.din(ascii), //write data
		.addr_a({y_cursor_q,x_cursor_q}), //write addr
		.addr_b({pixel_y[8:4],pixel_x[9:3]}), //read addr
		.dout_a(),
		.dout_b(ascii_char) //read data	
	);
	
	




endmodule

module dual_port_syn //dual port synchronous ram(uses block ram resources)
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
