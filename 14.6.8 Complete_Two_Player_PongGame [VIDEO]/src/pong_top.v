`timescale 1ns / 1ps

module pong_top(
	input clk, rst_n,
	input[3:0] key, //key[1:0] for player 1,key[3:2] for player 2
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
	wire[2:0] graph_on;
	wire[5:0] text_on;
	wire miss1,miss2;
	wire[2:0] rgb_graph,rgb_text;
	reg[2:0] rgb;
	reg[1:0] state_q,state_d;
	reg stop;
	wire[2:0] winner;
	reg[2:0] score1_q=0,score1_d,score2_q=0,score2_d;
	reg[2:0] ball_q=0,ball_d;
	reg timer_start;
	wire timer_tick,timer_up;
	
	//register operation for updating scores and the balls left
	always @(posedge clk_out,negedge rst_n) begin
		if(!rst_n) begin
			state_q<=0;
			ball_q<=0;
			score1_q<=0;
			score2_q<=0;
		end
		else begin
			state_q<=state_d;
			ball_q<=ball_d;
			score1_q<=score1_d;
			score2_q<=score2_d;
		end
	end
	
	//FSM next-state logic
	always @* begin
		state_d=state_q;
		ball_d=ball_q;
		score1_d=score1_q;
		score2_d=score2_q;
		stop=1;
		timer_start=0;
			case(state_q)
				newgame: begin //all scores back to zero and 3 balls will be restored
								ball_d=3;
								score1_d=0;
								score2_d=0;
								if(key!=4'b1111) begin //only when any of the button is pressed will the game start
									ball_d=ball_q-1;
									state_d=play;   
								end
							end
				   play: begin //start of game
								stop=0;
								if(miss1 ||miss2) begin
									if(miss1) score2_d=score2_q+1; //player 2 score increases if player 1 misses
									else score1_d=score1_q+1; ////player 1 score increases if player 2 misses
									ball_d= (ball_q==0)? 0:ball_q-1;
									timer_start=1;
									if(ball_q==0) state_d=over;
									else state_d=newball;
								end
							end
				newball: begin //when any of the player misses, 2 seconds will be alloted before the game can start again
								if(timer_up && key!=4'b1111) state_d=play;
							end
				   over: begin
								if(timer_up) state_d=newgame; //displayes who is the winner
							end
				default: state_d=newgame;
			endcase
	end
	

	
	//rgb multiplexing 
	always @* begin
		rgb=0;
		if(!video_on) rgb=0;
		else begin
			if(text_on[5] || text_on[4] || (text_on[3] && state_q==newgame) || (text_on[2]&& state_q==over) || text_on[0]) rgb=rgb_text; //{score1_on,score2_on,rule_on,win_on,logo_on,ball_on};
			else if(graph_on) rgb=rgb_graph; //{bar_1_on,bar_2_on,ball_on};
			else if(text_on[1]) rgb=rgb_text; //logo is at the last hierarchy since this must be the most underneath text
			else rgb=3'b011; //background			
		end
	end
	
	assign vga_out_r={5{rgb[2]}};
	assign vga_out_g={6{rgb[1]}};
	assign vga_out_b={5{rgb[0]}};
	
	assign timer_tick= (pixel_x==0 && pixel_y==500); //60Hz timer tick, this will be used on making a 2 second tick
	assign winner=(score1_q>score2_q)? 1:2;
	
	
	
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
		.stop(stop), //return to default screen with no motion
		.key(key), //key[1:0] for player 1 and key[3:2] for player 2
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.rgb(rgb_graph),
		.graph_on(graph_on),
		.miss1(miss1),
		.miss2(miss2) //miss1=player 1 misses  , miss2=player2 misses
    );
	 
	 
	 pong_text m3 //control logic for any text on the game
	(
		.clk(clk_out),
		.rst_n(rst_n),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.winner(winner),
		.score1(score1_q),
		.score2(score2_q),
		.ball(ball_q),
		.rgb_text(rgb_text), 
		.rgb_on(text_on) //{score_on,rule_on,gameover_on,logo_on}
    );
	 
	 timer m4 //2 second timer which will be used for "resting" of players before restarting the game
	 (
		.clk(clk_out),
		.rst_n(rst_n),
		.timer_start(timer_start),
		.timer_tick(timer_tick),
		.timer_up(timer_up)
    );


endmodule
