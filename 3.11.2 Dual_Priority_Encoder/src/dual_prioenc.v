`timescale 1ns / 1ps

module dual_prioenc(
	input wire[11:0] in,
	output reg[3:0] first,second
    );
	 integer i;

	 always @(in) begin
	 first=4'd0;
	 second=4'd0;

	 
	 for(i=11;i>=0;i=i-1) begin  //use for-loop to locate the bit "1"
	 if(in[i] && !first) first=i+1;
	 else if(first && in[i] && !second) second=i+1; //if "first" already has a value,then the next bit of 1 will be the "second"
	 end
	 end
	
endmodule 
