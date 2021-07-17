`timescale 1ns / 1ps

module greater_than_2bit_TB;

	// Inputs
	reg [1:0] a;
	reg [1:0] b;

	// Outputs
	wire gt;
	reg[4:0] counter;
	
	
	// Instantiate the Unit Under Test (UUT)
	greater_than_2bit uut (
		.a(a), 
		.b(b), 
		.gt(gt)
	);

	initial begin
		$display("a[1] a[0] b[1] b[0] gt");
		for(counter=0;counter<=15;counter=counter+1'b1) begin
			a=counter[3:2];
			b=counter[1:0];
			$strobe("%b     %b     %b    %b   %b",a[1],a[0],b[1],b[0],gt);
			#10;
		end
		$stop;
	end
      
endmodule

