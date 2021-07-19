`timescale 1ns / 1ps

module uart_tx 
	(
		input clk,rst_n,
		input s_tick, tx_start,
		input[7:0] din,
		input[3:0] databits, //either 8 or 7 databits
		input[5:0] stopbits, //either 16 or 32 ticks for 1 and 2 stopbits,respectively
		input [1:0] paritybit, //0-no parity, 1=odd parity , 2=even parity
		output reg tx_done_tick,
		output tx
    );
	 //FSM state declarations
	 localparam[2:0] idle=3'd0,
							start=3'd1,
							data=3'd2,
							parity=3'd3,
							stop=3'd4;
	 reg[2:0] state_reg,state_nxt;
	 reg[5:0] s_reg,s_nxt; //count to 16 for every data bit
	 reg[2:0] n_reg,n_nxt; //count the number of data bits already transmitted
	 reg[7:0] din_reg,din_nxt; //stores the word to be transmitted
	 reg tx_reg,tx_nxt;
	 reg[7:0] din_temp;
	 //FSM register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			s_reg<=0;
			n_reg<=0;
			din_reg<=0;
			tx_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			s_reg<=s_nxt;
			n_reg<=n_nxt;
			din_reg<=din_nxt;
			tx_reg<=tx_nxt;
		end
	 end
	 //FSM next-state logic
	 always @* begin
		 state_nxt=state_reg;
		 s_nxt=s_reg;
		 n_nxt=n_reg;
		 din_nxt=din_reg;
		 tx_nxt=tx_reg;
		 tx_done_tick=0;
		 din_temp=0;
		 case(state_reg)
				idle: begin //wait for the buffer to have at least one word stored
							tx_nxt=1;
							if(tx_start==0) begin //tx_start is  connected to the inverted empty port of fifo buffer
								din_nxt=din;

								s_nxt=0;
								state_nxt=start;
							end
						end
			  start: begin   //wait to finish the start bit
							tx_nxt=0;
							if(s_tick==1) begin
								if(s_reg==15) begin
									s_nxt=0;
									n_nxt=0;
									state_nxt=data;
								end
								else s_nxt=s_reg+1;
							end
						end
				data: begin  //wait for all data bits to be transmitted serially
							tx_nxt=din_reg[0];
							if(s_tick==1) begin
								if(s_reg==15) begin
									din_nxt=din_reg>>1;
									s_nxt=0;
									if(n_reg==databits-1) state_nxt=parity;
									else n_nxt=n_reg+1;
								end
								else s_nxt=s_reg+1;
							end
						end
						
				parity: begin
							if(paritybit==0) state_nxt=stop;
							else begin
								din_temp=(databits==8)? din : din[6:0];
								tx_nxt=(paritybit==1)? {!{^din_temp}} : {^din_temp};
								if(s_tick==1) begin
									if(s_reg==15) begin
										state_nxt=stop;
										s_nxt=0;
									end
									else s_nxt=s_reg+1;
								end
							end
							
						  end
				
				stop: begin  //wait to finish the stop bit
							tx_nxt=1;
							if(s_tick==1) begin
								if(s_reg==stopbits-1) begin
									tx_done_tick=1;
									state_nxt=idle;
								end
								else s_nxt=s_reg+1;
							end
						end
			default: state_nxt=idle;
		 endcase
	 end
	 assign tx=tx_reg;
	 
	 
 


endmodule
