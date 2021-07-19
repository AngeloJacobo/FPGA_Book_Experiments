`timescale 1ns / 1ps

module fibo(
	input clk,rst_n,
	input start,
	input[4:0] i, //limit is until the 31st fibonacci
	output[20:0] fibo,
	output reg done_tick
    );
	//FSM state declarations
	 localparam[1:0] idle=2'd0,
							op=2'd1,
							done=2'd2;
	 reg[1:0] state_reg;
	 reg[20:0] i1,i0;
	 reg[4:0] n;
	 
	 //FSM register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			i1<=0;
			i0<=0;
			n<=0;
			done_tick=0;
			state_reg<=idle;
		end
		else begin
			done_tick=0;                     
			case(state_reg) 
				idle: if(start) begin
							i1<=1;
							i0<=0;
							n<=i;
							state_reg<=op;
						end
				 op: begin
						if(n==0) begin
							i1<=0;
							state_reg<=done;
						end
						else if(n==1) state_reg<=done;
						else begin
							i1<=i0+i1;
							i0<=i1;
							n<=n-1;
						end				 
					  end
			  done: begin
						done_tick=1;
						state_reg<=idle;
					  end
		  default: state_reg<=idle;		 
			endcase
		end
	 end
	 assign fibo=i1;
endmodule
