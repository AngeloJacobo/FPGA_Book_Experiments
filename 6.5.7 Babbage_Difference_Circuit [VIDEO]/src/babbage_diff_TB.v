`timescale 1ns / 1ps

module babbage_diff_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg start;
	reg [5:0] i;
	integer index;
	// Outputs
	wire [17:0] ans;
	wire ready;
	wire done_tick;
	// Instantiate the Unit Under Test (UUT)
	babbage_diff uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.start(start), 
		.i(i), 
		.ans(ans), 
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
		clk = 0;
		rst_n = 1;
		start = 0;
		i = 0;

		@(negedge clk);
		for(index=0;index<=63;index=index+1) begin
			start=1;
			i=index;
			wait(done_tick);
			start=0;
			@(negedge clk);
			$display("f(%0d) -> %0d",index,ans);
			repeat(5)@(negedge clk);
		 end
		$stop;
		

	end
      
endmodule


