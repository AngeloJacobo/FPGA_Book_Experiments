`timescale 1ns / 1ps

module int_to_fp_TB;

	// Inputs
	reg [7:0] integ;

	// Outputs
	wire [12:0] fp;
   
	// Instantiate the Unit Under Test (UUT)
	int_to_fp uut (
		.integ(integ), 
		.fp(fp)
	);

	initial begin
		// Initialize Inputs
		integ = 0;

		// Wait 100 ns for global reset to finish
		#100;
		for(integ={8{1'b1}};integ>0;integ=integ-1) begin
		#5 ;
		end
		#100 $finish;
		// Add stimulus here
	end
	initial begin
	$display("Integer  FloatingPoint");
	$monitor("%b %b",integ,fp);
	end
	
      
endmodule

