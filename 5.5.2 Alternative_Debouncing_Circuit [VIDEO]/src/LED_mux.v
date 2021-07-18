`timescale 1ns / 1ps

module LED_mux
	#(parameter N=19) //last 3 bits will be used as output. Frequency=50MHz/(2^(N-3)). So N=19 will have 763Hz
	(
	input clk,rst,
	input[4:0] in0,in1,in2,in3,in4,in5, //format: {dp,hex[3:0]}
	output reg[7:0] seg_out,
	output reg[5:0] sel_out
    );
	 
	 reg[N-1:0] r_reg=0;
	 reg[4:0] hex_out=0;
	 wire[N-1:0] r_nxt;
	 wire[2:0] out_counter; //last 3 bits to be used as output signal
	 
	 
	 //N-bit counter
	 always @(posedge clk,negedge rst)
	 if(!rst) r_reg<=0;
	 else r_reg<=r_nxt;
	 
	 assign r_nxt=(r_reg=={3'd5,{(N-3){1'b1}}})?19'd0:r_reg+1'b1; //last 3 bits counts from 0 to 5(6 turns) then wraps around
	 assign out_counter=r_reg[N-1:N-3];
	 
	 
	 //sel_out output logic
	 always @(out_counter) begin
		 sel_out=6'b111_111;    //active low
		 sel_out[out_counter]=1'b0;
	 end
	  
	 //hex_out output logic
	 always @* begin
		 hex_out=0;
			 casez(out_counter)
			 3'b000: hex_out=in0;
			 3'b001: hex_out=in1;
			 3'b010: hex_out=in2;
			 3'b011: hex_out=in3;
			 3'b100: hex_out=in4;
			 3'b101: hex_out=in5;
			 endcase
	 end
	 	 
	 //hex-to-seg decoder
	 always @* begin
		 seg_out=0;
			 case(hex_out[3:0])
			 4'h0: seg_out[6:0]=7'b0000_001;
			 4'h1: seg_out[6:0]=7'b1001_111;
			 4'h2: seg_out[6:0]=7'b0010_010;
			 4'h3: seg_out[6:0]=7'b0000_110;
			 4'h4: seg_out[6:0]=7'b1001_100;
			 4'h5: seg_out[6:0]=7'b0100_100;
			 4'h6: seg_out[6:0]=7'b0100_000;
			 4'h7: seg_out[6:0]=7'b0001_111;
			 4'h8: seg_out[6:0]=7'b0000_000;
			 4'h9: seg_out[6:0]=7'b0001_100;
			 4'ha: seg_out[6:0]=7'b0001_000;
			 4'hb: seg_out[6:0]=7'b1100_000;
			 4'hc: seg_out[6:0]=7'b0110_001;
			 4'hd: seg_out[6:0]=7'b1000_010;
			 4'he: seg_out[6:0]=7'b0110_000;
			 4'hf: seg_out[6:0]=7'b0111_000;
			 endcase
		 seg_out[7]=!hex_out[4]; //active high decimal
	 end

endmodule
