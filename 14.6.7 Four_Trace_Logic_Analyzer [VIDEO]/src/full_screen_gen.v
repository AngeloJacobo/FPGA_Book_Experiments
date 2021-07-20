`timescale 1ns / 1ps

module full_screen_gen(
	input clk,rst_n,
	input key,
	input[3:0] in, //square wave input to be displayed on screen via VGA
	input[9:0] pixel_x,pixel_y, 
	input video_on,
	output reg[2:0] rgb
    );
	//FSM for storing the four square-wave signal to RAM which will then be displayed at the screen
	 localparam idle=0,
					firstpair=1,
					secondpair=2;
	 
	 reg[1:0] state_q,state_d;
	 reg we;
	 wire on1,on2,on3,on4;
	 reg on;
	 reg[6:0] x_cursor_q,x_cursor_d;
	 reg[1:0] dout;
	 wire[1:0] dout_1,dout_2,dout_3,dout_4;
	 reg[1:0] din1_q,din1_d,din2_q,din2_d,din3_q,din3_d,din4_q,din4_d;
	 reg[7:0] mod125_q=0;
	 wire mod_tick;
	 wire[7:0] font_data;
	 wire font_bit;
	 wire key_tick;
	 reg[9:0] pixel_x_q,pixel_x_q2; 	//retrieving data from syn_rom and syn_dualport_ram causes 2 clk
																							//delays so we need to delay the pixel_x and pixel_y by 2 clk delays too
																							
	 
	 //register operation to update current cursor
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_q<=0;
			din1_q<=0;
			din2_q<=0;
			din3_q<=0;
			din4_q<=0;
			pixel_x_q<=0;
			pixel_x_q2<=0;
			mod125_q<=0;
			x_cursor_q<=0;
		end
		else begin
			state_q<=state_d;
			din1_q<=din1_d;
			din2_q<=din2_d;
			din3_q<=din3_d;
			din4_q<=din4_d;
			x_cursor_q<=x_cursor_d;
			pixel_x_q<=pixel_x;
			pixel_x_q2<=pixel_x_q;
			mod125_q<=(mod125_q==124)?0:mod125_q+1; //free running counter(200kHz)
		end
	 end
		assign mod_tick = mod125_q==0; //ticks every 5us(200kHz),serves as sampling tick for the highest possible frequency of the square wave(which is 100kHz)
		
		//FSM logic for sampling the four square-wave inputs
		always @* begin
			state_d=state_q;
			din1_d=din1_q;
			din2_d=din2_q;
			din3_d=din3_q;
			din4_d=din4_q;
			x_cursor_d=x_cursor_q;
			we=0;
			dout=0;
			on=0;
			case(state_q)
				  	   idle: if(key_tick) begin
									state_d=firstpair;
									x_cursor_d=0;									
								end
				 firstpair: if(mod_tick) begin  //forming the first pair
									din1_d={1'b0,in[0]};
									din2_d={1'b0,in[1]};
									din3_d={1'b0,in[2]};
									din4_d={1'b0,in[3]};		
									state_d=secondpair;
									end
				secondpair: if(mod_tick) begin // get the second pair and send it to ram
									we=1;
									din1_d={din1_q[0],in[0]};
									din2_d={din2_q[0],in[1]};
									din3_d={din3_q[0],in[2]};
									din4_d={din4_q[0],in[3]};		
									if(x_cursor_q==79) state_d=idle;
									else x_cursor_d=x_cursor_q+1;
								end
				   default: state_d=idle;
			endcase 
			
			//chooses which ram will be used in a given row (4 rows will be used for the 4 trace of square-wave inputs)
			case(pixel_y[8:6]) 
						0: begin 
								dout=dout_1;
								on=on1;
							end
						2: begin 
								dout=dout_2;
								on=on2;
							end
						4: begin
								dout=dout_3;
								on=on3;
							end
						6: begin
								dout=dout_4;
								on=on4;
							end
			endcase
			
		end
		
		
	  
	  assign font_bit=on && font_data[~pixel_x_q2[2:0]];
		
	  
	 //rgb logic 
	 always @* begin
		rgb=0;
		if(!video_on) 	rgb=0;
		else rgb=font_bit? 3'b010:3'b000;
	 end
	 
	 
	 //module instantiations
	 
	squarewave_rom m0
	(
		.clk(clk),
		.addr({dout,pixel_y[5:0]}), //7:6 for square-wave pattern , 5:0 for column address of that pattern
		.data(font_data)
    );
	
	dual_port_syn #(.ADDR_WIDTH(10),.DATA_WIDTH(3)) m1 //storage ram for trace 1
	(
		.clk(clk),
		.we(we),
		.din({1'b1,din1_q}), //write data
		.addr_a({3'd0,x_cursor_q}), //write addr
		.addr_b({pixel_y[8:6],pixel_x[9:3]}), //read addr
		.dout_a(),
		.dout_b({on1,dout_1}) //read data	
	);
	
	dual_port_syn #(.ADDR_WIDTH(10),.DATA_WIDTH(3)) m2 //storage ram for trace 2
	(
		.clk(clk),
		.we(we),
		.din({1'b1,din2_q}), //write data
		.addr_a({3'd2,x_cursor_q}), //write addr
		.addr_b({pixel_y[8:6],pixel_x[9:3]}), //read addr
		.dout_a(),
		.dout_b({on2,dout_2}) //read data	
	);
	
	dual_port_syn #(.ADDR_WIDTH(10),.DATA_WIDTH(3)) m3 //storage ram for trace 3
	(
		.clk(clk),
		.we(we),
		.din({1'b1,din3_q}), //write data
		.addr_a({3'd4,x_cursor_q}), //write addr
		.addr_b({pixel_y[8:6],pixel_x[9:3]}), //read addr
		.dout_a(),
		.dout_b({on3,dout_3}) //read data	
	);
	
	dual_port_syn #(.ADDR_WIDTH(10),.DATA_WIDTH(3)) m4 //storage ram for trace 4
	(
		.clk(clk),
		.we(we),
		.din({1'b1,din4_q}), //write data
		.addr_a({3'd6,x_cursor_q}), //write addr
		.addr_b({pixel_y[8:6],pixel_x[9:3]}), //read addr
		.dout_a(),
		.dout_b({on4,dout_4}) //read data	
	);
	
	debounce_explicit m5
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(!key),
		.db_level(),
		.db_tick(key_tick)
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
