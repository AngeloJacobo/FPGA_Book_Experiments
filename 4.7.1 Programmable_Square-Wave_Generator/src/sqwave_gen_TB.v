`timescale 1ns / 1ps

module sqwave_gen_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg [3:0] m;
	reg [3:0] n;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	sqwave_gen uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.m(m), 
		.n(n), 
		.out(out)
	);
	
	always begin
	clk=1'b0;
	#10;
	clk=1'b1;
	#10;
	end

	initial begin
		// Initialize Inputs
		rst_n = 1'b1;
		m = 0;
		n = 0;
		@(negedge clk) rst_n=0;
		@(negedge clk) rst_n=1;
		$display("ON=100ns OFF=200ns");
		m=4'd1;
		n=4'd2; // ON=100ns OFF=200ns (0-1000)
		#1000;
		$display("ON=300ns OFF=200ns");
		m=4'd3;
		n=4'd2; // ON=300ns OFF=100ns (1000-2000)
		#1000; 
		$display("ON=500ns OFF=500ns");
		m=4'd5;
		n=4'd5;  //ON=500ns OFF=500ns (2000-3500)
		#1500 ;
		$display("ON=0ns OFF=100ns");
		m=4'd0; //ON=0ns OFF=100ns (3500-4500)
		n=4'd1;
		#1000;
		$display("ON=100ns OFF=0ns");
		m=4'd1; //ON=0ns OFF=100ns (4500-5500)
		n=4'd0;
		#1000;
		$display("ON=300ns OFF=200ns");
		m=4'd3;
		n=4'd2; // ON=300ns OFF=100ns (5500-6500)
		#1000;
		$stop;
	end
	initial begin
		$display("Out Time");
		$monitor("%d   %d",out,$time);
	end
      
endmodule

