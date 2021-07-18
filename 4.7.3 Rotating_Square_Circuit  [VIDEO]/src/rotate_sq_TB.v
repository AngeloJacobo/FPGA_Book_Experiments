`timescale 1ns / 1ps

module rotate_sq_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg cw;
	reg en;

	// Outputs
	wire [7:0] in0;
	wire [7:0] in1;
	wire [7:0] in2;
	wire [7:0] in3;
	wire [7:0] in4;
	wire [7:0] in5;

	// Instantiate the Unit Under Test (UUT)
	rotate_sq #(.base_counter(5)) uut //100 ns per box
	( 
		.clk(clk), 
		.rst_n(rst_n), 
		.cw(cw), 
		.en(en), 
		.in0(in0), 
		.in1(in1), 
		.in2(in2), 
		.in3(in3), 
		.in4(in4), 
		.in5(in5)
	);
	always begin
	clk=1'b0;
	#10;
	clk=1'b1;
	#10;
	end
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 1'b1;
		cw = 0;
		en = 1'b1;
		
	

	end
	
      
endmodule

