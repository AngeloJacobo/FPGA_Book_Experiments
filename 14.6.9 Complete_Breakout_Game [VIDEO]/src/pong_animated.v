`timescale 1ns / 1ps

module pong_animated
	(
		input clk,rst_n,
		input video_on,
		input pause,restart, //pause=stop state after missing a ball , restart=stop state at the beginning of new game
		input[1:0] key,
		input[11:0] pixel_x,pixel_y,
		output reg[2:0] rgb,
		output reg miss,won, //miss=ball went past the paddle , won=when ball went past the left border
		output graph_on
    );	
	 localparam wall_1_XL=100, //wall 1
					wall_1_XR=105,					
					wall_2_XL=110, //wall 2
					wall_2_XR=115, 
					wall_3_XL=120, //wall 3
					wall_3_XR=125, 
					wall_4_XL=130, //wall 4
					wall_4_XR=135, 
					wall_5_XL=140, //wall 5
					wall_5_XR=145, 
					
					brick_space=3,
					
					bar_XL=550, //left
					bar_XR=555, //right
					bar_LENGTH=80, //bar length
					bar_V=4, //bar velocity
					
					ball_DIAM=7, //ball diameter-1
					ball_V=7; //ball velocity

					
	 wire wall_1_on,wall_2_on,wall_3_on,wall_4_on,wall_5_on,bar_on,ball_box;
	 reg ball_on;
	 reg[2:0] rom_addr; //rom for circular pattern of ball
	 reg[7:0] rom_data;
	 reg[9:0] bar_top_q=220,bar_top_d; //stores upper Y value of bar,controlled by key[0] and key[1]
	 reg[9:0] ball_x_q=280,ball_x_d; //stores left X value of the bouncing ball
	 reg[9:0] ball_y_q=200,ball_y_d; //stores upper Y value of the bouncing ball
	 reg ball_xdelta_q=1,ball_xdelta_d;
	 reg ball_ydelta_q=1,ball_ydelta_d;
	 reg hold_q=0,hold_d; //make sure no consecutive bounces fromm wall happens or else all wall will vanish instantly
	 reg[4:0] wall_q=5'b111_11,wall_d; //5 bits which acts like the 5 walls. Shift left every time a "wall" is broken

	 //display conditions															//inside "!" statement is for brick spacing to make it look more like a brick rather than a wall
	 assign wall_1_on= wall_1_XL<=pixel_x && pixel_x<=wall_1_XR && !( (120<=pixel_y && pixel_y<=125) || (240<=pixel_y && pixel_y<=245) || (360<=pixel_y && pixel_y<=365)); 
	 assign wall_2_on= wall_2_XL<=pixel_x && pixel_x<=wall_2_XR && !( (60<=pixel_y && pixel_y<=65) || (180<=pixel_y && pixel_y<=185) || (300<=pixel_y && pixel_y<=305) || (420<=pixel_y && pixel_y<=425));
	 assign wall_3_on= wall_3_XL<=pixel_x && pixel_x<=wall_3_XR && !( (120<=pixel_y && pixel_y<=125) || (240<=pixel_y && pixel_y<=245) || (360<=pixel_y && pixel_y<=365)); 
	 assign wall_4_on= wall_4_XL<=pixel_x && pixel_x<=wall_4_XR && !( (60<=pixel_y && pixel_y<=65) || (180<=pixel_y && pixel_y<=185) || (300<=pixel_y && pixel_y<=305) || (420<=pixel_y && pixel_y<=425));
	 assign wall_5_on= wall_5_XL<=pixel_x && pixel_x<=wall_5_XR && !( (120<=pixel_y && pixel_y<=125) || (240<=pixel_y && pixel_y<=245) || (360<=pixel_y && pixel_y<=365)); 
	 assign bar_on= bar_XL<=pixel_x && pixel_x<=bar_XR && bar_top_q<=pixel_y && pixel_y<=(bar_top_q+bar_LENGTH);
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
	 
	 
	 //logic for movable bar and self-bouncing ball
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			bar_top_q<=220;
			ball_x_q<=280;
			ball_y_q<=200;
			ball_xdelta_q<=1;
			ball_xdelta_q<=1;
			wall_q<=5'b111_11;
			hold_q<=0;
		end
		else begin
			bar_top_q<=bar_top_d;
			ball_x_q<=ball_x_d;
			ball_y_q<=ball_y_d;
			ball_xdelta_q<=ball_xdelta_d;
			ball_ydelta_q<=ball_ydelta_d;
			wall_q<=wall_d;
			hold_q<=hold_d;
		end
	 end
	 always @* begin
		bar_top_d=bar_top_q;
		ball_x_d=ball_x_q;
		ball_y_d=ball_y_q;
		ball_xdelta_d=ball_xdelta_q;
		ball_ydelta_d=ball_ydelta_q;
		wall_d=wall_q;
		hold_d=hold_q;
		miss=0;
		won=0;
		//midgame-pause or newgame-restart
		if(pause || restart) begin
			ball_x_d=160;
			ball_y_d=240;
			bar_top_d=200;
			ball_xdelta_d=1;
			ball_ydelta_d=0;
			if(restart) wall_d=5'b111_11; //the 5 walls are restored
		end
		
		else if(pixel_y==500 && pixel_x==0) begin//1 tick when video is surely off
			//bar movement logic
			if(!key[0] && bar_top_q>bar_V) bar_top_d=bar_top_q-bar_V; //move bar up
			else if(!key[1] && bar_top_q<(480-bar_LENGTH)) bar_top_d=bar_top_q+bar_V; //move bar down
			
			//bouncing ball logic
			if(ball_x_q<=wall_5_XR) begin
				if(!hold_q && ball_xdelta_q==0) begin
					case(wall_q)
						5'b111_11: if(ball_x_q<=wall_5_XR)begin	
												ball_xdelta_d=1; //bounce from wall 5
												wall_d=wall_q<<1;
												hold_d=1;
									  end
						5'b111_10: if(ball_x_q<=wall_4_XR)begin
											ball_xdelta_d=1; //bounce from wall 4
											wall_d=wall_q<<1;
											hold_d=1;
									  end
						5'b111_00: if(ball_x_q<=wall_3_XR) begin
											ball_xdelta_d=1; //bounce from wall 3
											wall_d=wall_q<<1;
											hold_d=1;
									  end
						5'b110_00: if(ball_x_q<=wall_2_XR) begin
											ball_xdelta_d=1; //bounce from wall 4
											wall_d=wall_q<<1;
											hold_d=1;
									  end
						5'b100_00: if(ball_x_q<=wall_1_XR) begin
											ball_xdelta_d=1; //bounce from wall 4
											wall_d=wall_q<<1;
											hold_d=1;
									  end
					endcase

				end
			end
			else hold_d=0;
			
			if(ball_x_q>=640 && ball_xdelta_q) miss=1; //ball that went past the right border and moving rightward implies that the player misses the ball
			else if(ball_x_q>=640 && !ball_xdelta_q) won=1; //ball that went past the right border and moving leftward implies that the ball wrap around 
																					//after the player broke all th walls, thus player won
			
			if( (bar_XL<=(ball_x_q+ball_DIAM) && (ball_x_q+ball_DIAM)<=bar_XR && bar_top_q<=(ball_y_q+ball_DIAM)) && ball_y_q<=(bar_top_q+bar_LENGTH)) ball_xdelta_d=0; //bounce from bar
			if(ball_y_q<=5) ball_ydelta_d=1; //bounce from top
			else if(480<=(ball_y_q+ball_DIAM)) ball_ydelta_d=0; //bounce from bottom
			
			ball_x_d=ball_xdelta_d? (ball_x_q+ball_V):(ball_x_q-ball_V);
			ball_y_d=ball_ydelta_d? (ball_y_q+ball_V):(ball_y_q-ball_V);
			
		end
	 end
	 
	 assign graph_on=	 (wall_1_on && wall_q[4]) || (wall_2_on && wall_q[3]) || (wall_3_on && wall_q[2]) || (wall_4_on && wall_q[1]) || (wall_5_on && wall_q[0]) || bar_on || ball_on;
	 //overall display logic
	always @* begin
	 	rgb=0;
		if(video_on) begin
			if(wall_1_on && wall_q[4]) rgb=3'b100;
			else if(wall_2_on && wall_q[3]) rgb=3'b101;
			else if(wall_3_on && wall_q[2]) rgb=3'b001;
			else if(wall_4_on && wall_q[1]) rgb=3'b010;
			else if(wall_5_on && wall_q[0]) rgb=3'b111;
			else if(bar_on) rgb=3'b010;
			else if(ball_on) rgb=3'b000;
			else rgb=3'b011; //background color
		end
	 end
					
endmodule

