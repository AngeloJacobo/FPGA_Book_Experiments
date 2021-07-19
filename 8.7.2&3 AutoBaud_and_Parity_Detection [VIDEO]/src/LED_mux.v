`timescale 1ns / 1ps

module LED_mux
	#(parameter N=19) //last 3 bits will be used as output. Frequency=50MHz/(2^(N-3)). So N=19 will have 763Hz
	(
	input clk,rst,
	input[5:0] in0,in1,in2,in3,in4,in5, //format: {dp,char[4:0]} , dp is active high
	output reg[7:0] seg_out,
	output reg[5:0] sel_out
    );
	 
	 reg[N-1:0] r_reg=0;
	 reg[5:0] hex_out=0;
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
			 case(hex_out[4:0])
			 5'd0: seg_out[6:0]=7'b0000_001;
			 5'd1: seg_out[6:0]=7'b1001_111;
			 5'd2: seg_out[6:0]=7'b0010_010;
			 5'd3: seg_out[6:0]=7'b0000_110;
			 5'd4: seg_out[6:0]=7'b1001_100;
			 5'd5: seg_out[6:0]=7'b0100_100;
			 5'd6: seg_out[6:0]=7'b0100_000;
			 5'd7: seg_out[6:0]=7'b0001_111;
			 5'd8: seg_out[6:0]=7'b0000_000;
			 5'd9: seg_out[6:0]=7'b0001_100;
	  /*A*/5'd10: seg_out[6:0]=7'b0001_000; 
	  /*b*/5'd11: seg_out[6:0]=7'b1100_000;
	  /*C*/5'd12: seg_out[6:0]=7'b0110_001;
	  /*d*/5'd13: seg_out[6:0]=7'b1000_010;
	  /*E*/5'd14: seg_out[6:0]=7'b0110_000;
	  /*F*/5'd15: seg_out[6:0]=7'b0111_000;
	  /*G*/5'd16: seg_out[6:0]=7'b0100_000;
	  /*H*/5'd17: seg_out[6:0]=7'b1001_000;
	  /*I*/5'd18: seg_out[6:0]=7'b1111_001;
	  /*J*/5'd19: seg_out[6:0]=7'b1000_011;
	  /*L*/5'd20: seg_out[6:0]=7'b1110_001;
	  /*N*/5'd21: seg_out[6:0]=7'b0001_001;
	  /*O*/5'd22: seg_out[6:0]=7'b0000_001;
	  /*P*/5'd23: seg_out[6:0]=7'b0011_000; 
	  /*R*/5'd24: seg_out[6:0]=7'b0001_000;
	  /*S*/5'd25: seg_out[6:0]=7'b0100_100;
	  /*U*/5'd26: seg_out[6:0]=7'b1000_001;
	  /*y*/5'd27: seg_out[6:0]=7'b1000_100;
	  /*Z*/5'd28: seg_out[6:0]=7'b0010_010; 
	/*OFF*/5'd29: seg_out[6:0]=7'b1111_111; //decimal 30 to 31 will be alloted for future use
	  /*Z*/5'd30: seg_out[6:0]=7'b1111_110; 

			 endcase
		 seg_out[7]=!hex_out[5]; //active high decimal
	 end

endmodule
