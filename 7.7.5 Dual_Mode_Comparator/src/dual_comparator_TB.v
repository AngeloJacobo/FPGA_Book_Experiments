`timescale 1ns / 1ps


module dual_comparator_TB;

	// Inputs
	reg [7:0] a;
	reg [7:0] b;
	reg mode;

	// Outputs
	wire agtb;

	// Instantiate the Unit Under Test (UUT)
	dual_comparator uut (
		.a(a), 
		.b(b), 
		.mode(mode), 
		.agtb(agtb)
	);

	initial begin
		
		a = 8'b0000_1111; //15 or 15
		b = 8'b1111_0000; //240 or -16
		mode = 0; //unsigned comparison
		#50; //agbt=0  since 15<240
		mode=1; //signed comparison
		#50; //agbt=1 since 15>-16
		$stop;

		

	end
      
endmodule

