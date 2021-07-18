`timescale 1ns / 1ps

module led_dimmer_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg [3:0] w;
   reg en;
	// Outputs
	wire pwm;

	// Instantiate the Unit Under Test (UUT)
	led_dimmer uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.w(w), 
		.pwm(pwm),
		.en(en)
	);
	always begin
	clk=1'b0;
	#1;
	clk=1'b1;
	#1;
	end
	integer i;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 1;
		w = 0;
		en=1;
		@(negedge clk) rst_n=0;
		@(negedge clk) rst_n=1;     
		
		//4 ns
		
		for(i=0;i<=15;i=i+1) begin
		w=i;
		#100;
		end
		#100 $stop;
		
	end
      
endmodule

