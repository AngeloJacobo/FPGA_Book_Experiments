`timescale 1ns / 1ps


module binary_decoder_4x16_TB;

	// Inputs
	reg [3:0] a;

	// Outputs
	wire [15:0] bcode;

	// Instantiate the Unit Under Test (UUT)
	binary_decoder_4x16 uut (
		.a(a), 
		.bcode(bcode)
	);

	reg[4:0] counter;
	initial begin
		$display("a[3]  a[2] a[1] a[0] bcode");
		for(counter=0;counter<=15;counter=counter+1'b1) begin
			a=counter[3:0];
			$strobe(" %b     %b    %b    %b   %b",a[3],a[2],a[1],a[0],bcode);
			#10;
		end
	end   
      
endmodule

