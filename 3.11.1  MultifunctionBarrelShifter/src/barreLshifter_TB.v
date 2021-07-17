`timescale 1ns / 1ps

module barreLshifter;

	// Inputs
	reg [15:0] num;
	reg [3:0] amt;
	reg LR;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	Multi_Barrel_Shifter8x16x32x #(.N(16),.M(4)) uut (
		.num(num), 
		.amt(amt), 
		.LR(LR), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
			num = 0;
			amt = 0;
			LR = 0; //0=right, 1=left

			#100
			#10 num=16'b11111111_00000000;
			
			//Rotate right bit by bit
			$display("ROTATE RIGHT");
			for(amt=4'd0;amt<4'b1111;amt=amt+1) begin
				#5 $display("%b",out);
			end
			#5 $display("%b",out);
			
			
			
			//Rotate left bit by bit
			$display(" ");
			$display("ROTATE LEFT");
			LR=1;
			for(amt=4'd0;amt<4'b1111;amt=amt+1) begin
				#5 $display("%b",out);
			end
			#5 $display("%b",out);
			
		#100 $finish;
		end
			
		
      
endmodule

