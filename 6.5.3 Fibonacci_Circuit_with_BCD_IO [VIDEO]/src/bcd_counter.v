`timescale 1ns / 1ps

module bcd_counter(
	input clk,rst_n,
	input sw, //active-low
	output reg[3:0] dig1,dig0,
	output reg done_tick
    );
	 localparam idle=0,done=1;
	 reg state_reg,state_nxt;
	initial begin
		dig1=0;
		dig0=0;
	end
	 reg[3:0] dig1_nxt,dig0_nxt;
	 wire r_edg,sw_hi; //sw_hi:debounce module only use active high input so reverse the "sw" first
	 
	 assign sw_hi=!sw;
	 //debounce circuit
	debounce_explicit deb(
	.clk(clk),
	.rst_n(rst_n),
	.sw(sw_hi),
	.db_tick(r_edg)	
    );
	 
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=0;
			dig1<=0;
			dig0<=0;
		end
		else begin
			state_reg<=state_nxt;
			dig1<=dig1_nxt;
			dig0<=dig0_nxt;
		end
		
	end
	always @* begin
		state_nxt=state_reg;
		dig1_nxt=dig1;
		dig0_nxt=dig0;
		done_tick=0;
		case(state_reg)
			idle: if(r_edg) begin
						if(dig0!=9) dig0_nxt=dig0+1;
						else begin
							dig0_nxt=0;
							if(dig1!=4) dig1_nxt=dig1+1;
							else dig1_nxt=0;
						end	
						state_nxt=done;
					end
			done: begin
						done_tick=1;
						state_nxt=idle;
					end
		default: state_nxt=idle;
		endcase
	end


endmodule
