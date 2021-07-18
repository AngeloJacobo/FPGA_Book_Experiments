`timescale 1ns / 1ps

module debouncing_button_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg sw_low;

	// Outputs
	wire db;

	// Instantiate the Unit Under Test (UUT)
	early_debounce uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.sw_low(sw_low), 
		.db(db)
	);
	always begin //100MHz -> 2^1/100MHz= 20ns
	clk=1'b1;
	#5;
	clk=1'b0;
	#5;
	end

	initial begin
		// Initialize Inputs
		rst_n = 1;

		sw_low=1;
		#100 sw_low=0;
		#200 sw_low=1;
		#100 sw_low=0;
		#20 sw_low=1;
		#100 $stop;		
	
	end
      
endmodule

