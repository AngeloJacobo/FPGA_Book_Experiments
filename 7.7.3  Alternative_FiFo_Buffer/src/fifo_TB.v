`timescale 1ns / 1ps



module fifo_TB;

	//parameter for clock period
	localparam T=10;
	// Inputs
	reg clk;
	reg rst_n;
	reg wr;
	reg rd;
	reg [7:0] wr_data;

	// Outputs
	wire empty;
	wire full;
	wire [7:0] rd_data;
   wire [3:0] wr_ptr,rd_ptr;
	// Instantiate the Unit Under Test (UUT)
	fifo  #(.W(4),.B(8)) uut
	(
		.clk(clk), 
		.rst_n(rst_n), 
		.wr(wr), 
		.rd(rd), 
		.wr_data(wr_data), 
		.empty(empty), 
		.full(full), 
		.rd_data(rd_data),
		.wr_ptr(wr_ptr),
		.rd_ptr(rd_ptr)
	);

	always begin
		clk=1'b0;
		#(T/2);
		clk=1'b1;
		#(T/2);
	end
	integer i=0;

	initial begin
		// Initialize Inputs
		rst_n = 1;
		wr = 0;
		rd = 0;
		wr_data = 0;
		
		//reset
		@(negedge clk) rst_n=0;
		@(negedge clk) rst_n=1;
		
		//write
		$display("Write TEST");
		$display("wr rd ful emp read_data");
		wr=1;
		for(i=8'b1111_1111;i>(8'hff-20);i=i-1) begin
			wr_data=i;
			@(negedge clk);
		end
		
		//read and write while full
		$display("Read&Write while FULL TEST");
		$display("wr rd ful emp read_data");
		rd=1; 
		for(i=8'd1;i<10;i=i+1) begin
			wr_data=i;
			@(negedge clk);
		   end

		//read
		$display("Read TEST");
		$display("wr rd ful emp read_data");
		wr=0;
		repeat(20) @(negedge clk);
		
		//read and write while empty()
		$display("Read&Write while EMPTY TEST");
		$display("wr rd ful emp read_data");
		wr=1; 
		for(i=8'd1;i<20;i=i+1) begin
			wr_data=i;
			@(negedge clk);
		   end
			
			
		$display("Read and write but not full nor empty TEST");
		$display("wr rd ful emp read_data");
		wr=1;
		rd=0;
		for(i=8'b1111_0000;i>(8'b1111_0000-8);i=i-1) begin //fill half-way
			wr_data=i;
			@(negedge clk);
		end	
		rd=1;
		for(i=8'd1;i<20;i=i+1) begin
			wr_data=i;
			@(negedge clk);
		   end	
		$stop;	
	end
	
	initial begin
	$monitor("%d %d %d    %d   %d ",wr_ptr,rd_ptr,full,empty,rd_data);
	end
	
      
endmodule

