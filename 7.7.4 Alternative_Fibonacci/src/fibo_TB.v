`timescale 1ns / 1ps


module fibo_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg start;
	reg [4:0] i;

	// Outputs
	wire [20:0] fibo;
	wire done_tick;

	// Instantiate the Unit Under Test (UUT)
	fibo uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.start(start), 
		.i(i), 
		.fibo(fibo), 
		.done_tick(done_tick)
	);
	always begin
		clk=0;
		#5;
		clk=1;
		#5;
	end
	integer idx,file1;
	initial begin
		// Initialize Inputs
		rst_n = 1;
		start = 0;
		i = 0;
		$display("i -> Fibonacci\n");
		for(idx=0;idx<32;idx=idx+1) begin
		@(negedge clk)
			start=1;
			i=idx;			
			wait(done_tick);
			start=0;
			repeat(5) @(negedge clk);
			$display("%d -> %d",i,fibo);
		end
		$stop;

	end
      
endmodule

