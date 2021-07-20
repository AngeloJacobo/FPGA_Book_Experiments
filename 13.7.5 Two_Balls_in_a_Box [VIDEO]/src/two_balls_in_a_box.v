`timescale 1ns / 1ps

module two_balls_in_a_box
	(
		input clk,rst_n,
		input video_on,
		input[1:0] key, //key[0] for changing  ball speed, key[2] to change location of ball
		input[11:0] pixel_x,pixel_y,
		output reg[4:0] r,
		output reg[5:0] g,
		output reg[4:0] b
    );			
				//SCREEN BOUNDARIES FOR A 100x100 BOX
				
						//LEFT WALL
	 localparam LWALL_XL=260, //left
					LWALL_XR=270, //right
					LWALL_YT=180, //top
					LWALL_YB=300, //bottom
					
						//RIGHT WALL
					RWALL_XL=370, //left
					RWALL_XR=380, //right
					RWALL_YT=180, //top
					RWALL_YB=300, //bottom
						
						//TOP WALL
					TWALL_XL=260, //left
					TWALL_XR=380, //right
					TWALL_YT=180, //top
					TWALL_YB=190, //bottom
						
						//BOTTOM WALL
					BWALL_XL=260, //left
					BWALL_XR=380, //right
					BWALL_YT=290, //top
					BWALL_YB=300, //bottom
					
					
					
					ball_DIAM=15; //ball diameter minus one


	 reg[4:0] ball_V[3:0]; //stores current speed of ball
	 reg[1:0] ball_v_q=0,ball_v_d; //address for ball_V
	 
	 initial begin //list of available ball speeds
		ball_V[0]=5'd1;
		ball_V[1]=5'd5;
		ball_V[2]=5'd10;
		ball_V[3]=5'd20;
	 end
	
					
	 wire lwall_on,r_wall_on,twall_on,bwall_on,ball_1_box,ball_2_box;
	 wire key0_tick,key1_tick;
	
	 reg[2:0] lwall_q,lwall_d,rwall_q,rwall_d,twall_q,twall_d,bwall_q,bwall_d; //stores color of walls
	 reg ball_1_on,ball_2_on;
	 reg holder_q=0,holder_d; //place holder to prevent consecutive bounce which will cause the balls to lock up on each other
	 reg[3:0] rom_addr; //rom for circular pattern of ball
	 reg[15:0] rom_data;
	 reg[9:0] ball_1x_q=280,ball_1x_d,ball_2x_q=100,ball_2x_d; //stores left X value of the TWO bouncing ball
	 reg[9:0] ball_1y_q=200,ball_1y_d,ball_2y_q=100,ball_2y_d; //stores upper Y value of the TWO bouncing ball
	 reg ball_1xdelta_q=0,ball_1xdelta_d,ball_2xdelta_q=0,ball_2xdelta_d; //stores  x-direction(right or left) movement of the TWO bouncing balls
	 reg ball_1ydelta_q=0,ball_1ydelta_d,ball_2ydelta_q=0,ball_2ydelta_d; //stores  y-direction(up or down) movement of the TWO bouncing balls
	 
	 //display conditions for the four walls
	 assign lwall_on= LWALL_XL<=pixel_x && pixel_x<=LWALL_XR && LWALL_YT<=pixel_y && pixel_y<=LWALL_YB;
	 assign rwall_on= RWALL_XL<=pixel_x && pixel_x<=RWALL_XR && RWALL_YT<=pixel_y && pixel_y<=RWALL_YB;
	 assign twall_on= TWALL_XL<=pixel_x && pixel_x<TWALL_XR && TWALL_YT<=pixel_y && pixel_y<=TWALL_YB;
	 assign bwall_on= BWALL_XL<=pixel_x && pixel_x<BWALL_XR && BWALL_YT<=pixel_y && pixel_y<=BWALL_YB;

	
	 assign ball_1_box= ball_1x_q<=pixel_x && pixel_x<=(ball_1x_q+ball_DIAM) &&  ball_1y_q<=pixel_y && pixel_y<=(ball_1y_q+ball_DIAM);
	 assign ball_2_box= ball_2x_q<=pixel_x && pixel_x<=(ball_2x_q+ball_DIAM) &&  ball_2y_q<=pixel_y && pixel_y<=(ball_2y_q+ball_DIAM);

	 
	 //circular ball_on logic
	 always @* begin
		rom_addr=0;
		ball_1_on=0;
		ball_2_on=0;
		if(ball_1_box) begin
			rom_addr=pixel_y-ball_1y_q;
			if(rom_data[pixel_x-ball_1x_q]) ball_1_on=1;
		end
		if(ball_2_box) begin
			rom_addr=pixel_y-ball_2y_q;
			if(rom_data[pixel_x-ball_2x_q]) ball_2_on=1;
		end
	 end
	 
	 //ball rom pattern
	 always @* begin
		 case(rom_addr)
			0: rom_data=16'b0000_0001_1000_0000;
			1: rom_data=16'b0000_0011_1100_0000;
			2: rom_data=16'b0000_0111_1110_0000;
			3: rom_data=16'b0000_1111_1111_0000;
			4: rom_data=16'b0001_1111_1111_1000;
			5: rom_data=16'b0011_1111_1111_1100;
			6: rom_data=16'b0111_1111_1111_1110;
			7: rom_data=16'b1111_1111_1111_1111;
			8: rom_data=16'b1111_1111_1111_1111;
			9: rom_data=16'b0111_1111_1111_1110;
			10: rom_data=16'b0011_1111_1111_1100;
			11: rom_data=16'b0001_1111_1111_1000;
			12: rom_data=16'b0000_1111_1111_0000;
			13: rom_data=16'b0000_0111_1110_0000;
			14: rom_data=16'b0000_0011_1100_0000;
			15: rom_data=16'b0000_0001_1000_0000;
		 endcase
	 end
	 
	 //register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin 
				//initial is center of screen
			ball_1x_q<=300;
			ball_1y_q<=300;
			ball_1xdelta_q<=0;
			ball_1xdelta_q<=0;
			
			ball_2x_q<=250;
			ball_2y_q<=250;
			ball_2xdelta_q<=0;
			ball_2xdelta_q<=0;
			
			lwall_q<=0;
			rwall_q<=0;
			twall_q<=0;
			bwall_q<=0;
			ball_v_q<=0;
			holder_q<=0;
		end
		else begin
			ball_1x_q<=ball_1x_d;
			ball_1y_q<=ball_1y_d;
			ball_1xdelta_q<=ball_1xdelta_d;
			ball_1ydelta_q<=ball_1ydelta_d;
			
			ball_2x_q<=ball_2x_d;
			ball_2y_q<=ball_2y_d;
			ball_2xdelta_q<=ball_2xdelta_d;
			ball_2ydelta_q<=ball_2ydelta_d;
			
			lwall_q<=lwall_d;
			rwall_q<=rwall_d;
			twall_q<=twall_d;
			bwall_q<=bwall_d;
			ball_v_q<=ball_v_d;
			holder_q<=holder_d;
		end
	 end
	 
	 
	 //logic for self-bouncing ball
	 always @* begin
		ball_1x_d=ball_1x_q;
		ball_1y_d=ball_1y_q;
		ball_1xdelta_d=ball_1xdelta_q;
		ball_1ydelta_d=ball_1ydelta_q;
		
		ball_2x_d=ball_2x_q;
		ball_2y_d=ball_2y_q;
		ball_2xdelta_d=ball_2xdelta_q;
		ball_2ydelta_d=ball_2ydelta_q;
		
		lwall_d=lwall_q;
		rwall_d=rwall_q;
		twall_d=twall_q;
		bwall_d=bwall_q;
		ball_v_d=ball_v_q;
		holder_d=holder_q;
		
			if(key0_tick) begin //change ball location based on current scan location
				ball_1x_d=pixel_x;
				ball_1y_d=pixel_y;
				ball_2x_d=pixel_y;
				ball_2y_d=pixel_x;
			end
			
	
			else if(pixel_y==500 && pixel_x==0) begin//1 tick when video is surely off
			
				lwall_d=3'b010; //default wall color is green
				rwall_d=3'b010;
				twall_d=3'b010;
				bwall_d=3'b010;
				
				//bouncing ball #1 logic
				if(ball_1x_q<=LWALL_XR) begin //bounce from left wall
					ball_1xdelta_d=1; 
					lwall_d=3'b100;
				end
				else if(RWALL_XL<=ball_1x_q+ball_DIAM) begin  //bounce from right wall
					ball_1xdelta_d=0;
					rwall_d=3'b001;
				end
				if(ball_1y_q<=TWALL_YB) begin //bounce from top wall
					ball_1ydelta_d=1; 
					twall_d=3'b110;
				end
				else if(BWALL_YT<=ball_1y_q+ball_DIAM) begin //bounce from bottom wall
					ball_1ydelta_d=0; 
					bwall_d=3'b011;
				end
				
				
				//bouncing ball #2 logic
				if(ball_2x_q<=LWALL_XR) begin //bounce from left wall
					ball_2xdelta_d=1; 
					lwall_d=3'b100;
				end
				else if(RWALL_XL<=ball_2x_q+ball_DIAM) begin  //bounce from right wall
					ball_2xdelta_d=0;
					rwall_d=3'b001;
				end
				if(ball_2y_q<=TWALL_YB) begin
					ball_2ydelta_d=1; //bounce from top wall
					twall_d=3'b110;
				end
				else if(BWALL_YT<=ball_2y_q+ball_DIAM) begin
					ball_2ydelta_d=0; //bounce from bottom wall
					bwall_d=3'b011;
				end
				
				//colliding balls
				if( (ball_2y_q<=ball_1y_q+ball_DIAM) && (ball_1y_q<=ball_2y_q+ball_DIAM) && (ball_2x_q<=ball_1x_q+ball_DIAM) && (ball_1x_q<=ball_2x_q+ball_DIAM) ) begin //balls collide
					if(!holder_q) begin //no consecutive bounce to avoid the balls from locking up each other
					
						//logic for colliding balls that follows(slightly) the laws of physics
						case({{ball_1xdelta_q,ball_1ydelta_q},{ball_2xdelta_q,ball_2ydelta_q}})
							  4'b1100 , 4'b0011: begin
															if(ball_1x_q>=ball_2x_q) begin
																ball_1xdelta_d=1;
																ball_1ydelta_d=0;
																ball_2xdelta_d=0;
																ball_2ydelta_d=1;
															end
															else begin
																ball_1xdelta_d=0;
																ball_1ydelta_d=1;
																ball_2xdelta_d=1;
																ball_2ydelta_d=0;
															end
														end
							  4'b0110 , 4'b1001: begin
															if(ball_1y_q>=ball_2y_q) begin
																ball_1xdelta_d=1;
																ball_1ydelta_d=1;
																ball_2xdelta_d=0;
																ball_2ydelta_d=0;
															end
															else begin
																ball_1xdelta_d=0;
																ball_1ydelta_d=0;
																ball_2xdelta_d=1;
																ball_2ydelta_d=1;
															end
														end
											4'b1101: begin
															ball_1xdelta_d=0;
															ball_1ydelta_d=1;
															ball_2xdelta_d=1;
															ball_2ydelta_d=1;
														 end
											4'b0111: begin
															ball_1xdelta_d=1;
															ball_1ydelta_d=1;
															ball_2xdelta_d=0;
															ball_2ydelta_d=1;
														 end
											4'b1000: begin
															ball_1xdelta_d=0;
															ball_1ydelta_d=0;
															ball_2xdelta_d=1;
															ball_2ydelta_d=0;
														end
											4'b0010: begin
															ball_1xdelta_d=1;
															ball_1ydelta_d=0;
															ball_2xdelta_d=0;
															ball_2ydelta_d=0;
														end
							endcase
							holder_d=1;
						end
				end
				else holder_d=0;
				
				
				
				
				ball_1x_d=ball_1xdelta_d? (ball_1x_q+ball_V[ball_v_q]):(ball_1x_q-ball_V[ball_v_q]);
				ball_1y_d=ball_1ydelta_d? (ball_1y_q+ball_V[ball_v_q]):(ball_1y_q-ball_V[ball_v_q]);
				
				ball_2x_d=ball_2xdelta_d? (ball_2x_q+ball_V[ball_v_q]):(ball_2x_q-ball_V[ball_v_q]);
				ball_2y_d=ball_2ydelta_d? (ball_2y_q+ball_V[ball_v_q]):(ball_2y_q-ball_V[ball_v_q]);
			end
			
			if(key1_tick) ball_v_d=ball_v_q+1; //change ball speed
	 end
	 
	 
	 //overall display logic
	always @* begin
	 	r=0;
		g=0;
		b=0;
		if(video_on) begin
		
			if(ball_1_on) b={5{1'b1}}; //ball 1 color 
			else if(ball_2_on) r={5{1'b1}}; //ball 2 color
			
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
	 
	 debounce_explicit m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(key[0]),
		.db_level(),
		.db_tick(key0_tick)
    );
	 debounce_explicit m1
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(key[1]),
		.db_level(),
		.db_tick(key1_tick)
    );
					
endmodule


