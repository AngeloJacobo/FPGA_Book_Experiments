`timescale 1ns / 1ps



module binary_decoder_3x8_TB;

	// Inputs
	reg [2:0] a;

	// Outputs
	wire [7:0] bcode;
	
	// Instantiate the Unit Under Test (UUT)
	binary_decoder_3x8 uut ( 
		.a(a), 
		.bcode(bcode)
	);
	
	reg[3:0] counter;
	initial begin
		$display("a[2] a[1] a[0] bcode");
		for(counter=0;counter<=7;counter=counter+1'b1) begin
			a=counter[2:0];
			$strobe(" %b    %b    %b   %b",a[2],a[1],a[0],bcode);
			#10;
		end
	end      
endmodule

