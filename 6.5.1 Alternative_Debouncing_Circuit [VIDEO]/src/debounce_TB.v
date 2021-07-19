`timescale 1ns / 1ps


module debounce_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg signal;

	// Outputs
	wire level;
	wire ready;
	wire r_edg;

	// Instantiate the Unit Under Test (UUT)
	debounce uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.signal(signal), 
		.level(level), 
		.ready(ready), 
		.r_edg(r_edg)
	);
	always begin //100MHz-> 50ns debounce delay
	clk=0;
	#5;
	clk=1;
	#5;
	end

	initial begin
		rst_n = 1;
		signal = 0;
		repeat(5) @(negedge clk);
		signal=1;   
		#20; 
		signal=0;
		#20;
		signal=1; //will not turn off
		#150
		signal=0;
		repeat(5) @(negedge clk);
		$stop;

		

	end
      
endmodule

