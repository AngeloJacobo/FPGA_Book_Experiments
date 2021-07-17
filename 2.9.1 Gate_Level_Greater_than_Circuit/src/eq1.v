`timescale 1ns / 1ps

module eq1(
	input wire i0,i1,
	output wire eq
    );
	// signal declaration 
	wire p0, pl; 

	// body 
	// sum of two product terms 
	assign eq = p0 || pl; 
	
	// product terms 
	assign p0 = ~i0 & ~i1; 
	assign pl = i0 & i1;

endmodule
