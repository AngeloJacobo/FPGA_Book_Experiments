`timescale 1ns / 1ps

module kb_data(
	input clk,rst_n,
	input rx_done_tick,
	input[7:0] din,
	output reg wr,
	output reg[8:0] wr_data //9th bit is asserted if shift is pressed(for capital letters)
    );
	 //FSM state declarations
	 localparam[1:0] idle=2'd0,
							scan=2'd1,
							breakcode=2'd3;
	 reg[1:0] state_reg;
	 reg shift_reg=0;
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			shift_reg<=0;
		end
		
		else begin
		wr=0;
		wr_data=0;
			case(state_reg)
				idle: if(rx_done_tick) begin //wait for the makecode
							if(din==8'hf0) state_reg<=breakcode; //break code
							else begin
								if(din==8'h12 || din==8'h59) begin//shift key 
									shift_reg<=1;
									state_reg<=scan;
								end
								else begin//non-shift key
									wr_data={shift_reg,din};
									wr=1;
									state_reg<=scan;
								end
							end							
						 end
				scan: if(rx_done_tick) begin 
							if(din==8'hf0) state_reg<=breakcode; //break code
							else begin
								if(din==8'h12 || din==8'h59) shift_reg<=1; //shift key
								else begin //non-shift key
									wr_data={shift_reg,din};
									wr=1;
								end
							end
						end
		 breakcode: if(rx_done_tick) begin
							if(din==8'h12 || din==8'h59) shift_reg<=0; //end of shift key
							state_reg<=idle;	//skip the makecode after the breakcode 8'hf0 	
						end
			default: state_reg<=idle;
			endcase
		end
	 end
	 


endmodule
