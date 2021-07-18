`timescale 1ns / 1ps

module parking_lot_counter_TB;

	// Inputs
	reg clk;
	reg rst_n;
	reg a;
	reg b;

	// Outputs
	wire enter;
	wire exit;

	// Instantiate the Unit Under Test (UUT)
	parking_lot_counter uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.a(a), 
		.b(b), 
		.enter(enter), 
		.exit(exit)
	);
	always begin
		clk=0;
		#5;
		clk=1;
		#5;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 1;
		a = 0;
		b = 0;
	

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		{a,b}=2'b00;
		#50 {a,b}=2'b01;
		#50 {a,b}=2'b11;
		#50 {a,b}=2'b01;
		#50 {a,b}=2'b11;
		#50 {a,b}=2'b10;
		#50 {a,b}=2'b00; //exit=1
		
		#100;
		#50 {a,b}=2'b10;
		#50 {a,b}=2'b11;
		#50 {a,b}=2'b00;
		#50 {a,b}=2'b10;
		#50 {a,b}=2'b11;
		#50 {a,b}=2'b01;
		#50 {a,b}=2'b00; 
		#100 $stop;	//entered=1

	end
      
endmodule

