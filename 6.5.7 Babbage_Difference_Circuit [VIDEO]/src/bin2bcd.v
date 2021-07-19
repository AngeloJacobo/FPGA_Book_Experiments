`timescale 1ns / 1ps

module bin2bcd(
	input clk,rst_n,
	input start,
	input[19:0] bin,//limit is 6 digit of bcd
	output reg ready,done_tick,
	output[3:0] dig0,dig1,dig2,dig3,dig4,dig5
    );
	 //FSM declarations
	 localparam[1:0] idle=2'd0,
							op=2'd1,
							done=2'd2;
	 localparam N=20; //width of binary
	
	 reg[1:0] state_reg,state_nxt;
	 reg[N-1:0] bin_reg,bin_nxt;
	 reg[3:0] dig0_reg,dig1_reg,dig2_reg,dig3_reg,dig4_reg,dig5_reg;
	 reg[3:0] dig0_nxt,dig1_nxt,dig2_nxt,dig3_nxt,dig4_nxt,dig5_nxt;
	 reg[4:0] n_reg,n_nxt;
	 
	 //FSM reguster operations
	 always @(posedge clk,negedge rst_n) begin
		 if(!rst_n) begin
			state_reg<=idle;
			bin_reg<=0;
			dig0_reg<=0;
			dig1_reg<=0;
			dig2_reg<=0;
			dig3_reg<=0;
			dig4_reg<=0;
			dig5_reg<=0;
			n_reg<=0;
		 end
		 else begin
			state_reg<=state_nxt;
			bin_reg<=bin_nxt;
			dig0_reg<=dig0_nxt;
			dig1_reg<=dig1_nxt;
			dig2_reg<=dig2_nxt;
			dig3_reg<=dig3_nxt;
			dig4_reg<=dig4_nxt;
			dig5_reg<=dig5_nxt;
			n_reg<=n_nxt;
		 end		 
	 end
	 //FSM next-state logics
	 always @* begin
		state_nxt=state_reg;
		bin_nxt=bin_reg;
		dig0_nxt=dig0_reg;
		dig1_nxt=dig1_reg;
		dig2_nxt=dig2_reg;
		dig3_nxt=dig3_reg;
		dig4_nxt=dig4_reg;
		dig5_nxt=dig5_reg;
		n_nxt=n_reg;
		done_tick=0;
		ready=0;
			case(state_reg) 
				idle: begin
							ready=1;
							if(start) begin
								bin_nxt=bin;
								dig0_nxt=0;
								dig1_nxt=0;
								dig2_nxt=0;
								dig3_nxt=0;
								dig4_nxt=0;
								dig5_nxt=0;
								n_nxt=N;
								state_nxt=op;
							end
						end
				  op: begin
							dig0_nxt=(dig0_reg<=4)?dig0_reg:dig0_reg+4'd3;
							dig1_nxt=(dig1_reg<=4)?dig1_reg:dig1_reg+4'd3;
							dig2_nxt=(dig2_reg<=4)?dig2_reg:dig2_reg+4'd3;
							dig3_nxt=(dig3_reg<=4)?dig3_reg:dig3_reg+4'd3;
							dig4_nxt=(dig4_reg<=4)?dig4_reg:dig4_reg+4'd3;
							dig5_nxt=(dig5_reg<=4)?dig5_reg:dig5_reg+4'd3;
							
							{dig5_nxt,dig4_nxt,dig3_nxt,dig2_nxt,dig1_nxt,dig0_nxt,bin_nxt}={dig5_nxt,dig4_nxt,dig3_nxt,dig2_nxt,dig1_nxt,dig0_nxt,bin_nxt}<<1; //shift left by 1
							n_nxt=n_reg-1;
							if(n_nxt==0) state_nxt=done;			
						end
				done: begin
							done_tick=1;
							state_nxt=idle;
						end
			default: state_nxt=idle;						
			endcase	
	 end
	 assign  dig0=dig0_reg,
				dig1=dig1_reg,
				dig2=dig2_reg,
				dig3=dig3_reg,
				dig4=dig4_reg,
				dig5=dig5_reg;
	
	 
	 

	 


endmodule
