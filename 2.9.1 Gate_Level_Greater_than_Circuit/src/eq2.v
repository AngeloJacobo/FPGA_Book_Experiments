`timescale 1ns / 1ps

module eq2(
	input wire[1:0] a, b, 
	output wire aeqb 
    );

	// internal signal declar.ation 
	wire eO, e1;

	// instantiate ~H'O I- bit comparators 
	eq1 eq_bit0_unit(.i0(a[0]), .i1(b[0]) , .eq(eO)) ; 
	eq1 eq_bitl_unit(.eq(e1), .i0(a[1]), .i1(b[1])); 
 // a and b are equal if individual bits are equal 
	assign aeqb = eO & e1; 
endmodule 

