`timescale 1ns / 1ps

module parking_lot_counter(
	input clk,rst_n,
	input a,b,
	output reg enter,exit
    );
	 //FSM declarations
	 localparam[3:0] start=4'd0,
					enter1=4'd1,
					enter2=4'd2,
					enter3=4'd3,
					entered=4'd4,
					exit1=4'd5,
					exit2=4'd6,
					exit3=4'd7,
					exited=4'd8;
	 reg[3:0] state_reg,state_nxt;
	 
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) state_reg<=start;
		else state_reg<=state_nxt;
	 end
	 
	 //FSM next-state and output logics
	 always @* begin
		state_nxt=state_reg;
		enter=0;
		exit=0;
			case(state_reg)
		/*00*/	start: if(a && !b) state_nxt=enter1;
								else if(!a && b) state_nxt=exit1;
		/*10*/	enter1: if(!a && !b) state_nxt=start;
								else if(a && b) state_nxt=enter2;
		/*11*/	enter2: if(a && !b) state_nxt=enter1;
								else if(!a && b)  state_nxt=enter3;
		/*01*/	enter3: if(a && b) state_nxt=enter2;
								else if(!a && !b) state_nxt=entered;
		/*00*/	entered: begin 
									enter=1;
									state_nxt=start;
								end
		/*01*/	exit1: if(!a && !b) state_nxt=start;
								else if(a && b) state_nxt=exit2;
		/*11*/	exit2: if(!a && b) state_nxt=exit1;
								else if(a && !b) state_nxt=exit3;
		/*10*/	exit3: if(a && b) state_nxt=exit2;
								else if(!a && !b) state_nxt=exited;
		/*00*/	exited: begin
									exit=1;
									state_nxt=start;
							  end
					default: state_nxt=start;
			endcase
					
	 end
					


endmodule
