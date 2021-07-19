`timescale 1ns / 1ps

module baud_generator
	(
	input clk,rst_n,
	input[11:0] baud_dvsr, //2605 for 12000baud , 1303 for 2400baud , 652 for 4800baud , 326 for 9600baud , 162 for 19200 , 27 for 115200
	output reg s_tick
    );
	 reg[11:0] counter=0;
	 reg[11:0] baud_dvsr_reg;//use to store the last value of dvsr input. If the dvsr changes, the counter resets (with this, there will be no delay)
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			counter<=0;
			baud_dvsr_reg<=0;
		end
		else begin
			s_tick=0;
			if(baud_dvsr_reg!=baud_dvsr) counter<=0;
			else if(counter==baud_dvsr_reg-1) begin
				s_tick=1;
				counter<=0;
			end
			else begin
				counter<=counter+1;
			end
			baud_dvsr_reg<=baud_dvsr;
		end
	 end
	 
endmodule
