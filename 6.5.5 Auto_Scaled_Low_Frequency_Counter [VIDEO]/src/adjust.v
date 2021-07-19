`timescale 1ns / 1ps

module adjust( //outputs the siz most significant bit with corresponding decimal
	input clk,rst_n,
	input start,
	input[3:0] dig0,dig1,dig2,dig3,dig4,dig5,dig6,dig7,dig8,dig9,dig10,
	output[4:0] in0,in1,in2,in3,in4,in5, //6 most significant digits 
	output reg done_tick
    );
	 //FSM state declarations
	 localparam[1:0] idle=2'd0,
							 op=2'd1,
							 done=2'd2;
	 reg[1:0] state_reg,state_nxt;
	 reg[4:0] dig0_reg,dig1_reg,dig2_reg,dig3_reg,dig4_reg,dig5_reg,dig6_reg,dig7_reg,dig8_reg,dig9_reg,dig10_reg;
	 reg[4:0] dig0_nxt,dig1_nxt,dig2_nxt,dig3_nxt,dig4_nxt,dig5_nxt,dig6_nxt,dig7_nxt,dig8_nxt,dig9_nxt,dig10_nxt;
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			dig0_reg<=0;
			dig1_reg<=0;
			dig2_reg<=0;
			dig3_reg<=0;
			dig4_reg<=0;
			dig5_reg<=0;
			dig6_reg<=0;
			dig7_reg<=0;
			dig8_reg<=0;
			dig9_reg<=0;
			dig10_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			dig0_reg<=dig0_nxt;
			dig1_reg<=dig1_nxt;
			dig2_reg<=dig2_nxt;
			dig3_reg<=dig3_nxt;
			dig4_reg<=dig4_nxt;
			dig5_reg<=dig5_nxt;
			dig6_reg<=dig6_nxt;
			dig7_reg<=dig7_nxt;
			dig8_reg<=dig8_nxt;
			dig9_reg<=dig9_nxt;
			dig10_reg<=dig10_nxt;
		end
	 end
	 //FSM next-state declarations
	 always @* begin
		state_nxt=state_reg;
		dig0_nxt=dig0_reg;
		dig1_nxt=dig1_reg;
		dig2_nxt=dig2_reg;
		dig3_nxt=dig3_reg;
		dig4_nxt=dig4_reg;
		dig5_nxt=dig5_reg;
		dig6_nxt=dig6_reg;
		dig7_nxt=dig7_reg;
		dig8_nxt=dig8_reg;
		dig9_nxt=dig9_reg;
		dig10_nxt=dig10_reg;
		done_tick=0;
		case(state_reg) 
			   idle: if(start) begin
							dig0_nxt={1'b0,dig0};
							dig1_nxt={1'b0,dig1};
							dig2_nxt={1'b0,dig2};
							dig3_nxt={1'b0,dig3};
							dig4_nxt={1'b0,dig4};
							dig5_nxt={1'b1,dig5};//decimal digit before the last 5 digits
							dig6_nxt={1'b0,dig6};
							dig7_nxt={1'b0,dig7};
							dig8_nxt={1'b0,dig8};
							dig9_nxt={1'b0,dig9};
							dig10_nxt={1'b0,dig10};
							state_nxt=op;
						end
			     op: begin
							if(dig10_nxt==0) begin
								{dig0_nxt,dig1_nxt,dig2_nxt,dig3_nxt,dig4_nxt,dig5_nxt,dig6_nxt,dig7_nxt,dig8_nxt,dig9_nxt,dig10_nxt}=
									{dig0_nxt,dig1_nxt,dig2_nxt,dig3_nxt,dig4_nxt,dig5_nxt,dig6_nxt,dig7_nxt,dig8_nxt,dig9_nxt,dig10_nxt}>>5;
							end
							else state_nxt=done;
						end
			   done: begin
							done_tick=1;
							state_nxt=idle;
						end
			default: state_nxt=idle;
		endcase
		
	 end
	 assign in5=dig10_reg,
				in4=dig9_reg,
				in3=dig8_reg,
				in2=dig7_reg,
				in1=dig6_reg,
				in0=dig5_reg;
	 
	 


endmodule
