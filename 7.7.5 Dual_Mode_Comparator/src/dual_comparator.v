`timescale 1ns / 1ps

module dual_comparator(
	input[7:0] a,b,
	input mode,
	output signed agtb
    );
	 wire signed [7:0] a_signed,b_signed; ///storage for signed operation
	 wire[7:0] a_unsigned,b_unsigned; //storage for unsigned operation
	 
	 assign a_signed=a,
				 b_signed=b,
				 a_unsigned=a,
				 b_unsigned=b;
 
	 
	 assign agtb=mode? ((a_signed>b_signed)?1:0) : ((a_unsigned>b_unsigned)?1:0);
				


endmodule
