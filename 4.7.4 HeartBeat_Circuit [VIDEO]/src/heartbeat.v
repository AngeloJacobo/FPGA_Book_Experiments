`timescale 1ns / 1ps

module heartbeat
	#(parameter turns=5_000_000) //// 50MHz/turns = 50MHz/5_000_000 = 10Hz(100ms) per pattern or 600ms per beat
	(
	input clk,rst_n,
	output reg[7:0] in0,in1,in2,in3,in4,in5
    );
	 
	 reg[23:0] mod_turns=0; // counter to determine the duration between patterns of beats
	 reg[2:0] mod_6=0; //counts 0-to-3(4 turns) since there are 4 patterns per rotation then rest from 4-to-5  SO THAT THE HEARTBEAT WILL BE REALISTIC
	 wire[23:0] mod_turns_nxt;
	 wire[2:0] mod_6_nxt;
	 wire mod_turns_max;
	 
	 //registers
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			mod_turns<=0;
			mod_6<=0;
		end
		else begin
			mod_turns<=mod_turns_nxt;
			mod_6<=mod_6_nxt;
		end
	 end
	 

	 
	 //next-state logics
	 assign mod_turns_nxt=(mod_turns==turns-1)?0:mod_turns+1;
	 assign mod_turns_max=(mod_turns==turns-1)?1:0;
	 assign mod_6_nxt=mod_turns_max? ((mod_6==5)?0:mod_6+1) :mod_6;
	 
	 //mod_6 determines what segment is "on" and what pattern is on that segment
	 always @* begin
	 in0=8'hff; in1=8'hff; in2=8'hff; in3=8'hff; in4=8'hff; in5=8'hff; //default off
		 case(mod_6)
		 2'd0: begin in3=8'b1_1001_111; in2=8'b1_1111_001; end //first pattern of heartbeat 
		 2'd1: begin in3=8'b1_1111_001; in2=8'b1_1001_111; end //second pattern of heartbeat
		 2'd2: begin in4=8'b1_1111_001; in1=8'b1_1001_111; end //third pattern of heartbeat
		 2'd3: begin in5=8'b1_1111_001; in0=8'b1_1001_111; end //fourth pattern of heartbeat
		 //rest on 4 and 5
		 endcase
	 end
	 
endmodule
