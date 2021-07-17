`timescale 1ns / 1ps

module binary_decoder_4x16(
	input[3:0] a,
	output[15:0] bcode
    );
	 binary_decoder_2x4 m0
	 (
		 .en({!a[3] && !a[2]}),
		 .a(a[1:0]),
		 .bcode(bcode[3:0])
    );
	 
	 binary_decoder_2x4 m1
	 (
		 .en({!a[3] && a[2]}),
		 .a(a[1:0]),
		 .bcode(bcode[7:4])
    );
	 
	 binary_decoder_2x4 m2
	 (
		 .en({a[3] && !a[2]}),
		 .a(a[1:0]),
		 .bcode(bcode[11:8])
    ); 
	 
	 binary_decoder_2x4 m3
	 (
		 .en({a[3] && a[2]}),
		 .a(a[1:0]),
		 .bcode(bcode[15:12])
    );
	 


endmodule
