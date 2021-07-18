`timescale 1ns / 1ps

module dual_edge_detector_MEALY(
	input clk,rst_n,
	input level, //active-high
	output reg edg
    );
	 //FSM declarations
	 localparam zero=1'b0,
					one=1'b1;
	reg state_reg,state_nxt;
	
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
			zero: if(level) begin
						edg=1;
						state_nxt=one;
					end
			one: if(!level) begin
						edg=1;
						state_nxt=zero;
					end
			default: state_nxt=zero;
			endcase	
	end

endmodule
