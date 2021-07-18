`timescale 1ns / 1ps

module heartbeat_TB;

	// Inputs
	reg clk;
	reg rst_n;

	// Outputs
	wire [7:0] in0;
	wire [7:0] in1;
	wire [7:0] in2;
	wire [7:0] in3;
	wire [7:0] in4;
	wire [7:0] in5;

	// Instantiate the Unit Under Test (UUT)
	heartbeat 
	#(.turns(10)) uut // (base clock is 100MHz -> 100MHz/10 =10Mhz) 10Mhz frequency per pattern  OR 100ns per pattern
	(
		.clk(clk), 
		.rst_n(rst_n), 
		.in0(in0), 
		.in1(in1), 
		.in2(in2), 
		.in3(in3), 
		.in4(in4), 
		.in5(in5)
	);
	
	always begin
	clk=1'b1;
	#5;
	clk=1'b0;
	#5;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 1;
		

	end
      
endmodule

