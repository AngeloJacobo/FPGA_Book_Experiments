`timescale 1ns / 1ps

module greater_than_4bit_TB;

	// Inputs
	reg [3:0] a;
	reg [3:0] b;

	// Outputs
	wire gt;
	reg[8:0] counter;
	// Instantiate the Unit Under Test (UUT)
	greater_than_4bit uut (
		.a(a), 
		.b(b), 
		.gt(gt)
	);

	initial begin
		$display("a b  gt");
		for(counter=0;counter<=255;counter=counter+1'b1) begin
			a=counter[7:4];
			b=counter[3:0];
			$strobe("%0d %0d  %b",a,b,gt);
			#10;
		end
		$stop;

	end
      
endmodule

