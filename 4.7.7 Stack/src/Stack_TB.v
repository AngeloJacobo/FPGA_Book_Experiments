`timescale 1ns / 1ps

module Stack_TB;

	//parameter for clock period
	localparam T=10;
	// Inputs
	reg clk;
	reg rst;
	reg push;
	reg pop;
	reg [7:0] wr_data;

	// Outputs
	wire empty;
	wire full;
	wire [7:0] rd_data;
   wire [3:0] stack_ptr;
	// Instantiate the Unit Under Test (UUT)
	Stack uut (
		.clk(clk), 
		.rst(rst), 
		.push(push), 
		.pop(pop), 
		.wr_data(wr_data), 
		.empty(empty), 
		.full(full), 
		.rd_data(rd_data),
		.stack_ptr(stack_ptr)
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
		rst = 0;
		push = 0;
		pop = 0;
		wr_data = 0;
		
		//reset
		@(negedge clk) rst=1;
		@(negedge clk) rst=0;
		
		//write
		$display("Write");
		$display("ptr full empty read_data");
		push=1;
		for(i=8'b1111_1111;i>(8'hff-20);i=i-1) begin //write from 255-to-240
			wr_data=i;
			@(negedge clk);
		end
		
		//read and write while full
		$display("Read&Write while FULL");
		$display("ptr full empty read_data");
		pop=1; 
		for(i=8'd1;i<10;i=i+1) begin //ptr does not move and read-data is still 255 since no write operation happens
			wr_data=i;
			@(negedge clk);
		   end

		//read
		$display("Read");
		$display("ptr full empty read_data");
		push=0;
		repeat(20) @(negedge clk); //read from 240-to-255
		
		//read and write while empty
		$display("Read&Write while EMPTY");
		$display("ptr full empty read_data");
		push=1; 
		for(i=8'd1;i<20;i=i+1) begin //replace 255 with 1,then2,then 3,until 19
			wr_data=i;
			@(negedge clk);
		   end
			
			
		$display("Read&Write But is Neither Full Nor Empty");
		$display("ptr full empty read_data");
		$display("Filling Half-Way");
		push=1; //since its empty last time,fill half of it first of values from 240-to-233
		pop=0;
		for(i=8'b1111_0000;i>(8'b1111_0000-8);i=i-1) begin //fill half-way
			wr_data=i;
			@(negedge clk);
		end	
		$display("Read&Write"); //it will just replace 233 of values from 1-to-19
		pop=1; //now read and write 
		for(i=8'd1;i<20;i=i+1) begin
			wr_data=i;
			@(negedge clk);
		   end	
			
			
		$display("Empty the Buffer");	
		push=0;
		repeat(20) @(negedge clk); //read from 233-to-240
	
		$stop;	
	end
	
	initial begin
	$monitor("%d   %b    %b     %d",stack_ptr,full,empty,rd_data);
	end
	
      
endmodule

