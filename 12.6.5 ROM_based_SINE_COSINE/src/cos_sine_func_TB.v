`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:03:51 06/13/2021
// Design Name:   sine_func
// Module Name:   E:/Desktop/Xilinx FPGA/My Projects/ROM_based_SINE/sine_func_TB.v
// Project Name:  ROM_based_SINE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sine_func
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cos_sine_func_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg [9:0] x;

	// Outputs
	wire [7:0] y_sine,y_cos;
	reg[9:0] counter=0;

	// Instantiate the Unit Under Test (UUT)
	cos_sine uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.x(x), 
		.y_sine(y_sine),
		.y_cos(y_cos)
	);
	always begin
		clk=0;
		#5;
		clk=1;
		#5;
	end
	always @(posedge clk) begin
		counter=counter+1'b1;
		x=counter;
	end

	initial begin
		rst_n = 1;
		@(negedge clk);
		wait(counter==0);
		@(negedge clk);
		wait(counter==0);
		@(negedge clk);
		wait(counter==0);
		@(negedge clk);
		wait(counter==0);
		@(negedge clk);
		wait(counter==0);
		@(negedge clk);
		wait(counter==0);
		@(negedge clk);
		wait(counter==0);
		@(negedge clk);
		wait(counter==0);
		$stop;
	end
      
endmodule

