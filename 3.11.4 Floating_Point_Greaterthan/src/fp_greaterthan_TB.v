`timescale 1ns / 1ps

module fp_greaterthan_TB;

	// Inputs
	reg [12:0] first;
	reg [12:0] second;

	// Outputs
	wire gt;
	reg[11:0] i=12'b0;

	// Instantiate the Unit Under Test (UUT)
	fp_greaterthan uut (
		.first(first), 
		.second(second), 
		.gt(gt)
	);

	initial begin
		// Initialize Inputs
		first = 0;
		second = 0;

		// Wait 100 ns for global reset to finish
		#100;

		for(i={12{1'b1}};i>0;i=i-1) begin  //test consecutive numbers
		#5 first={1'b0,i};      //pos-pos so gt is always equal to 1        
			second={1'b0,i-1'b1};             
		#5 first={1'b1,i};      //neg-pos so gt is always equal to 0		
			second={1'b0,i-1'b1};
		#5 first={1'b0,i};      //pos-neg so gt is always equal to 1
			second={1'b1,i-1'b1};
		#5 first={1'b1,i};      //neg-neg so gt is always equal to 0
			second={1'b1,i-1'b1};
		#2 $display(" ");
		end
	end
	
	initial begin
	$display("first         second        gt");
	$monitor("%b %b %d",first,second,gt);
	end
	initial begin
	#21000 $finish;
	end
	
      
endmodule

