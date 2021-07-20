`timescale 1ns / 1ps

module fifo_TB;

	// Inputs
	wire clk;
	wire rst_n;
	wire wr;
	wire rd;
	wire [7:0] wr_data;

	// Outputs
	wire [7:0] rd_data;
	wire full;
	wire empty;

	// Instantiate the Unit Under Test (UUT)
	fifo #(.W(4),.B(8)) uut1
	(
		.clk(clk), 
		.rst_n(rst_n), 
		.wr(wr), 
		.rd(rd), 
		.wr_data(wr_data), 
		.rd_data(rd_data), 
		.full(full), 
		.empty(empty)
	);

	fifo_test_vector #(.W(4),.B(8)) uut2
	(
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.rd(rd),
		.wr_data(wr_data)
    );
	 
	 fifo_monitor	#(.W(4),.B(8)) uut3
	(
	.clk(clk),
	.rd(rd),
	.rd_data(rd_data)
    );


      
endmodule

