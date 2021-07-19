`timescale 1ns / 1ps

module div
	#(parameter W=32, N=6) //W is the width of both dividend and divisor, N is the size of the register that stores binary value of W: N=log_2(W)+1
	(
	input clk,rst_n,
	input start,
	input [W-1:0] dividend,divisor,
	output[W-1:0] quotient,remainder,
	output reg ready,done_tick
    );
	

	 //FSM declarations
	 localparam[1:0] idle=2'd0,
							op=2'd1,
							last=2'd2,
							done=2'd3;
	 reg[1:0] state_reg,state_nxt;
	 reg[W-1:0] dividend_reg,divisor_reg,dividend_nxt,divisor_nxt;
	 reg[W-1:0] remainder_reg,remainder_nxt;
	 reg[N-1:0] n_reg,n_nxt;
	 reg[W-1:0] temp;
	 reg q;
	 
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			dividend_reg<=0;
			divisor_reg<=0;
			remainder_reg<=0;
			n_reg<=0;
			state_reg<=0;
		end
		else begin
			dividend_reg<=dividend_nxt;
			divisor_reg<=divisor_nxt;
			remainder_reg<=remainder_nxt;
			n_reg<=n_nxt;
			state_reg<=state_nxt;
		end
	 end
	 
	//FSM next-state logics
	always @* begin
		dividend_nxt=dividend_reg;
		divisor_nxt=divisor_reg;
		remainder_nxt=remainder_reg;
		state_nxt=state_reg;
		n_nxt=n_reg;
		ready=0;
		temp=0;
		done_tick=0;
		q=0;
		case(state_reg)
			idle: begin
						ready=1;
						if(start) begin
						dividend_nxt=dividend;
						divisor_nxt=divisor;
						remainder_nxt=0;
						n_nxt=W; //decrements until all dividend is used
						state_nxt=op;
						end
					end
			  op: begin
						if(remainder_reg>=divisor_reg) begin
							temp=remainder_reg-divisor_reg;
							q=1;
						end
						else begin 
							temp=remainder_reg;
							q=0;
						end
						{remainder_nxt,dividend_nxt}={temp[W-2:0],dividend_reg,q};
						n_nxt=n_reg-1;
						if(n_nxt==0) state_nxt=last;
					end
			last: begin
						if(remainder_reg>=divisor_reg) begin
							temp=remainder_reg-divisor_reg;
							q=1;
						end
						else begin 
							temp=remainder_reg;
							q=0;
						end
						dividend_nxt={dividend_reg[W-2:0],q};
						remainder_nxt=temp;
						state_nxt=done;
					end
			done: begin
						done_tick=1;
						state_nxt=idle;
					end
		default: state_nxt=idle;
		endcase
	end
	assign quotient=dividend_reg;
	assign remainder=remainder_reg;
	

endmodule
