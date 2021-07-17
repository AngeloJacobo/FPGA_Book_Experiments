`timescale 1ns / 1ps

module dual_pioenc_TB;

	// Inputs
	reg [11:0] in;

	// Outputs
	wire [3:0] first;
	wire [3:0] second;

	// Instantiate the Unit Under Test (UUT)
	dual_prioenc uut (
		.in(in), 
		.first(first), 
		.second(second)
	);

	initial begin
		// Initialize Inputs
		in = 0;

		// Wait 100 ns for global reset to finish
		#100;
		for(in=12'd0;in<12'd4095;in=in+1) #5;
		#100 $finish;
	end
	initial begin
	$display ("Input        First Second");
	$monitor ("%b %d     %d",in,first,second);
	end
      
endmodule

