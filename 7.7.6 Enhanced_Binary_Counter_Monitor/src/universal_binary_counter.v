`timescale 1ns / 1ps

module universal_binary_counter
	#(parameter N=3)
	(
		input clk,rst_n,
		input syn_clr,load,en,up,
		input[N-1:0] d,
		output reg[N-1:0] q,
		output max_tick,min_tick	
    );//register plus next-state logics
	 initial q=0;
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) q<=0;
		else if(syn_clr) q<=0;
		else if(load) q<=d;
		else if(en && up) q<=q+1;
		else if(en && ~up) q<=q-1;
	 end
	assign max_tick=(q=={N{1'b1}})?1:0;
	assign min_tick=(q==0)?1:0;

endmodule
