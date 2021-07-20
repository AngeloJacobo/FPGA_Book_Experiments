`timescale 1ns / 1ps

module pong_text(
	input clk,rst_n,
	input video_on,
	input won,
	input[9:0] pixel_x,pixel_y,
	input[2:0] ball,
	output reg[2:0] rgb_text,
	output[4:0] text_on
    );
	 
	 reg logo_on,ball_on,gameover_on,rule_on,win_on;
	 reg[6:0] ascii_code,ascii_code_logo,ascii_code_ball,ascii_code_over,ascii_code_rule,ascii_code_win;
	 reg[3:0] row_addr,row_addr_logo,row_addr_ball,row_addr_over,row_addr_rule,row_addr_win;
	 wire[7:0] row_data;
	 reg[2:0] bit_column,bit_column_logo,bit_column_ball,bit_column_over,bit_column_rule,bit_column_win;
	 reg[5:0] bit_column_temp;
	 

	  //control logic for all text on the game
	 always @* begin
		 logo_on=0;
		 ball_on=0;
		 gameover_on=0;
		 rule_on=0;
		 win_on=0;
		 row_addr_logo=0;
		 row_addr_ball=0;
		 row_addr_over=0;
		 row_addr_rule=0;
		 row_addr_win=0;
		 bit_column_logo=0;
		 bit_column_ball=0;
		 bit_column_over=0;
		 bit_column_rule=0;
		 bit_column_win=0;
		 ascii_code_logo=0;
		 ascii_code_ball=0;
		 ascii_code_over=0;
		 ascii_code_rule=0;
		 ascii_code_win=0;
		 bit_column_temp=0;
		 
			//logo text logic (64x128 char size), "BreakOut"
			logo_on= (pixel_x[9:0]>=64 && pixel_x[9:0]<=575 && pixel_y[8:7]==2);
			row_addr_logo=pixel_y[6:3];
			if(pixel_x[9:0]<=127) begin
				ascii_code_logo=8'h42;//B
				bit_column_temp=pixel_x[9:0]-64;
			end
			else if(pixel_x[9:0]<=191) begin
				ascii_code_logo=8'h72 ;//r
				bit_column_temp=pixel_x[9:0]-128;
			end
			else if(pixel_x[9:0]<=255) begin
				ascii_code_logo=8'h65 ;//e
				bit_column_temp=pixel_x[9:0]-192;
			end
			else if(pixel_x[9:0]<=319) begin
				ascii_code_logo=8'h61 ;//a
				bit_column_temp=pixel_x[9:0]-256;
			end
			else if(pixel_x[9:0]<=383) begin
				ascii_code_logo=8'h6b ;//k
				bit_column_temp=pixel_x[9:0]-320;
			end
			else if(pixel_x[9:0]<=447) begin
				ascii_code_logo=8'h4f ;//O
				bit_column_temp=pixel_x[9:0]-384;
			end
			else if(pixel_x[9:0]<=511) begin
				ascii_code_logo=8'h75 ;//u
				bit_column_temp=pixel_x[9:0]-448;
			end
			else if(pixel_x[9:0]<=575) begin
				ascii_code_logo=8'h74 ;//t
				bit_column_temp=pixel_x[9:0]-512;
			end
			bit_column_logo=bit_column_temp[5:3];

			
			//ball text logic(16x32 char size) , "BALL:_"
			ball_on =(pixel_x[9:7]==2 && pixel_y[8:5]==0);
			row_addr_ball=pixel_y[4:1];
			bit_column_ball=pixel_x[3:1];
			case(pixel_x[6:4])
				3'o0: ascii_code_ball=0; //
				3'o1: ascii_code_ball=8'h42; //B
				3'o2: ascii_code_ball=8'h41; //A
				3'o3: ascii_code_ball=8'h4c; //L
				3'o4: ascii_code_ball=8'h4c; //L
				3'o5: ascii_code_ball=8'h3a; //:
				3'o6: ascii_code_ball={4'b0110,ball}; //ball left
				3'o7: ascii_code_ball=0; //
			endcase		
			
			//gameover text logic(32x64 char size) , "GAME OVER"
			gameover_on= (pixel_y[8:6]==3 && pixel_x[9:5]>=5 && pixel_x[9:5]<=13);
			row_addr_over=pixel_y[5:2];
			bit_column_over=pixel_x[4:2];
			case(pixel_x[9:5]) 
				5'h05: ascii_code_over=8'h47;//G
				5'h06: ascii_code_over=8'h41;//A
				5'h07: ascii_code_over=8'h4d;//M
				5'h08: ascii_code_over=8'h45;//E
				5'h09: ascii_code_over=0;//
				5'h0a: ascii_code_over=8'h4f;//O
				5'h0b: ascii_code_over=8'h56;//V
				5'h0c: ascii_code_over=8'h45;//E
				5'h0d: ascii_code_over=8'h52;//R
			endcase
			
			//win text logic(32x64 char size) ,  "YOU WIN!"
			win_on= (pixel_y[8:6]==3 && pixel_x[9:5]>=6 && pixel_x[9:5]<=13);
			row_addr_win=pixel_y[5:2];
			bit_column_win=pixel_x[4:2];
			case(pixel_x[9:5]) 
				5'h06: ascii_code_win=8'h59;//Y
				5'h07: ascii_code_win=8'h4f;//O
				5'h08: ascii_code_win=8'h55;//U
				5'h09: ascii_code_win=0;//
				5'h0a: ascii_code_win=8'h57;//W
				5'h0b: ascii_code_win=8'h49;//I
				5'h0c: ascii_code_win=8'h4e;//N
				5'h0d: ascii_code_win=8'h21;//!
			endcase
			
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
				
				6'h10: ascii_code_rule=8'h42; //B
				6'h11: ascii_code_rule=8'h6f; //o
				6'h12: ascii_code_rule=8'h75; //u
				6'h13: ascii_code_rule=8'h6e; //n
				6'h14: ascii_code_rule=8'h63; //c
				6'h15: ascii_code_rule=8'h65; //e
				6'h16: ascii_code_rule=0; //
				6'h17: ascii_code_rule=8'h74; //t
				6'h18: ascii_code_rule=8'h68; //h
				6'h19: ascii_code_rule=8'h65; //e
				6'h1a: ascii_code_rule=0; //
				6'h1b: ascii_code_rule=8'h62; //b
				6'h1c: ascii_code_rule=8'h61; //a
				6'h1d: ascii_code_rule=8'h6c; //l
				6'h1e: ascii_code_rule=8'h6c; //l
				6'h1f: ascii_code_rule=0; //
				
				6'h20: ascii_code_rule=8'h62; //b
				6'h21: ascii_code_rule=8'h61; //a
				6'h22: ascii_code_rule=8'h63; //c
				6'h23: ascii_code_rule=8'h6b; //k
				6'h24: ascii_code_rule=0; //
				6'h25: ascii_code_rule=8'h74; //t
				6'h26: ascii_code_rule=8'h6f; //o
				6'h27: ascii_code_rule=0; //
				6'h28: ascii_code_rule=8'h42; //B
				6'h29: ascii_code_rule=8'h52; //R
				6'h2a: ascii_code_rule=8'h45; //E
				6'h2b: ascii_code_rule=8'h41; //A
				6'h2c: ascii_code_rule=8'h4b; //K
				6'h2d: ascii_code_rule=0; //
				6'h2e: ascii_code_rule=0; //
				6'h2f: ascii_code_rule=0; //
				
				6'h30: ascii_code_rule=8'h64; //d
				6'h31: ascii_code_rule=8'h6f; //o
				6'h32: ascii_code_rule=8'h77; //w
				6'h33: ascii_code_rule=8'h6e; //n
				6'h34: ascii_code_rule=0; //
				6'h35: ascii_code_rule=8'h74; //t
				6'h36: ascii_code_rule=8'h68; //h
				6'h37: ascii_code_rule=8'h65; //e
				6'h38: ascii_code_rule=0; //
				6'h39: ascii_code_rule=8'h77; //w
				6'h3a: ascii_code_rule=8'h61; //a
				6'h3b: ascii_code_rule=8'h6c; //l
				6'h3c: ascii_code_rule=8'h6c; //l
				6'h3d: ascii_code_rule=8'h73; //s
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
			rgb_text=font_bit? 3'b001:rgb_text; //score text color
			row_addr=row_addr_ball;
			bit_column=bit_column_ball;
			ascii_code=ascii_code_ball;
		end
		else if(rule_on) begin
			rgb_text=font_bit? 3'b000:rgb_text; //rule text color
			row_addr=row_addr_rule;
			bit_column=bit_column_rule;
			ascii_code=ascii_code_rule;
		end
		else if(win_on && won) begin
			rgb_text=font_bit? 3'b010:rgb_text; //gameover text color
			row_addr=row_addr_win;
			bit_column=bit_column_win;
			ascii_code=ascii_code_win;
		end
		else if(gameover_on && !won) begin
			rgb_text=font_bit? 3'b010:rgb_text; //gameover text color
			row_addr=row_addr_over;
			bit_column=bit_column_over;
			ascii_code=ascii_code_over;
		end
		else if(logo_on) begin
			rgb_text=font_bit? 3'b110:rgb_text; //logo text color
			row_addr=row_addr_logo;
			bit_column=bit_column_logo;
			ascii_code=ascii_code_logo;
		end
	end

	 
	 assign font_bit=row_data[~{bit_column-3'd1}];
	 assign text_on= {ball_on,rule_on,gameover_on,win_on,logo_on};
	 
	 //module instantiations
	 font_rom m0
   (
		.clk(clk),
		.addr({ascii_code,row_addr}), //[10:4] for ASCII char code, [3:0] for choosing what row to read on a given character  
		.data(row_data)
   );


endmodule
