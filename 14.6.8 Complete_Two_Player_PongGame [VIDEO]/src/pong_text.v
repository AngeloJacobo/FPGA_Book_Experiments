`timescale 1ns / 1ps

module pong_text(
	input clk,rst_n,
	input video_on,
	input[9:0] pixel_x,pixel_y,
	input[2:0] winner,
	input[2:0] score1,score2,
	input[2:0] ball,
	output reg[2:0] rgb_text,
	output[5:0] rgb_on
    );
	 
	 reg logo_on,score1_on,score2_on,win_on,rule_on,ball_on;
	 reg[6:0] ascii_code,ascii_code_logo,ascii_code_score1,ascii_code_score2,ascii_code_win,ascii_code_rule,ascii_code_ball;
	 reg[3:0] row_addr,row_addr_logo,row_addr_score1,row_addr_score2,row_addr_win,row_addr_rule,row_addr_ball;
	 wire[7:0] row_data;
	 reg[2:0] bit_column,bit_column_logo,bit_column_score1,bit_column_score2,bit_column_win,bit_column_rule,bit_column_ball;
	 reg[4:0] col_temp;
	 
	 

	 //control logic for all text on the game
	 always @* begin
		 logo_on=0;
		 score1_on=0;
		 score2_on=0;
		 win_on=0;
		 rule_on=0;
		 ball_on=0;
		 col_temp=0;
		 row_addr_logo=0;
		 row_addr_score1=0;
		 row_addr_score2=0;
		 row_addr_win=0;
		 row_addr_rule=0;
		 row_addr_ball=0;
		 bit_column_logo=0;
		 bit_column_score1=0;
		 bit_column_score2=0;
		 bit_column_win=0;
		 bit_column_rule=0;
		 bit_column_ball=0;
		 ascii_code_logo=0;
		 ascii_code_score1=0;
		 ascii_code_score2=0;
		 ascii_code_win=0;
		 ascii_code_rule=0;
		 ascii_code_ball=0;
		 
			//logo text logic (64x128 char size)
			logo_on= (pixel_x[9:6]>=3 && pixel_x[9:6]<=6 && pixel_y[8:7]==2);
			row_addr_logo=pixel_y[6:3];
			bit_column_logo=pixel_x[5:3];
			case(pixel_x[9:6])
				4'd3: ascii_code_logo=7'h50; //P
				4'd4: ascii_code_logo=7'h4f; //O
				4'd5: ascii_code_logo=7'h4e; //N
				4'd6: ascii_code_logo=7'h47; //G
			endcase
			
			//PLAYER 1 score text logic(16x32 char size)
			score1_on =(pixel_x[9:8]==0 && pixel_y[8:5]==0);
			row_addr_score1=pixel_y[4:1];
			bit_column_score1=pixel_x[3:1];
			case(pixel_x[7:4])
				4'h0: ascii_code_score1=0; //
				4'h1: ascii_code_score1=8'h50; //P
				4'h2: ascii_code_score1=8'h4c; //L
				4'h3: ascii_code_score1=8'h41; //A
				4'h4: ascii_code_score1=8'h59; //Y
				4'h5: ascii_code_score1=8'h45; //E
				4'h6: ascii_code_score1=8'h52; //R
				4'h7: ascii_code_score1=8'h31; //1
				4'h8: ascii_code_score1=0; //
				4'h9: ascii_code_score1=8'h53; //S
				4'ha: ascii_code_score1=8'h43; //C
				4'hb: ascii_code_score1=8'h4f; //O
				4'hc: ascii_code_score1=8'h52; //R
				4'hd: ascii_code_score1=8'h45; //E
				4'he: ascii_code_score1=8'h3a; //:
				4'hf: ascii_code_score1={4'b0110,score1}; //player 1 score
			endcase

			//PLAYER 2 score text logic(16x32 char size)
			score2_on =( pixel_x[9:4]>=24 && pixel_x[9:4]<=39 && pixel_y[8:5]==0);
			row_addr_score2=pixel_y[4:1];
			bit_column_score2=pixel_x[3:1];
			case(pixel_x[9:4])
				6'd24: ascii_code_score2=8'h50; //P
				6'd25: ascii_code_score2=8'h4c; //L
				6'd26: ascii_code_score2=8'h41; //A
				6'd27: ascii_code_score2=8'h59; //Y
				6'd28: ascii_code_score2=8'h45; //E
				6'd29: ascii_code_score2=8'h52; //R
				6'd30: ascii_code_score2=8'h32; //2
				6'd31: ascii_code_score2=0; //
				6'd32: ascii_code_score2=8'h53; //S
				6'd33: ascii_code_score2=8'h43; //C
				6'd34: ascii_code_score2=8'h4f; //O
				6'd35: ascii_code_score2=8'h52; //R
				6'd36: ascii_code_score2=8'h45; //E
				6'd37: ascii_code_score2=8'h3a; //:
				6'd38: ascii_code_score2={4'b0110,score2}; //player 2 score
				6'd39: ascii_code_score2=0; //
			endcase	
			
			//Game Winner text logic(32x64 char size)
			win_on= (pixel_y[8:6]==3 && pixel_x[9:5]>=4 && pixel_x[9:5]<=15);
			row_addr_win=pixel_y[5:2];
			bit_column_win=pixel_x[4:2];
			case(pixel_x[9:5]) 
				5'h04: ascii_code_win=8'h50;//P
				5'h05: ascii_code_win=8'h4c;//L
				5'h06: ascii_code_win=8'h41;//A
				5'h07: ascii_code_win=8'h59;//Y
				5'h08: ascii_code_win=8'h45;//E
				5'h09: ascii_code_win=8'h52;//R
				5'h0a: ascii_code_win={4'b0110,winner};//winner
				5'h0b: ascii_code_win=0;//
				5'h0c: ascii_code_win=8'h57;//W
				5'h0d: ascii_code_win=8'h49;//I
				5'h0e: ascii_code_win=8'h4e;//N
				5'h0f: ascii_code_win=8'h53;//S
			endcase
			
			//Ball-left text logic(32x64 char size)
			ball_on= (pixel_y[8:6]==0 && pixel_x[9:0]>=304 && pixel_x[9:0]<=335);
			row_addr_ball=pixel_y[5:2];
			col_temp=pixel_x[9:0]-304;
			bit_column_ball=col_temp[4:2];
			if(ball_on) ascii_code_ball={4'b0110,ball};//ball-left

			
			//rule text logic(8x16 char size)
			rule_on= (pixel_x[9:7]==2 && pixel_y[8:6]==2);
			row_addr_rule=pixel_y[3:0];
			bit_column_rule=pixel_x[2:0];
			case({pixel_y[5:4],pixel_x[6:3]})
				6'h00: ascii_code_rule=8'h52; //R
				6'h01: ascii_code_rule=8'h75; //u
				6'h02: ascii_code_rule=8'h6c; //l
				6'h03: ascii_code_rule=8'h65; //e
				6'h04: ascii_code_rule=8'h3a; //: 
				6'h05: ascii_code_rule=0; //
				6'h06: ascii_code_rule=0; //
				6'h07: ascii_code_rule=0; //
				6'h08: ascii_code_rule=0; //
				6'h09: ascii_code_rule=0; //
				6'h0a: ascii_code_rule=0; //
				6'h0b: ascii_code_rule=0; //
				6'h0c: ascii_code_rule=0; //
				6'h0d: ascii_code_rule=0; //
				6'h0e: ascii_code_rule=0; //
				6'h0f: ascii_code_rule=0; //
				
				6'h10: ascii_code_rule=8'h55; //U
				6'h11: ascii_code_rule=8'h73; //s
				6'h12: ascii_code_rule=8'h65; //e
				6'h13: ascii_code_rule=0; //
				6'h14: ascii_code_rule=8'h74; //t
				6'h15: ascii_code_rule=8'h77; //w
				6'h16: ascii_code_rule=8'h6f; //o
				6'h17: ascii_code_rule=0; //
				6'h18: ascii_code_rule=8'h62; //b
				6'h19: ascii_code_rule=8'h75; //u
				6'h1a: ascii_code_rule=8'h74; //t
				6'h1b: ascii_code_rule=8'h74; //t
				6'h1c: ascii_code_rule=8'h6f; //o
				6'h1d: ascii_code_rule=8'h6e; //n
				6'h1e: ascii_code_rule=8'h73; //s
				6'h1f: ascii_code_rule=0; //
				
				6'h20: ascii_code_rule=8'h74; //t
				6'h21: ascii_code_rule=8'h6f; //o
				6'h22: ascii_code_rule=0; //
				6'h23: ascii_code_rule=8'h6d; //m
				6'h24: ascii_code_rule=8'h6f; //o
				6'h25: ascii_code_rule=8'h76; //v
				6'h26: ascii_code_rule=8'h65; //e
				6'h27: ascii_code_rule=0; //
				6'h28: ascii_code_rule=8'h70; //p
				6'h29: ascii_code_rule=8'h61; //a
				6'h2a: ascii_code_rule=8'h64; //d
				6'h2b: ascii_code_rule=8'h64; //d
				6'h2c: ascii_code_rule=8'h6c; //l
				6'h2d: ascii_code_rule=8'h65; //e
				6'h2e: ascii_code_rule=0; //
				6'h2f: ascii_code_rule=0; //
				
				6'h30: ascii_code_rule=8'h75; //u
				6'h31: ascii_code_rule=8'h70; //p
				6'h32: ascii_code_rule=0; //
				6'h33: ascii_code_rule=8'h61; //a
				6'h34: ascii_code_rule=8'h6e; //n
				6'h35: ascii_code_rule=8'h64; //d
				6'h36: ascii_code_rule=0; //
				6'h37: ascii_code_rule=8'h64; //d
				6'h38: ascii_code_rule=8'h6f; //o
				6'h39: ascii_code_rule=8'h77; //w
				6'h3a: ascii_code_rule=8'h6e; //n
				6'h3b: ascii_code_rule=0; //
				6'h3c: ascii_code_rule=0; //
				6'h3d: ascii_code_rule=0; //
				6'h3e: ascii_code_rule=0; //
				6'h3f: ascii_code_rule=0; //	
			endcase
		
	 end
	 
	 
	 
	 //rgb multiplexing
	 always @* begin
		rgb_text=0;
		row_addr=0;
		bit_column=0;
		ascii_code=0;
		rgb_text=3'b011; //background
		if(!video_on) rgb_text=0;
		else if(ball_on) begin
			rgb_text=font_bit? 3'b100:rgb_text; //ball left text color
			row_addr=row_addr_ball;
			bit_column=bit_column_ball;
			ascii_code=ascii_code_ball;
		end
		else if(score1_on) begin
			rgb_text=font_bit? 3'b001:rgb_text; //player 1 score text color
			row_addr=row_addr_score1;
			bit_column=bit_column_score1;
			ascii_code=ascii_code_score1;
		end
		else if(score2_on) begin
			rgb_text=font_bit? 3'b001:rgb_text; //player 2 score text color
			row_addr=row_addr_score2;
			bit_column=bit_column_score2;
			ascii_code=ascii_code_score2;
		end
		
		else if(rule_on) begin
			rgb_text=font_bit? 3'b000:rgb_text; //rule text color
			row_addr=row_addr_rule;
			bit_column=bit_column_rule;
			ascii_code=ascii_code_rule;
		end
		else if(win_on) begin
			rgb_text=font_bit? 3'b010:rgb_text; //game winner text color
			row_addr=row_addr_win;
			bit_column=bit_column_win;
			ascii_code=ascii_code_win;
		end
		else if(logo_on) begin
			rgb_text=font_bit? 3'b110:rgb_text; //logo text color
			row_addr=row_addr_logo;
			bit_column=bit_column_logo;
			ascii_code=ascii_code_logo;
		end
	end

	 
	 assign font_bit=row_data[~{bit_column-3'd1}];
	 assign rgb_on= {score1_on,score2_on,rule_on,win_on,logo_on,ball_on};
	 
	 //module instantiations
	 font_rom m0
   (
		.clk(clk),
		.addr({ascii_code,row_addr}), //[10:4] for ASCII char code, [3:0] for choosing what row to read on a given character  
		.data(row_data)
   );


endmodule
