`timescale 1ns / 1ps

module alt_bcd_counter(
	input clk,rst_n,
	input go,
	output reg[3:0] s1,s0,ms0
    );
	 reg[22:0] counter_reg=0;
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			s1<=0;
			s0<=0;
			ms0<=0;
			counter_reg<=0;
		end
		else if(go) begin //nested-if for describing the BCD-counter
			if(counter_reg!=4_999_999)	counter_reg<=counter_reg+1;
			else begin
				counter_reg<=0;
				if(ms0!=9) ms0<=ms0+1;
				else begin
					ms0<=0;
					if(s0!=9) s0<=s0+1;
					else begin
						s0<=0;
						if(s1!=9) s1<=s1+1;
						else s1<=0;
					end
				end
			end
		end
	 end


endmodule
