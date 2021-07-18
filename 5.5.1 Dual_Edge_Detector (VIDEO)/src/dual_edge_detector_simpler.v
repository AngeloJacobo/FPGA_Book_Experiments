`timescale 1ns / 1ps

module dual_edge_detector_simpler(
	input clk,rst_n,
	input level,
	output edg
    );
	 reg level_reg=0;
	 always @(posedge clk,negedge rst_n)
	 if(!rst_n) level_reg<=0;
	 else level_reg<=level;
	 assign edg=level^level_reg;
endmodule
