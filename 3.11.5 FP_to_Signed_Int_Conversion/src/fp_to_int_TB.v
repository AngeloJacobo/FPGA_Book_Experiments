`timescale 1ns / 1ps

module fp_to_int_TB;

	// Inputs
	reg [12:0] fp;

	// Outputs
	wire [7:0] integ;
	wire over;
	wire under;

	// Instantiate the Unit Under Test (UUT)
	fp_to_int uut (
		.fp(fp), 
		.integ(integ), 
		.over(over), 
		.under(under)
	);
	reg[3:0] i;
	initial begin
		// Initialize Inputs
		fp = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		
		//overflow test
		$display("OVERFLOW TEST");
		$display("FloatingPoint Integer  Over Under");
		for(i=4'b1111;i>7;i=i-1) begin
			#5 fp={1'b1,i,8'b1010_1111}; 
			#5 fp={1'b0,i,8'b1010_1111}; 
			#5 fp={1'b0,i,8'b0000_0000}; //test overflow exp BUT with zero frac(integer must be all be 0)
			#5 $display(" ");
			   $display(" ");
		end
		
		//underflow test
		$display("UNDERFLOW TEST");
		$display("FloatingPoint Integer  Over Under");
			#5 fp={1'b1,4'b0000,8'b1010_1111}; 
			#5 fp={1'b0,4'b0000,8'b1010_1111}; 
			#5 fp={1'b0,4'b0000,8'b0000_0000};  //test underflow BUT with zero frac(integer must all be 0)
		#5 $display(" "); 
		   $display(" ");
		
		//normal test
		$display("NORMAL TEST");
		$display("FloatingPoint Integer  Over Under");
		for(i=4'b0111;i>0;i=i-1) begin
		#5 fp={1'b1,i,8'b1111_1111};
		#5 fp={1'b0,i,8'b1111_1111};
		#5 $display(" ");
		end
		#5 fp={1'b1,i,8'b1111_1111};
		#5 fp={1'b0,i,8'b1111_1111};
			#100 $finish;
   end
	
	initial begin
      $monitor("%b %b %b    %b",fp,integ,over,under);
		end
		
		
endmodule

