`timescale 1ns / 1ps

module debounce(
	input clk,rst_n,
	input signal,
	output reg level,
	output reg ready,r_edg	
    );
	 //FSM state declarations
	 localparam[1:0] idle=2'd0,
							one=2'd1,
							waiting=2'd2,
							zero=2'd3;
	 localparam N=5_000_000; //N/50MHz=100ms debounce delay
	 reg[1:0] state_reg,state_nxt;
	 reg[22:0] counter_reg,counter_nxt; //log_2(N) -> 20bits
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=0;
			counter_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			counter_reg<=counter_nxt;
		end
	 end
	 //FSM next-state logic
	 always @* begin
		state_nxt=state_reg;
		counter_nxt=counter_reg;
		ready=0;
		r_edg=0;
		level=0;
		case(state_reg) 
			   idle: begin
							ready=1;
							if(signal) begin
								counter_nxt=0;
								r_edg=1;
								state_nxt=one;
							end
						end
		       one: begin
							level=1;
							if(counter_reg==N-1) state_nxt=waiting;
							else counter_nxt=counter_reg+1;
						end
			waiting: begin
							level=1;
							if(!signal) begin
								counter_nxt=0;
								state_nxt=zero;
							end
						end
			   zero: begin
							if(counter_reg==N-1) state_nxt=idle;
							else counter_nxt=counter_reg+1;
						end
			default: state_nxt=idle;
		endcase
	 end
	 

endmodule
