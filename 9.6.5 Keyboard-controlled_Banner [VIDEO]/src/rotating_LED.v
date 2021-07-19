`timescale 1ns / 1ps

module rotating_LED
	#(parameter turns=15_000_000) ///Frequency will be 50MHz/turns = 50MHz/15M = 3.33Hz(0.3 sec per move)
	(
	input clk,rst_n,
	input ps2d,ps2c,
	output [4:0] in0,in1,in2,in3,in4,in5 //{decimalpoint,hexadecimal}
    );
	 localparam W=10; //number of all letters/numbers to be displayed
	 
	 reg[24:0] mod_turns=0;
	 reg[5*W-1:0] words={  ////  word=0123456789 
								{1'b0,4'h0},
								{1'b0,4'h1},
								{1'b0,4'h2},
								{1'b0,4'h3},
								{1'b0,4'h4},
								{1'b0,4'h5},
								{1'b0,4'h6},
								{1'b0,4'h7},
								{1'b0,4'h8},
								{1'b0,4'h9}			
								}; //Note: If  "W" is greater than the words initialized here, it will be displayed as default zero on the leftmost digit
	  wire[24:0] mod_turns_nxt;
	  reg[5*W-1:0] words_nxt;
	  wire mod_turns_max;
	  wire fifo_empty;
	  wire[8:0] rd_data;
	  reg rd_fifo;
	  reg en,en_nxt;
	  reg dir,dir_nxt;
	  //registers
	  always @(posedge clk,negedge rst_n) begin
			if(!rst_n) begin
				mod_turns<=0;
				words<={ {1'b0,4'h0},
						  {1'b0,4'h1},
						  {1'b0,4'h2},
						  {1'b0,4'h3},
						  {1'b0,4'h4},
						  {1'b0,4'h5},
						  {1'b0,4'h6},
						  {1'b0,4'h7},
						  {1'b0,4'h8},
						  {1'b0,4'h9}			
						  };
					en<=0;
					dir<=0;
			end
			else begin
				if(en) begin
					mod_turns<=mod_turns_nxt;
					words<=words_nxt;
			   end	
				en<=en_nxt;
				dir<=dir_nxt;
			end
			
	  end
	  //next-state logics
	  assign mod_turns_nxt=(mod_turns==turns)?0:mod_turns+1;
	  assign mod_turns_max=(mod_turns==turns)?1:0;
	
	  always @* begin
		  words_nxt=words;
		  en_nxt=en;
		  dir_nxt=dir;
		  rd_fifo=0;
		  if(mod_turns_max) words_nxt=(!dir)? {words[5*W-6:0],words[5*W-1:5*W-5]}  :  {words[4:0],words[5*W-1:5]} ;  //if dir is not asserted: move left , else:move right
		  if(!fifo_empty) begin
				case(rd_data)
					9'h34: en_nxt=1;//G fo go
					9'h4d: en_nxt=0; //P for pause
					9'h23: dir_nxt=!dir; //D to reverse direction
					9'h45: words_nxt={5'd0,words[5*W-1:5]};//add 0 to banner
					9'h16: words_nxt={5'd1,words[5*W-1:5]}; //add 1 to banner
					9'h1e: words_nxt={5'd2,words[5*W-1:5]}; //add 2 to banner
					9'h26: words_nxt={5'd3,words[5*W-1:5]}; //add 3 to banner
					9'h25: words_nxt={5'd4,words[5*W-1:5]}; //add 4 to banner
					9'h2e: words_nxt={5'd5,words[5*W-1:5]}; //add 5 to banner
					9'h36: words_nxt={5'd6,words[5*W-1:5]}; //add 6 to banner
					9'h3d: words_nxt={5'd7,words[5*W-1:5]}; //add 7 to banner
					9'h3e: words_nxt={5'd8,words[5*W-1:5]}; //add 8 to banner
					9'h46: words_nxt={5'd9,words[5*W-1:5]}; //add 9 to banner
				endcase
				rd_fifo=1;
		  end
	  end
	  
	  //output logic to be be used by the LED Multiplexing circuit (6 5-bit outputs that determine what number will be displayed on the sevensegments)
	  assign in5=words[5*W-1:5*W-5],
				in4=words[5*W-6:5*W-10],
				in3=words[5*W-11:5*W-15],
				in2=words[5*W-16:5*W-20],
				in1=words[5*W-21:5*W-25],
				in0=words[5*W-26:5*W-30];
				
	kb m0
	(   //extract only the real bytes from received packets of data(no break code)
		.clk(clk),
		.rst_n(rst_n),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.rd_fifo(rd_fifo),
		.rd_data(rd_data), //{shift,data}
		.fifo_empty(fifo_empty)
    );
endmodule
