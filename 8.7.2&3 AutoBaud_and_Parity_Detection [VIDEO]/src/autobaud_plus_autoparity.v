`timescale 1ns / 1ps

	module autobaud_plus_autoparity(
	input clk,rst_n,
	input key0,rx,s_tick,
	output[11:0] baud_dvsr,
	output[17:0] baud_rate,
	output reg done_tick,
	output reg[1:0] paritybit
    );
	 
	 //FSM state declarations
	 localparam[2:0]  idle=3'd0,
							zero=3'd1,
							one=3'd2,
							findparity=3'd3,
							secondbyte=3'd4,
							divide=3'd5,
							start=3'd6;
							
							
	 reg[2:0] state_reg,state_nxt;
	 reg[18:0] counter_reg,counter_nxt;
	 reg[18:0] baud_reg,baud_nxt;
	 reg[1:0] index_reg,index_nxt;
	 reg[5:0] s_reg,s_nxt;
	 reg parity0_reg,parity0_nxt,parity1_reg,parity1_nxt;
	 wire key0_tick;
	 reg start_div;
	 wire done_div;
	 
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			counter_reg<=0;
			baud_reg<=0;
			index_reg<=0;
			s_reg<=0;
			parity0_reg<=0;
			parity1_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			counter_reg<=counter_nxt;
			baud_reg<=baud_nxt;
			index_reg<=index_nxt;
			s_reg<=s_nxt;
			parity0_reg<=parity0_nxt;
			parity1_reg<=parity1_nxt;
		end
	 end
	 
	 //FSM next-state logic
	 always @* begin
		state_nxt=state_reg;
		counter_nxt=counter_reg;
		baud_nxt=baud_reg;
		index_nxt=index_reg;
		s_nxt=s_reg;
		parity0_nxt=parity0_reg;
		parity1_nxt=parity1_reg;
		
		done_tick=0;
		start_div=0;
		case(state_reg) 
			   idle: if(rx==0) begin //wait for start bit of 0 for ASCII code of "x"
							counter_nxt=0;
							baud_nxt=0;
							index_nxt=0;
							state_nxt=zero;
						end
			   zero: begin //wait for bit 1 of ASCII code of x = 0001_1110
							counter_nxt=counter_reg+1;
							if(rx==1) state_nxt=one;
						end
			    one: begin //wait for bit 0 to come
							counter_nxt=counter_reg+1;
							if(rx==0) begin
								state_nxt=findparity;
								baud_nxt=counter_reg;
								s_nxt=0;
							end
						end
		findparity: if(s_tick==1) begin //ASCII code is x = 0_0001_1110_p  , 23 ticks from last bit "1" means
							if(s_reg==23) begin			//skipping to the middle bit of parity bit(or stopbit if no parity bit)
								s_nxt=24;
								if(index_reg==0) begin 
									parity0_nxt=rx;  //paritybit for "x" is now recorded at this point
									index_nxt=1;
								end
								else begin
									parity1_nxt=rx;  //paritybit for "p" (which is the second byte)is now recorded at this point
									index_nxt=2;
								end
							end
							else if(s_reg==24) begin
								if(index_reg==2) begin
									start_div=1;
									state_nxt=divide;
								end
								else if(rx==1) state_nxt=secondbyte;
							end
							else s_nxt=s_reg+1;
						end
		secondbyte: if(rx==0) begin //secondbyte to be tested is ASCII of "p"
							counter_nxt=0;
							baud_nxt=0;
							state_nxt=zero;
						end
			 divide: if(done_div==1) begin //use division circuit to find baud rate
							state_nxt=start;
							done_tick=1;
						end
			  start: if(key0_tick==1) state_nxt=idle;
			default: state_nxt=idle;
		endcase
	 end
	 //Computation: Baud_rate=50Mhz*8/x  (note: x is the measured ticks for the 8 bits [start bit(0) to last bit of "1"(7th data bit)]
	 //Baud_dvsr=50MHz*1/(16*Baud_rate)= .... = x/128
	 //division operator is wasteful for fpga resources so we will only use shifting(divide by 2) --> 1/128 = 1/2^7
	 assign baud_dvsr= baud_reg>>7;
	 
	 //determine the paritybit through the sampled data bits of "x" and "p"
	 always @* begin //note: this is an unorthodox way of finding the parity bit BUT IT WORKS
		case({parity0_reg,parity1_reg})
		2'b01: paritybit=2; //even
		2'b10: paritybit=1; //odd
		2'b11: paritybit=0; //no parity
		default: paritybit=0;
		endcase
	 end 

	 
	 //debounce module for key0
	debounce_explicit m0
	(
	.clk(clk),
	.rst_n(rst_n),
	.sw({!key0}),
	.db_level(),
	.db_tick(key0_tick)
    );
	 
	 div #(.W(22),.N(5)) m1
	(
		.clk(clk),
		.rst_n(rst_n),
		.start(start_div),
		.dividend(3_125_000), //baud_rate=50MHz*1/(16*baud_dvsr)=3_125_000/baud_dvsr
		.divisor({10'd0,baud_dvsr}),
		.quotient(baud_rate),
		.remainder(),
		.ready(),
		.done_tick(done_div)
	);


endmodule
