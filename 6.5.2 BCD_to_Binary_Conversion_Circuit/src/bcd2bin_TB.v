`timescale 1ns / 1ps

module bcd2bin_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg start;
	reg [3:0] dig1;
	reg [3:0] dig0;

	// Outputs
	wire [6:0] bin;
	wire ready;
	wire done_tick;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	bcd2bin uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.start(start), 
		.dig1(dig1), 
		.dig0(dig0), 
		.bin(bin), 
		.ready(ready), 
		.done_tick(done_tick)
	);
	always begin
		clk=0;
		#5;
		clk=1;
		#5;
	end

	initial begin
		// Initialize Inputs

		rst_n = 1;
		start = 0;
		dig1 = 0;
		dig0 = 0;
		@(negedge clk); //reset
		rst_n=0;
		@(negedge clk);
		rst_n=1;
		@(negedge clk);
		$display("BCD_input   Binary_output(Decimal_value)");
		for(i=0;i<=99;i=i+1) begin
			start=1;
			dig1=i/10; //second digit of i
			dig0=i-dig1*10; //first digit of i
			wait(done_tick);
			start=0;
			$display("     %0d          %b(%0d)",i,bin,bin);
			repeat(5)@(negedge clk);
		end
		$stop;
		
	end
      
endmodule

