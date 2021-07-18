`timescale 1ns / 1ps

module rotate_sq
	#(parameter base_counter=10_000_000) ////frequency of rotating square is 50MHz/base_counter=50MHz/10M=5Hz (0.2 sec per box)
	(
	 input clk,rst_n,
	 input cw,en,
	 output reg[7:0] in0,in1,in2,in3,in4,in5 //1 bit=Decimal point(active low) 7 bits=seven-segment value(active low)
    );

	 reg[23:0] mod_10M=0; 
	 reg[3:0] mod_12=0; //12 turns since the square will rotate in 6 seven-segments
	 wire[23:0] mod_10M_nxt;
	 reg[3:0] mod_12_nxt=0;
	 
	 //registers
	 always @(posedge clk,negedge rst_n) begin
		 if(!rst_n) begin
			mod_10M<=0;
			mod_12<=0;
			end	
		else begin
			if(en) begin //if not enable then do nothing
				mod_10M<=mod_10M_nxt;
				mod_12<=mod_12_nxt;
				end
			end		
	end
	
	//next-state logic for mod_25M
	assign mod_10M_nxt=(mod_10M==base_counter-1)?24'd0:mod_10M+1'b1;
	assign mod_10M_max=(mod_10M==base_counter-1)?1'b1:1'b0;
	
	//next-state logic for mod_12
	always @* begin
	mod_12_nxt=mod_12;
		if(mod_10M_max) begin
			if(cw) mod_12_nxt=(mod_12==11)?4'd0: mod_12+1'b1; //clock-wise= 0-to-11 then back to zero
			else mod_12_nxt=(mod_12==0)?4'd11:mod_12-1'b1;    //counterclock-wise= 11-to-zero then back to 11
		end
	end
	
	
	//mod_12 tells which of the 6 seven-segments will turn-on and whether its the upper box or lower box 
	always @* begin
	   in0=8'hff; in1=8'hff; in2=8'hff; in3=8'hff; in4=8'hff; in5=8'hff; //default off(active low)
		case(mod_12) 
			4'd0: in5={1'b1,7'b0011100}; //Upper box
			4'd1: in4={1'b1,7'b0011100};
			4'd2: in3={1'b1,7'b0011100};
			4'd3: in2={1'b1,7'b0011100};
			4'd4: in1={1'b1,7'b0011100};
			4'd5: in0={1'b1,7'b0011100};
			
			4'd6: in0={1'b1,7'b1100010}; //Lower box
			4'd7: in1={1'b1,7'b1100010};
			4'd8: in2={1'b1,7'b1100010};
			4'd9: in3={1'b1,7'b1100010};
		  4'd10: in4={1'b1,7'b1100010};
		  4'd11: in5={1'b1,7'b1100010};
		endcase
	end
	
endmodule
