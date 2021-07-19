`timescale 1ns / 1ps


module universal_binary_counter_TB;

	// Inputs
	wire clk;
	wire rst_n;
	wire syn_clr;
	wire load;
	wire en;
	wire up;
	wire[2:0] d;

	// Outputs
	wire [2:0] q;
	wire max_tick;
	wire min_tick;

	// Instantiate the Unit Under Test (UUT)
	universal_binary_counter #(.N(3)) uut1 
	(
		.clk(clk), 
		.rst_n(rst_n), 
		.syn_clr(syn_clr), 
		.load(load), 
		.en(en), 
		.up(up), 
		.d(d), 
		.q(q), 
		.max_tick(max_tick), 
		.min_tick(min_tick)
	);
	
	 test_vector #(.N(3),.T(20)) uut2
	(
		.clk(clk),
		.rst_n(rst_n),
		.syn_clr(syn_clr),
		.load(load),
		.en(en),
		.up(up),
		.d(d)
    );
	 
	 monitor #(.N(3)) uut3
	(
		.clk(clk),
		.rst_n(rst_n),
		.syn_clr(syn_clr),
		.load(load),
		.en(en),
		.up(up),
		.d(d),
		.q(q),
		.max_tick(max_tick),
		.min_tick(min_tick)
    );
    
endmodule

