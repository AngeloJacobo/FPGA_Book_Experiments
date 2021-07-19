`timescale 1ns / 1ps

module fibonacci(
	input clk,rst_n,
	input start,
	input[5:0] i,
	output[20:0] fibo,
	output reg ready,done_tick
    );
	 //FSM declarations
	 localparam[1:0] idle=2'd0,
							op=2'd1,
							done=2'd2;
	 reg[1:0] state_reg,state_nxt;
	 reg[20:0] i1_reg,i0_reg,i1_nxt,i0_nxt;
	 reg[5:0] n_reg,n_nxt;
	 //FSM register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			i1_reg<=0;
			i0_reg<=0;
			n_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			i1_reg<=i1_nxt;
			i0_reg<=i0_nxt;
			n_reg<=n_nxt;
		end
	 end
	 
	 //FSM next-state logics
	 always @* begin
		state_nxt=state_reg;
		i1_nxt=i1_reg;
		i0_nxt=i0_reg;
		n_nxt=n_reg;
		ready=0;
		done_tick=0;
		
		case(state_reg) 
			idle: begin
						ready=1;
						if(start) begin
							i1_nxt=1;
							i0_nxt=0;
							n_nxt=i;
							state_nxt=op;
							if(i>30) begin
							i1_nxt=999_999;
							state_nxt=done;
							end
						end
					 end
			 op: begin
						 if(n_reg==0) begin
							i1_nxt=0;
							state_nxt=done;
						 end
						 else begin
							if(n_reg==1) state_nxt=done;
							else begin
								i1_nxt=i1_reg+i0_reg;
								i0_nxt=i1_reg;
								n_nxt=n_reg-1;
							end
						 end
				  end
			 done: begin
						done_tick=1;
						state_nxt=idle;
					 end
			 default: state_nxt=idle;
		endcase
	 end
	 assign fibo=i1_reg;
			
	 
endmodule
