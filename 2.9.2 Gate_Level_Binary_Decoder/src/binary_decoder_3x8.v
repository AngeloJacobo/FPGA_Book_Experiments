`timescale 1ns / 1ps

module binary_decoder_3x8(
	input[2:0] a,
	output[7:0] bcode
    );
	 
	 binary_decoder_2x4 m0
	 (
		 .en({!a[2]}),
		 .a(a[1:0]),
		 .bcode(bcode[3:0])
    );
	 
	 binary_decoder_2x4 m1
	 (
		 .en(a[2]),
		 .a(a[1:0]),
		 .bcode(bcode[7:4])
    );


endmodule
