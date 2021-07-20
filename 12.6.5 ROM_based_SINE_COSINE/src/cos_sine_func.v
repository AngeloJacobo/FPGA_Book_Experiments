`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:28:25 06/13/2021 
// Design Name: 
// Module Name:    sine_func 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module cos_sine( 
	input clk,rst_n,
	input[9:0] x, //input has a 10-bit resolution(from 0 to 2pi)
	output[7:0] y_sine,y_cos //output has 8-bit resolution(from -1 to 1)
    );
	 
	reg[7:0] y_sine_q=0,y_sine_d,y_cos_q=0,y_cos_d;
	reg[7:0] x_sine_addr,x_cos_addr; //determines the address to be inserted in ROM
	wire[6:0] dout_sine,dout_cos;
	
	always  @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			y_sine_q<=0;
			y_cos_q<=0;
		end
		else begin
			y_sine_q<=y_sine_d;
			y_cos_q<=y_cos_d;
		end
	end
	
	//logic to obtain values of other quadrants
	always @* begin
		y_sine_d=y_sine_q;
		y_cos_d=y_cos_q; 
		
		case(x[9:8]) //logic for sine and cosine output , middle point of sine/cosine wave is at 2^7
			2'b00: begin	//first quadrant(0 to pi/2 for sine, and pi/2 to pi for cosine)    
						x_sine_addr=x[7:0]; 
						y_sine_d=dout_sine+2**7;
						
						x_cos_addr=255-x[7:0];
						y_cos_d=dout_cos+2**7;
					end
			2'b01: begin  //second quadrant(pi/2 to pi for sine, and pi to 3pi/2 for cosine)
						x_sine_addr=255-x[7:0]; 
						y_sine_d=dout_sine+2**7;
						
						x_cos_addr=x[7:0];
						y_cos_d=2**7-dout_cos;
					 end
			2'b10: begin  //third quadrant(pi to 3pi/2 for sine, and 3pi/2 to 2pi for cosine)
						x_sine_addr=x[7:0];
						y_sine_d=2**7-dout_sine;
						
						x_cos_addr=255-x[7:0];
						y_cos_d=2**7-dout_cos;
					 end
			2'b11: begin  //fourth quadrant(3pi/2 to 2pi for sine, and 2pi(0) to 5/2pi(pi/2) for cos))
						x_sine_addr=255-x[7:0];
						y_sine_d=2**7-dout_sine;
						
						x_cos_addr=x[7:0];
						y_cos_d=dout_cos+2**7;
					 end
		endcase

	end
	
	assign y_sine=y_sine_q;
	assign y_cos=y_cos_q;

	
	dual_port_rom m0
	(
	  .clka(clk), // input clka
	  .addra(x_sine_addr), // input [7 : 0] addra
	  .douta(dout_sine), // output [6 : 0] douta
	  .clkb(clk), // input clkb
	  .addrb(x_cos_addr), // input [7 : 0] addrb
	  .doutb(dout_cos) // output [6 : 0] doutb
	);


endmodule

