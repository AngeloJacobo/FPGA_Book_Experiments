`timescale 1ns / 1ps

module led_dimmer(
	input clk,rst_n,
	input en,
	input[3:0] w, //4-bit resolution. Duty cycle=w/16
	output pwm
    );
	 
	 reg[3:0] counter_reg=0;
	 reg pwm_reg=0;
	 wire[3:0] counter_nxt;
	 wire pwm_nxt;
	 wire max_tick;
	 
	 //registers
	 always @(posedge clk,negedge rst_n) begin
		 if(!rst_n) begin
			counter_reg<=0;
			pwm_reg<=0;
		 end
		 else begin
			if(en) begin
			counter_reg<=counter_nxt;
			pwm_reg<=pwm_nxt;
			end
			else begin 
			counter_reg<=0;
			pwm_reg<=0;
			end
		 end
	 end
	 
	 //next-state logic for counter
	 assign counter_nxt=(counter_reg==4'd15)?0:counter_reg+1;
	 assign max_tick=(counter_reg==4'd15)?1:0;
	 
	 //next state logic for pwm_reg
	 assign pwm_nxt=max_tick? (w?1:0) : ((counter_nxt==w)?0:pwm_reg);//if w is logic 1 then the period will start with 1, but if w is zero then obviously it will start with 0
	 
	 //output
	 assign pwm=pwm_reg;
	 
	 


endmodule
