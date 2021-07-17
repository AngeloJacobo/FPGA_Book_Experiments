`timescale 1ns / 1ps

module greater_than_2bit(
	input  wire[1:0] a,b,
	output wire gt
    );
	 
	 //signal declarations for terms in sum-of-product 
	 wire sp1,sp2,sp3,sp4,sp5,sp6;
	 
	 //use table as reference
	 assign sp1= !a[1] & a[0] & !b[1] & !b[0];
	 assign sp2= a[1] & !a[0] & !b[1] & !b[0];
	 assign sp3= a[1] & !a[0] & !b[1] & b[0];
	 assign sp4= a[1] & a[0] & !b[1] & !b[0];
	 assign sp5= a[1] & a[0] & !b[1] & b[0];
	 assign sp6= a[1] & a[0] & b[1] & !b[0];
	 
	 assign gt = sp1 || sp2 || sp3 || sp4 || sp5 || sp6;


endmodule
