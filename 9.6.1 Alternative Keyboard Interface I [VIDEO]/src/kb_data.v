`timescale 1ns / 1ps

module kb_data(
	input clk,rst_n,
	input rx_done_tick,
	input[7:0] din,
	output reg wr,
	output reg[7:0] wr_data
    );
	 //FSM state declarations
	 localparam[1:0] idle=2'd0,
							scan=2'd1,
							breakcode=2'd3;
	 reg[1:0] state_reg;
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) state_reg<=idle;
		
		else begin
		wr=0;
		wr_data=0;
			case(state_reg)
				idle: if(rx_done_tick) begin //wait for the makecode
							if(din==8'hf0) state_reg<=breakcode;
							else begin
								wr_data=din;
								wr=1;
								state_reg<=scan;
							end							
						 end
				scan: if(rx_done_tick) begin //wait for the breakcode which starts with 8'hf0
							if(din==8'hf0) state_reg<=breakcode;
							else begin
								wr_data=din;
								wr=1;
							end
						end
		 breakcode: if(rx_done_tick) state_reg<=idle;	//skip the makecode after the breakcode 8'hf0 						
			endcase
		end
	 end
	 


endmodule
