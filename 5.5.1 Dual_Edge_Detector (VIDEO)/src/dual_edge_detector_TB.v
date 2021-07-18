`timescale 1ns / 1ps

module dual_edge_detector_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg level;

	// Outputs
	wire edg_1,edg_2,edg_3;

	// Instantiate the Unit Under Test (UUT)
	dual_edge_detector_MOORE uut1 (
		.clk(clk), 
		.rst_n(rst_n), 
		.level(level), 
		.edg(edg_1)
	);
	dual_edge_detector_MEALY uut2(
		.clk(clk), 
		.rst_n(rst_n), 
		.level(level), 
		.edg(edg_2)
	);
	dual_edge_detector_simpler uut3(
		.clk(clk), 
		.rst_n(rst_n), 
		.level(level), 
		.edg(edg_3)
	);
	
	
	
	always begin
		clk=1'b0;
		#5;
		clk=1'b1;
		#5;
	end

	initial begin
		// Initialize Inputs

		rst_n = 1;
		level = 0;
		//reset
		//@(negedge clk) rst_n=0;
		@(negedge clk) rst_n=1;
		
		//1 clk on, 1 tick
		level=1;
		@(negedge clk) level=0;
		repeat(5) @(negedge clk);
		
		//2 clk on, 2 ticks
		level=1;
		repeat(2) @(negedge clk);
		level=0;
		repeat(5) @(negedge clk);
		
		//10 clk on,2 ticks
		level=1;
		repeat(10) @(posedge clk);
		level=0;
		repeat(5) @(negedge clk);
		$stop;

	end
      
endmodule

