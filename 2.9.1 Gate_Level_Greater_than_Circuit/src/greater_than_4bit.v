`timescale 1ns / 1ps

module greater_than_4bit(
	input wire[3:0] a,b,
	output wire gt
    );
	 
	 wire[1:0] a1,a0,b1,b0 ; //a1=2 MSB of "a" input , a0=2 LSB of "a" input , b1=2 MSB of "b" input , b0=2 LSB of "b" input
	 wire gt1,gt0; //gt1=true if a1>b1 , g0=true if a0>b0
	 wire aeqb;
	 assign a1=a[3:2],
				a0=a[1:0],
				b1=b[3:2],
				b0=b[1:0];
				
	 //overall logic for 4-bit greater than circuit
	 assign gt=gt1 || (aeqb&&gt0);
	 
	 greater_than_2bit m0
	 (
		.a(a1),
		.b(b1),
		.gt(gt1)
    );
	 
	 greater_than_2bit m1
	 (
		.a(a0),
		.b(b0),
		.gt(gt0)
    );
	 
	 eq2 m2
	 (
		.a(a1),
		.b(b1), 
		.aeqb(aeqb) 
    );


endmodule
