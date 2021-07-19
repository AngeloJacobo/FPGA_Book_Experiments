`timescale 1ns / 1ps

module bcd2bin(
	input clk,rst_n,
	input start,
	input[3:0] dig1,dig0,
	output reg[6:0] bin, //2-digit number takes at most 7 bits
	output reg ready,done_tick
    );
	 //FSM state declarations
	 localparam[1:0] idle=2'd0,
							op=2'd1,
							done=2'd2;
	 reg[1:0] state_reg,state_nxt;
	 reg[6:0] bin_nxt;
	 reg[3:0] dig1_reg,dig1_nxt;
	 reg[3:0] dig0_reg,dig0_nxt;
	 reg[2:0] n_reg,n_nxt; //stores the width of the resulting binary
	 
	 //FSM register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			bin<=0;
			dig1_reg<=0;
			dig0_reg<=0;
			n_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			bin<=bin_nxt;
			dig1_reg<=dig1_nxt;
			dig0_reg<=dig0_nxt;
			n_reg<=n_nxt;
		end
	 end
	 //FSM next-state logic
	 always @* begin
		state_nxt=state_reg;
		bin_nxt=bin;
		dig1_nxt=dig1_reg;
		dig0_nxt=dig0_reg;
		n_nxt=n_reg;
		ready=0;
		done_tick=0;
		case(state_reg)
				idle: begin
							ready=1;
							if(start) begin
								bin_nxt=0;
								dig1_nxt=dig1;
								dig0_nxt=dig0;
								n_nxt=7; //binary has 7 bits of output thus 7 "shifts" are needed
								state_nxt=op;
							end
						end
				  op: begin //special shift-operation for converting bcd to bin.Check the book for more info
							if( {dig1_reg[0],dig0_reg[3:1]} >= 8 ) ///special shift-operation for converting bcd to bin.Check the book for more info
								dig0_nxt= {dig1_reg[0],dig0_reg[3:1]} - 3;
							else dig0_nxt= {dig1_reg[0],dig0_reg[3:1]};
							dig1_nxt=dig1_reg>>1;
							bin_nxt={dig0_reg[0],bin[6:1]};
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
	 


endmodule
