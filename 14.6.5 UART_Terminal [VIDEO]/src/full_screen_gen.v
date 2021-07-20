`timescale 1ns / 1ps

 module full_screen_gen(
	input clk,rst_n,
	input rx,
	input[9:0] pixel_x,pixel_y,
	input video_on,
	output reg[2:0] rgb
    );
	 localparam idle=0,
					first=1,
					start=2;
					
	 wire key0_tick,key1_tick,key2_tick;
	 wire[6:0] rd_data,ascii_char,din;
	 reg[6:0] scroll_data;
	 wire[7:0] font_data;
	 wire font_bit;
	 wire rx_empty;
	 wire[11:0] addr_a,addr_b;
	 reg rd_uart;
	 reg scroll_q,scroll_d,scroll;
	 reg we;
	 wire we_1;
	 reg scroll_we;
	 reg[1:0] state_q,state_d; //FSM state for renewing the whole RAM when scrolling the screen
	 wire underline_on,cursor_on;
	 reg[4:0] y_cursor_q=0,y_cursor_d; 
	 reg[6:0] x_cursor_q=0,x_cursor_d;
	 reg[4:0] scroll_y_q=0,scroll_y_d; 
	 reg[6:0] scroll_x_q=0,scroll_x_d;
	 reg[4:0] scroll_ry_q=0,scroll_ry_d; 
	 reg[6:0] scroll_rx_q=0,scroll_rx_d;
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
			scroll_q<=0;
			state_q<=idle;
			scroll_x_q=0;
			scroll_y_q=0;
			scroll_rx_q=0;
			scroll_ry_q=0;
		end
		else begin
			y_cursor_q<=y_cursor_d;
			x_cursor_q<=x_cursor_d;
			pixel_x_q<=pixel_x;
			pixel_x_q2<=pixel_x_q;
			pixel_y_q<=pixel_y;
			pixel_y_q2<=pixel_y_q;
			scroll_q<=scroll_d;
			state_q<=state_d;
			scroll_x_q=scroll_x_d;
			scroll_y_q=scroll_y_d;
			scroll_rx_q=scroll_rx_d;
			scroll_ry_q=scroll_ry_d;
		end
	 end
	 
	 //combinatinal logic on writing characters(from UART) to the screens
	 always @* begin
		x_cursor_d=x_cursor_q;
		y_cursor_d=y_cursor_q;
		we=0;
		scroll=0;
		
		//UART receiving logic
		if(!rx_empty && rd_data==8'h0d)  begin //if received ASCII is a carriage return command, go to new line
			x_cursor_d=0;  
			y_cursor_d=(y_cursor_q==29)?y_cursor_q:y_cursor_q+1; 
			scroll = (y_cursor_q==29)?1:0;  
		end
		else if(!rx_empty) begin
			we=1;
			x_cursor_d=x_cursor_q+1;
			if(x_cursor_d==80) begin //line wraps to new line after 80 characters
				x_cursor_d=0;  
				y_cursor_d=(y_cursor_q==29)?y_cursor_q:y_cursor_q+1; //if cursor reached the character limit(80) but is already at the last line,stay there since
				scroll = (y_cursor_q==29)?1:0;									// screen will automatically scroll up after this
			end
		 end
	 end
	 
	 //logic for"scrolling" the screen up(when cursor reaches the last line)
	 //updates ALL addresses of the RAM(first line is discarded while all other lines will scroll-up by one)
	 always @* begin
		scroll_d=scroll_q;
		state_d=state_q;
		scroll_x_d=scroll_x_q;
		scroll_y_d=scroll_y_q;
		scroll_rx_d=scroll_rx_q;
		scroll_ry_d=scroll_ry_q;
		scroll_we=0;
		scroll_d=scroll_q;
		scroll_data=ascii_char;
		
		if(scroll) scroll_d=1; //scroll tick updates the scroll_q
		if(scroll_q) begin
			case(state_q)
				 idle: begin
							scroll_rx_d=0; 
							scroll_ry_d=1; //read addr, read must start at second line since screen will "scroll" up
							scroll_x_d=0; 
							scroll_y_d=0; //write addr, write must start at first line
							state_d=first;
						 end
				first: begin
							scroll_we=1; //write at point 0,0
							scroll_rx_d=scroll_rx_q+1; //advance read-addr for correct writing order
							state_d=start;
						 end
				start: begin
							scroll_we=1;
									
							//write addr 
							if(scroll_x_q==79) begin//reached the 80-character limit
								scroll_x_d=0;
								scroll_y_d=scroll_y_q+1;
							end
							else	scroll_x_d=scroll_x_q+1;
							if(scroll_y_q==29) scroll_data=0; //the new line(last line) will be empty
							if(scroll_y_q==29 && scroll_x_q==79) begin 
								scroll_d=0;
								state_d=idle;
							end
							
							
							//read addr
							if(scroll_rx_q==79) begin//reached the 80-character limit
								scroll_rx_d=0;
								scroll_ry_d=scroll_ry_q+1;
							end
							else	scroll_rx_d=scroll_rx_q+1;						
			
						 end
				default: state_d=idle;
			endcase
		end
	 end
	  
	  
	  assign font_bit=font_data[~pixel_x_q2] && !scroll_q;
	  assign cursor_on= (pixel_y_q2[8:4]==y_cursor_q && pixel_x_q2[9:3]==x_cursor_q); //current cursor
	  assign underline_on= cursor_on && (pixel_y_q2[3:1]==3'b111) && !scroll_q; //current scan is at the last 2 rows of the current cursor
	  
	  assign din=scroll_q? scroll_data:rd_data;
	  assign addr_a=scroll_q? {scroll_y_q,scroll_x_q}:{y_cursor_q,x_cursor_q}; //write addr
	  assign addr_b=scroll_q? {scroll_ry_q,scroll_rx_q}:{pixel_y[8:4],pixel_x[9:3]}; //read addr
	  assign we_1=scroll_q? scroll_we:we;

	 //rgb logic 
	 always @* begin
		rgb=0;
		if(!video_on) 	rgb=0;
		else if(underline_on) rgb=3'b011; //underline the current cursor
		else rgb=font_bit? 3'b010:3'b000;
	 end
	 
	 
	 //module instantiations
	  uart #(.DBIT(8),.SB_TICK(16),.DVSR(326),.DVSR_WIDTH(9),.FIFO_W(5)) m0 //Buad rate of 4800 for a 25MHz clock
	(
		.clk(clk),
		.rst_n(rst_n),
		.rd_uart(!rx_empty),
		.wr_uart(),
		.wr_data(),
		.rx(rx),
		.tx(),
		.rd_data(rd_data),
		.rx_empty(rx_empty),
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
		.we(we_1),
		.din(din), //write data
		.addr_a(addr_a), //write addr
		.addr_b(addr_b), //read addr
		.dout_a(),
		.dout_b(ascii_char) //read data	
	);
	
	
endmodule

module dual_port_syn //dual port synchronous ram(uses block ram)
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
