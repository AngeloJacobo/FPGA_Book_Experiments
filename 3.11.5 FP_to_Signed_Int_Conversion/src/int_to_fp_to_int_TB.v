`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:37:15 02/16/2021
// Design Name:   int_to_fp
// Module Name:   C:/Users/riyos/Desktop/Xilinx FPGA/My Projects/FP_to_SignedInt_CONVERSION/src/int_to_fp_to_int_TB.v
// Project Name:  FP_to_SignedInt_CONVERSION
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: int_to_fp
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module int_to_fp_to_int_TB;


	reg [7:0] integ;
	wire [12:0] fp;
	int_to_fp uut (
		.integ(integ), 
		.fp(fp)
	);
	
	reg[12:0] fp_new;
	wire[7:0] integ_new;
	wire over,under;
	fp_to_int uut2(
		.fp(fp_new), 
		.integ(integ_new), 
		.over(over), 
		.under(under)
	 );
	 
	initial begin
		// Initialize Inputs
		integ = 0;

		// Wait 100 ns for global reset to finish
		#100;
		for(integ={8{1'b1}};integ>0;integ=integ-1) begin  //test from 1111_1111 to 0000_0000
			#5
			fp_new=fp;
			#5;
			if(integ!=integ_new) $display("ERRROORRRRR");  
			#5 $display("%b %b",integ,integ_new);
			$display(" ");
		end
		#100 $finish;
	end
	
	
	initial begin
	$display("integ    integ_new");
	end
      
endmodule

