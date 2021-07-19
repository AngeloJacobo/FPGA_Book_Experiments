`timescale 1ns / 1ps

module babbage_diff(
	input clk,rst_n,
	input start,
	input[5:0] i, //6 bit value f "n"	
	output[17:0] ans,
	output reg ready,done_tick
    );
	 //babbage function values(3-order polynomial)
	 localparam f0=1,
					g1=5,
					h2=10,
					c=6;
	 //FSM state declarations
	 localparam[1:0] idle=2'd0,
							op=2'd1,
							done=2'd2;
	 reg[1:0] state_reg,state_nxt;
	 reg[17:0] f_reg,f_nxt;
	 reg[17:0] g_reg,g_nxt;
	 reg[17:0] h_reg,h_nxt;
	 reg[5:0] n_reg,n_nxt;
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		 if(!rst_n) begin
			state_reg<=idle;
			f_reg<=0;
			g_reg<=0;
			h_reg<=0;
			n_reg<=0;		
		 end
		 else begin
			state_reg<=state_nxt;
			f_reg<=f_nxt;
			g_reg<=g_nxt;
			h_reg<=h_nxt;
			n_reg<=n_nxt;	
		 end	 
	 end
	 //FSM next-state logics
	 always @* begin
		state_nxt=state_reg;
		f_nxt=f_reg;
		g_nxt=g_reg;
		h_nxt=h_reg;
		n_nxt=n_reg;
		ready=0;
		done_tick=0;
		case(state_reg)
			  idle: begin
							ready=1;
							if(start==1) begin
								f_nxt=f0;
								g_nxt=0;
								h_nxt=0;
								n_nxt=0;
								state_nxt=op;
							end
					  end
			    op: begin
							if(n_reg==i) state_nxt=done;
							else begin
								n_nxt=n_reg+1;
								case(n_nxt)
									1: begin
											g_nxt=g1;
											f_nxt=g_nxt+f_reg;
										 end
									2: begin
											h_nxt=h2;
											g_nxt=h_nxt+g_reg;
											f_nxt=g_nxt+f_reg;
										end
									default: begin
											h_nxt=c+h_reg;
											g_nxt=h_nxt+g_reg;
											f_nxt=g_nxt+f_reg;
									end
								endcase
							end
					  end
			  done: begin
							done_tick=1;
							state_nxt=idle;
					  end
			default: state_nxt=idle;
		endcase
	 end
	 assign ans=f_reg;


endmodule
