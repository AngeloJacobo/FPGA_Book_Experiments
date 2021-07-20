`timescale 1ns / 1ps

module mouse_test(
	input clk,rst_n,
	input key0,key1,
	inout ps2d,ps2c,
	output reg[3:0] led	
    );
	 reg [10:0] counter_reg,counter_nxt; //2 MSBs serve as index for the 4 leds
	 wire[8:0] x;
	 wire[2:0] btn;
	 wire m_done_tick;
	 //module instantiations
	mouse m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.key0(key0), //key0 will transmit code for enabling the stream mode
		.key1(key1), //key1 will reset the mouse and dosable stream  mode
		.ps2c(ps2c),
		.ps2d(ps2d),
		.x(x),
		.y(),
		.btn(btn),
		.m_done_tick(m_done_tick)
    );
	 
	 //logic for the running leds(led will follow the x-axis movememt)
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) counter_reg<=0;
		else counter_reg<=counter_nxt;
	 end
	 
	 always @* begin
		 counter_nxt=counter_reg;
		 led=4'd0;
			if(m_done_tick) begin
				if(btn[1]) counter_nxt=12'hfff;//right button pushed
				else if(btn[0]) counter_nxt=0;//left button pushed
				else begin //increment/decrement counter based on x-axis movement
					counter_nxt=(x[8]==1)? counter_reg-{~{x[7:0]}}+1 : counter_reg+x[7:0]; //note: moving left will produce a 2s complement number
				end
			end
			case(counter_reg[10:9]) 
				2'b00: led[0]=1;//leftmost
				2'b01: led[1]=1;
				2'b10: led[2]=1;
				2'b11: led[3]=1; //rightmost
				default: led[2:1]=2'b11;
			endcase
	 end
	



endmodule
