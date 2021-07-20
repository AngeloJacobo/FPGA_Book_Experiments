`timescale 1ns / 1ps

module timer( //2 second timer
	input clk,rst_n,
	input timer_start,timer_tick,
	output timer_up
    );
	 
	 reg[6:0] timer_q=0,timer_d;
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) timer_q<=0;
		else timer_q<=timer_d;
	 end
	 
	 always @* begin
		timer_d=timer_q;
		if(timer_start) begin
			timer_d=7'b111_1111;
		end
		else if(timer_tick) begin //timer tick is 60Hz, thus 2 seconds will be after 120 ticks(or 7'b111_1111)
			timer_d=(timer_q==0)? 0:timer_q-1;
		end
	 end
	 assign timer_up= (timer_q==0);


endmodule
