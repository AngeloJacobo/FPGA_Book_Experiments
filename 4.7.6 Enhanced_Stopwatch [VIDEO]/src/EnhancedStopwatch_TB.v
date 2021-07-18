`timescale 1ns / 1ps

module EnhancedStopwatch_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg up;
	reg go;

	// Outputs
	wire [4:0] in0;
	wire [4:0] in1;
	wire [4:0] in2;
	wire [4:0] in3;
	wire [4:0] in4;
	wire [4:0] in5;

	// Instantiate the Unit Under Test (UUT)
	Enhanced_Stopwatch uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.up(up), 
		.go(go), 
		.in0(in0), 
		.in1(in1), 
		.in2(in2), 
		.in3(in3), 
		.in4(in4), 
		.in5(in5)
	);
	always begin //100MHz
	clk=1'b0;
	#5;
	clk=1'b1;
	#5;
	end

	initial begin //tick is every 50ns,

		rst_n = 1;
		up = 1;
		go = 1;



	end
      
endmodule

