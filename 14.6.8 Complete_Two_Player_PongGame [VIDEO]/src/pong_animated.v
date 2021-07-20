`timescale 1ns / 1ps

module pong_animated
	(
		input clk,rst_n,
		input video_on,
		input stop, //return to default screen with no motion
		input[3:0] key, //key[1:0] for player 1 and key[3:2] for player 2
		input[11:0] pixel_x,pixel_y,
		output reg[2:0] rgb,
		output[2:0] graph_on,
		output reg miss1,miss2 //miss1=player 1 misses  , miss2=player2 misses
    );	
	 localparam bar_1_XL=100, //left bar player 1
					bar_1_XR=105, //right bar player 1

					
					bar_2_XL=550, //left bar player 2
					bar_2_XR=555, //right bar player 2
					
					bar_LENGTH=80, //bar length
					bar_V=10, //bar velocity
					
					ball_DIAM=7, //ball diameter minus one
					ball_V=5; //ball velocity

					
	 wire bar_1_on,bar_2_on,ball_box;
	 reg ball_on;
	 reg[2:0] rom_addr; //rom for circular pattern of ball
	 reg[7:0] rom_data;
	 reg[9:0] bar_1_top_q=220,bar_1_top_d; //stores upper Y value of bar_1,controlled by key[0] and key[1]
	 reg[9:0] bar_2_top_q=220,bar_2_top_d; //stores upper Y value of bar_2,controlled by key[2] and key[3]
	 reg[9:0] ball_x_q=280,ball_x_d; //stores left X value of the bouncing ball
	 reg[9:0] ball_y_q=200,ball_y_d; //stores upper Y value of the bouncing ball
	 reg ball_xdelta_q=0,ball_xdelta_d;
	 reg ball_ydelta_q=0,ball_ydelta_d;
	 
	 //display conditions
	 assign bar_1_on= bar_1_XL<=pixel_x && pixel_x<=bar_1_XR && bar_1_top_q<=pixel_y && pixel_y<=(bar_1_top_q+bar_LENGTH);
	 assign bar_2_on= bar_2_XL<=pixel_x && pixel_x<=bar_2_XR && bar_2_top_q<=pixel_y && pixel_y<=(bar_2_top_q+bar_LENGTH);
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
			bar_1_top_q<=220;
			bar_2_top_q<=220;
			ball_x_q<=280;
			ball_y_q<=200;
			ball_xdelta_q<=0;
			ball_xdelta_q<=0;
		end
		else begin
			bar_1_top_q<=bar_1_top_d;
			bar_2_top_q<=bar_2_top_d;
			ball_x_q<=ball_x_d;
			ball_y_q<=ball_y_d;
			ball_xdelta_q<=ball_xdelta_d;
			ball_ydelta_q<=ball_ydelta_d;
		end
	 end
	 always @* begin
		bar_1_top_d=bar_1_top_q;
		bar_2_top_d=bar_2_top_q;
		ball_x_d=ball_x_q;
		ball_y_d=ball_y_q;
		ball_xdelta_d=ball_xdelta_q;
		ball_ydelta_d=ball_ydelta_q;
		miss1=0;
		miss2=0;
		
		if(stop) begin
			ball_x_d=(640/2); //ball @ center of screen
			ball_y_d=(480/2); //ball @ center of screen
			ball_xdelta_d=0;
			ball_ydelta_d=1;
			bar_1_top_d=200; //bar @ center
			bar_2_top_d=200; //bar @ center
		end
		
		else if(pixel_y==500 && pixel_x==0) begin//1 tick when video is surely off
		
			//bar movement logic
			if(!key[0] && bar_1_top_q>bar_V) bar_1_top_d=bar_1_top_q-bar_V; //move bar_1 up
			else if(!key[1] && bar_1_top_q<(480-bar_LENGTH)) bar_1_top_d=bar_1_top_q+bar_V; //move bar_1 down
			if(!key[2] && bar_2_top_q>bar_V) bar_2_top_d=bar_2_top_q-bar_V; //move bar_2 up
			else if(!key[3] && bar_2_top_q<(480-bar_LENGTH)) bar_2_top_d=bar_2_top_q+bar_V; //move bar_2 down
			
			
			
			//bouncing ball logic
			if( ball_x_q<=bar_1_XR && bar_1_XL<=ball_x_q && bar_1_top_q<=(ball_y_q+ball_DIAM) && ball_y_q<=(bar_1_top_q+bar_LENGTH)) ball_xdelta_d=1; //bounce from bar_1(left)
			else if( (bar_2_XL<=(ball_x_q+ball_DIAM) && ((ball_x_q+ball_DIAM)<=bar_2_XR) && bar_2_top_q<=(ball_y_q+ball_DIAM)) && ball_y_q<=(bar_2_top_q+bar_LENGTH)) ball_xdelta_d=0; //bounce from bar_2(right)
			if(ball_y_q<=5) ball_ydelta_d=1; //bounce from top
			else if(480<=(ball_y_q+ball_DIAM)) ball_ydelta_d=0; //bounce from bottom
			
			//if any player misses
			if(ball_x_q>640) begin
					if(ball_xdelta_q) miss2=1;
					else miss1=1;
			end
			
			
			
			ball_x_d=ball_xdelta_d? (ball_x_q+ball_V):(ball_x_q-ball_V);
			ball_y_d=ball_ydelta_d? (ball_y_q+ball_V):(ball_y_q-ball_V);
			
		end
	 end
	 
	 assign graph_on= {bar_1_on,bar_2_on,ball_on};
	 //overall display logic
	always @* begin
	 	rgb=0;
		if(video_on) begin
			if(bar_1_on) rgb=3'b010;
			else if(bar_2_on) rgb=3'b010;
			else if(ball_on) rgb=3'b000;
			else rgb=3'b011;//background color
	
		end
	 end
					
endmodule

