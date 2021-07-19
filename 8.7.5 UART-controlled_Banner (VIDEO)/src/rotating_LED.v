`timescale 1ns / 1ps

module rotating_LED
	#(parameter turns=25_000_000) ///Frequency will be 50MHz/turns = 50MHz/15M = 3.33Hz(0.3 sec per move)
	(
	input clk,rst_n,
	input rx,
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
	  reg[5*W-1:0] words_nxt;
	  reg en=0,en_nxt;
	  reg dir=0,dir_nxt;
	  reg rd_uart;
	  wire mod_turns_max;
	  wire rx_empty;
	  wire[7:0] rd_data;
	  wire[24:0] mod_turns_nxt;
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
				en<=en_nxt;
				dir<=dir_nxt;
				if(en) begin
					mod_turns<=mod_turns_nxt;
					words<=words_nxt;
			   end	
			end
			
	  end
	  //next-state logics
	  assign mod_turns_nxt=(mod_turns==turns)?0:mod_turns+1;
	  assign mod_turns_max=(mod_turns==turns)?1:0;
	
	  always @* begin
		  rd_uart=0;
		  en_nxt=en;
		  dir_nxt=dir;
		  words_nxt=words;
		  
		  if(mod_turns_max) words_nxt=(!dir)? {words[5*W-6:0],words[5*W-1:5*W-5]}  :  {words[4:0],words[5*W-1:5]} ;  //if dir is not asserted: move left , else:move right
		  
		  //UART-logic when accepting ASCII numbers to be added to the banner
		  if(!rx_empty) begin
				if(rd_data[7:4]==4'h3)  words_nxt={{1'b0,rd_data[3:0]},words[5*W-1:5]};  //new number to be added at the banner
				else if(rd_data==8'h47 || rd_data==8'h67) en_nxt=1;  //"g" or "G" for play
				else if(rd_data==8'h50 || rd_data==8'h70) en_nxt=0;  //"p" or "P" for pause
				else if(rd_data==8'h44 || rd_data==8'h64) dir_nxt=!dir; //"d" or "D" to reverse the direction of rotation
				rd_uart=1;
			end
	  end
	  
	  //output logic to be be used by the LED Multiplexing circuit (6 5-bit outputs that determine what number will be displayed on the sevensegments)
	  assign in5=words[5*W-1:5*W-5],
				in4=words[5*W-6:5*W-10],
				in3=words[5*W-11:5*W-15],
				in2=words[5*W-16:5*W-20],
				in1=words[5*W-21:5*W-25],
				in0=words[5*W-26:5*W-30];
				
	
	uart #(.DBIT(8),.SB_TICK(16),.DVSR(326),.DVSR_WIDTH(9),.FIFO_W(2)) m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.rd_uart(rd_uart),
		.rx(rx),
		.rd_data(rd_data),
		.rx_empty(rx_empty)
    );		
				
				
endmodule
