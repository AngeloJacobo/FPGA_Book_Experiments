`timescale 1ns / 1ps

module fp_greaterthan(
	input wire[12:0] first,second,
	output reg gt
    );
	 always @* begin
	 gt=1'b0;
	 if(!first[12] && !second[12] && first[11:0]>second[11:0] ) gt=1'b1;  //if first and second are both positive
	 else if(first[12] && second[12] && first[11:0]<second[11:0]) gt=1'b1; //if first and second are both negative
	 else if(!first[12] && second[12]) gt=1'b1; //if first is positive and second is negative
	 end 


endmodule
