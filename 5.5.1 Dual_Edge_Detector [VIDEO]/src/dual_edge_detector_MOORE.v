`timescale 1ns / 1ps

module dual_edge_detector_MOORE(
	input clk,rst_n,
	input level, //active high
	output reg edg
    );
	 
	 //FSM declarations
	 localparam[1:0] zero=2'd0,
						  r_edg=2'd1,
						  one=2'd2,
						  f_edg=2'd3;
	 reg[1:0] state_reg,state_nxt;
	 
	 //FSM register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) state_reg<=zero;
		else state_reg<=state_nxt;
	 end
	 
	 //FSM next-state and output logic
	 always @* begin
		state_nxt=state_reg;
		edg=0;
		case(state_reg) 
			zero: if(level) state_nxt=r_edg;
			r_edg: begin
						edg=1;
						if(level) state_nxt=one;
						else state_nxt=zero;
					 end
			one: if(!level) state_nxt=f_edg;
			f_edg: begin
						edg=1;
						state_nxt=zero;
					 end
			default: state_nxt=zero;
		endcase
	 end


endmodule
