`timescale 1ns / 1ps

module period_counter(
		input clk,rst_n,
		input start,signal,
		output reg ready,done_tick,
		output [19:0] period //limit of 1.023 seconds of period
    );
	 
	 //FSM declarations
	 localparam[1:0] idle=2'd0,
							waiting=2'd1,
							op=2'd2,
							done=2'd3;
	 localparam N=50; // N/50Mhz=1us	
	 reg[1:0] state_reg,state_nxt;
	 reg[19:0] period_reg,period_nxt; // records period in terms of us
	 reg[5:0] tick_reg,tick_nxt; //ticks for every 1us (width of tick_reg is log_2(N))
	 reg signal_reg;
	 wire edg;
	 
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			period_reg<=0;
			tick_reg<=0;
			signal_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			period_reg<=period_nxt;
			tick_reg<=tick_nxt;
			signal_reg<=signal;
		end
	 end
	 
	 //FSM next-state logic
	 always @* begin
		state_nxt=state_reg;
		period_nxt=period_reg;
		tick_nxt=tick_reg;
		ready=0;
		done_tick=0;
		case(state_reg) 
				idle: begin //rest
							ready=1;
							if(start) begin
								period_nxt=0;
								tick_nxt=0;
								state_nxt=waiting;
							end
						end
			waiting: begin //waiting for rising edge
							if(edg) //rising edge-detector
								state_nxt=op;
						end
				  op: begin //counting the number of ms then stop when rising edge is detected again
							if(edg) state_nxt=done;
							else begin
								if(tick_reg==N-1) begin
									tick_nxt=0;
									period_nxt=period_reg+1;
								end
								else tick_nxt=tick_reg+1;	
							end
						end
				done: begin
							done_tick=1;
							state_nxt=idle;
						end
			default: state_nxt=idle;
		endcase
	 end
	 
	 //rising-edge detector circuit
	 assign edg=signal && !signal_reg;
	 
	 
	 
	 //output combi-logic
	 assign period=period_reg;
	 
	 


endmodule 
