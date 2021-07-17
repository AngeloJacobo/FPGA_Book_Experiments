`timescale 1ns / 1ps

module binary_decoder_2x4_TB;

	// Inputs
	reg en;
	reg [1:0] a;

	// Outputs
	wire [3:0] bcode;

	// Instantiate the Unit Under Test (UUT)
	binary_decoder_2x4 uut (
		.en(en), 
		.a(a), 
		.bcode(bcode)
	);
	reg[3:0] counter;
	initial begin
		$display("en a[1] a[0] bcode");
		for(counter=0;counter<=7;counter=counter+1'b1) begin
			{en,a}=counter[2:0];
			$strobe("%b   %b    %b   %b",en,a[1],a[0],bcode);
			#10;
		end
	end
      
endmodule

