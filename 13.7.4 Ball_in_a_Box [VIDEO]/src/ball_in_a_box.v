`timescale 1ns / 1ps


module ball_in_a_box
	(
		input clk,rst_n,
		input video_on,
		input[1:0] key, //key[1] for changing  ball speed, key[0] to change location of ball
		input[11:0] pixel_x,pixel_y,
		output reg[4:0] r,
		output reg[5:0] g,
		output reg[4:0] b
    );				
				//SCREEN BOUNDARIES FOR A 256x256 BOX
	 
						//LEFT WALL
	 localparam LWALL_XL=187, //left
					LWALL_XR=192, //right
					LWALL_YT=107, //top
					LWALL_YB=373, //bottom
					
						//RIGHT WALL
					RWALL_XL=447, //left
					RWALL_XR=452, //right
					RWALL_YT=107, //top
					RWALL_YB=372, //bottom
						
						//TOP WALL
					TWALL_XL=187, //left
					TWALL_XR=452, //right
					TWALL_YT=107, //top
					TWALL_YB=112, //bottom
						
						//BOTTOM WALL
					BWALL_XL=187, //left
					BWALL_XR=452, //right
					BWALL_YT=367, //top
					BWALL_YB=372, //bottom
					
					
					
					ball_DIAM=7; //ball diameter minus one


	 reg[4:0] ball_V[3:0]; //stores current speed of ball
	 reg[1:0] ball_v_q=0,ball_v_d; //address for ball_V
	 
	 initial begin //list of available ball speeds
		ball_V[0]=5'd1;
		ball_V[1]=5'd5;
		ball_V[2]=5'd10;
		ball_V[3]=5'd20;
	 end
	
					
	 wire lwall_on,r_wall_on,twall_on,bwall_on,ball_box;
	 wire key0_tick,key1_tick;
	
	 reg[2:0] lwall_q,lwall_d,rwall_q,rwall_d,twall_q,twall_d,bwall_q,bwall_d; //stores color of walls
	 reg ball_on;
	 reg[2:0] rom_addr; //rom for circular pattern of ball
	 reg[7:0] rom_data;
	 reg[9:0] ball_x_q=280,ball_x_d; //stores left X value of the bouncing ball
	 reg[9:0] ball_y_q=200,ball_y_d; //stores upper Y value of the bouncing ball
	 reg ball_xdelta_q=0,ball_xdelta_d;
	 reg ball_ydelta_q=0,ball_ydelta_d;
	 
	 //display conditions for the four walls
	 assign lwall_on= LWALL_XL<=pixel_x && pixel_x<=LWALL_XR && LWALL_YT<=pixel_y && pixel_y<=LWALL_YB;
	 assign rwall_on= RWALL_XL<=pixel_x && pixel_x<=RWALL_XR && RWALL_YT<=pixel_y && pixel_y<=RWALL_YB;
	 assign twall_on= TWALL_XL<=pixel_x && pixel_x<TWALL_XR && TWALL_YT<=pixel_y && pixel_y<=TWALL_YB;
	 assign bwall_on= BWALL_XL<=pixel_x && pixel_x<BWALL_XR && BWALL_YT<=pixel_y && pixel_y<=BWALL_YB;

	
	 assign ball_box= ball_x_q<=pixel_x && pixel_x<=(ball_x_q+ball_DIAM) &&  ball_y_q<=pixel_y && pixel_y<=(ball_y_q+ball_DIAM);

	 //circular ball_on logic
	 always @* begin
		rom_addr=0;
		ball_on=0;
		if(ball_box) begin
			rom_addr=pixel_y-ball_y_q;
			if(rom_data[pixel_x-ball_x_q]) ball_on=1;
		end
	 end
	 
	 //ball rom pattern
	 always @* begin
		 case(rom_addr)
			3'd0: rom_data=8'b0001_1000;
			3'd1: rom_data=8'b0011_1100;
			3'd2: rom_data=8'b0111_1110;
			3'd3: rom_data=8'b1111_1111;
			3'd4: rom_data=8'b1111_1111;
			3'd5: rom_data=8'b0111_1110;
			3'd6: rom_data=8'b0011_1100;
			3'd7: rom_data=8'b0001_1000;
		 endcase
	 end
	 
	 
	 //logic for self-bouncing ball
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin 
				//initial is center of screen
			ball_x_q<=320;
			ball_y_q<=240;
			ball_xdelta_q<=0;
			ball_xdelta_q<=0;
			lwall_q<=0;
			rwall_q<=0;
			twall_q<=0;
			bwall_q<=0;
			ball_v_q<=0;
		end
		else begin
			ball_x_q<=ball_x_d;
			ball_y_q<=ball_y_d;
			ball_xdelta_q<=ball_xdelta_d;
			ball_ydelta_q<=ball_ydelta_d;
			lwall_q<=lwall_d;
			rwall_q<=rwall_d;
			twall_q<=twall_d;
			bwall_q<=bwall_d;
			ball_v_q<=ball_v_d;
		end
	 end
	 
	 always @* begin
		ball_x_d=ball_x_q;
		ball_y_d=ball_y_q;
		ball_xdelta_d=ball_xdelta_q;
		ball_ydelta_d=ball_ydelta_q;
		lwall_d=lwall_q;
		rwall_d=rwall_q;
		twall_d=twall_q;
		bwall_d=bwall_q;
		ball_v_d=ball_v_q;
		
			if(key0_tick) begin //change ball location based on current scan location
				ball_x_d=pixel_x;
				ball_y_d=pixel_y;
			end
			
	
			else if(pixel_y==500 && pixel_x==0) begin//1 tick when video is surely off
			
				lwall_d=3'b010; //default wall color is green
				rwall_d=3'b010;
				twall_d=3'b010;
				bwall_d=3'b010;
				
				//bouncing ball logic
				if(ball_x_q<=LWALL_XR) begin //bounce from left wall
					ball_xdelta_d=1; 
					lwall_d=3'b100;
				end
				else if(RWALL_XL<=ball_x_q+ball_DIAM) begin  //bounce from right wall
					ball_xdelta_d=0;
					rwall_d=3'b001;
				end
				if(ball_y_q<=TWALL_YB) begin
					ball_ydelta_d=1; //bounce from top wall
					twall_d=3'b110;
				end
				else if(BWALL_YT<=ball_y_q+ball_DIAM) begin
					ball_ydelta_d=0; //bounce from bottom wall
					bwall_d=3'b011;
				end
				
				ball_x_d=ball_xdelta_d? (ball_x_q+ball_V[ball_v_q]):(ball_x_q-ball_V[ball_v_q]);
				ball_y_d=ball_ydelta_d? (ball_y_q+ball_V[ball_v_q]):(ball_y_q-ball_V[ball_v_q]);
			end
			
			if(key1_tick) ball_v_d=ball_v_q+1; //change ball speed
	 end
	 
	 
	 //overall display logic
	always @* begin
	 	r=0;
		g=0;
		b=0;
		if(video_on) begin
			if(ball_on) b={5{1'b1}}; //ball color 
			
			else if(rwall_on) begin  //right wall color
				r={5{rwall_q[2]}};
				g={6{rwall_q[1]}};
				b={5{rwall_q[0]}};
			end
			else if(lwall_on) begin   //left wall color
				r={5{lwall_q[2]}};
				g={6{lwall_q[1]}};
				b={5{lwall_q[0]}};
			end
			else if(twall_on) begin //top wall color
				r={5{twall_q[2]}};
				g={6{twall_q[1]}};
				b={5{twall_q[0]}};
			end
			else if(bwall_on) begin //bottom wall color
				r={5{bwall_q[2]}};
				g={6{bwall_q[1]}};
				b={5{bwall_q[0]}};
			end
			else if(LWALL_XR<=pixel_x && pixel_x<=RWALL_XL && TWALL_YB<=pixel_y && pixel_y<=BWALL_YT) begin //color inside box
				//r={5{1'b1}};
				g={6{1'b1}};
				b={5{1'b1}};
			end
			else begin //color outside box
				r={5{1'b1}};
				g={6{1'b1}};
				b={5{1'b1}};
			end
		end
	 end
	 
	 debounce_explicit
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(key[0]),
		.db_level(),
		.db_tick(key0_tick)
    );
	 debounce_explicit
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(key[1]),
		.db_level(),
		.db_tick(key1_tick)
    );
					
endmodule


