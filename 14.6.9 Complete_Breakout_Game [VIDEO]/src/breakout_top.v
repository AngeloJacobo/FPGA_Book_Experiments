`timescale 1ns / 1ps

module breakout_top(
	input clk, rst_n,
	input[1:0] key, //move the paddle
	output[4:0] vga_out_r,
	output[5:0] vga_out_g,
	output[4:0] vga_out_b,
	output vga_out_vs,vga_out_hs
    );
	 
	 //FSM for the whole pong game
	 localparam[1:0] newgame=0,
							play=1,
							newball=2,
							over=3;
	wire clk_out;
	wire video_on;
	wire[11:0] pixel_x,pixel_y;
	wire graph_on;
	wire[4:0] text_on;
	wire miss,won;
	reg won_q,won_d;
	wire[2:0] rgb_graph,rgb_text;
	reg[2:0] rgb;
	reg[1:0] state_q,state_d;
	reg pause,restart;
	reg[2:0] ball_q=0,ball_d;
	reg timer_start;
	wire timer_tick,timer_up;
	
	//register operation for updating balls left and the current state of game
	always @(posedge clk_out,negedge rst_n) begin
		if(!rst_n) begin
			state_q<=0;
			ball_q<=0;
			won_q<=0;
		end
		else begin
			state_q<=state_d;
			ball_q<=ball_d;
			won_q<=won_d;
		end
	end
	
	//FSM next-state logic
	always @* begin
		state_d=state_q;
		ball_d=ball_q;
		pause=0;
		restart=0;
		timer_start=0;
		won_d=won_q;
			case(state_q)
				newgame: begin 
								restart=1; //3 balls will be restored at the start 
								ball_d=3;
								won_d=0;
								if(key!=2'b11) begin //only when any of the button is pressed will the game start
									ball_d=ball_q-1;
									state_d=play;   
								end
							end
				   play: if(miss || won) begin //game continues until the player misses the ball or the ball went past through the left border(all walls broken)
									won_d=won;
									if(miss) ball_d= (ball_q==0)? 0:ball_q-1;
									if(ball_q==0 || won) state_d=over;
									else state_d=newball;
									timer_start=1;
							end
				newball: begin  //after the player misses, 2 seconds will be alloted before the game can start again(as long as there are still balls left)
								pause=1;
								if(timer_up && key!=2'b11) state_d=play;
							end
				   over: begin
								pause=1;
								if(timer_up) state_d=newgame;
							end
				default: state_d=newgame;
			endcase
	end
	

	
	//rgb multiplexing 
	always @* begin
		rgb=0;
		if(!video_on) rgb=0;
		else begin
			if(text_on[4] || (text_on[3] && state_q==newgame) || (text_on[2]&& state_q==over)) rgb=rgb_text; //{ball_on,rule_on,gameover_on,win_on,logo_on};
			else if(graph_on) rgb=rgb_graph; 
			else if(text_on[0]) rgb=rgb_text; //logo is at the last hierarchy since this must be the most underneath text
			else rgb=3'b011; //background			
		end
	end
	
	assign vga_out_r={5{rgb[2]}};
	assign vga_out_g={6{rgb[1]}};
	assign vga_out_b={5{rgb[0]}};
	
	assign timer_tick= (pixel_x==0 && pixel_y==500);
	
	
	
	dcm_25MHz m0
   (// Clock in ports
		 .clk(clk),      // IN
		 // Clock out ports
		 .clk_out(clk_out),     // OUT
		 // Status and control signals
		 .RESET(RESET),// IN
		 .LOCKED(LOCKED)
	 );
	 vga_core m1
	(
		.clk(clk_out),
		.rst_n(rst_n), //clock must be 25MHz for 640x480 
		.hsync(vga_out_hs),
		.vsync(vga_out_vs),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y)
    );
	 
	 
	 pong_animated m2 //control logic for any graphs on the game
	(
		.clk(clk_out),
		.rst_n(rst_n),
		.video_on(video_on),
		.pause(pause),   //pause=stop state after missing a ball , restart=stop state at the beginning of new game
		.restart(restart), 
		.key(key), 
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.rgb(rgb_graph),
		.graph_on(graph_on),
		.miss(miss),  //miss=ball went past the paddle , won=when ball went past the left border
		.won(won) 
    );
	 
	 
	 pong_text m3 //control logic for any text on the game
	(
		.clk(clk_out),
		.rst_n(rst_n),
		.video_on(video_on),
		.won(won_q),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.ball(ball_q),
		.rgb_text(rgb_text), 
		.text_on(text_on) //{score_on,rule_on,gameover_on,logo_on}
    );
	 
	 timer m4 //2 second timer which will be used for "resting" before restarting the game
	 (
		.clk(clk_out),
		.rst_n(rst_n),
		.timer_start(timer_start),
		.timer_tick(timer_tick),
		.timer_up(timer_up)
    );


endmodule
