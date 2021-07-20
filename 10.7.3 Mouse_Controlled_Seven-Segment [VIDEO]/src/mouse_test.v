`timescale 1ns / 1ps

module mouse_test(
	input clk,rst_n,
	input key0,key1,
	inout ps2d,ps2c,
	output[7:0] seg_out,
	output[5:0] sel_out	
    );
	 reg [10:0] xcounter_reg,xcounter_nxt; //3 MSBs serve as index for the 6 seven-segments(movement of x-axis)
	 reg [10:0] ycounter_reg,ycounter_nxt; //4 MSBs serve as index for the counter displayed on the seven segment(movement of the y-axis)
	 reg[5:0] in0,in1,in2,in3,in4,in5;
	 wire[8:0] x,y;
	 wire[2:0] btn;
	 wire m_done_tick;
	mouse m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.key0(key0),
		.key1(key1),
		.ps2c(ps2c),
		.ps2d(ps2d),
		.x(x),
		.y(y),
		.btn(btn),
		.m_done_tick(m_done_tick)
    );
	 LED_mux m1
	(
		.clk(clk),
		.rst(rst_n), 
		.in0(in0),
		.in1(in1),
		.in2(in2),
		.in3(in3),
		.in4(in4),
		.in5(in5), //format: {dp,char[4:0]} , dp is active high
		.seg_out(seg_out),
		.sel_out(sel_out)
    );
	 //logic for the counter of x and y-axis movement
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			xcounter_reg<=0;
			ycounter_reg<=0;
		end
		else begin
			xcounter_reg<=xcounter_nxt;
			ycounter_reg<=ycounter_nxt;			
		end
	 end
	 
	 always @* begin
		 xcounter_nxt=xcounter_reg;
		 ycounter_nxt=ycounter_reg;
		 in0=6'd28; //code for off-seven segment
		 in1=6'd28;
		 in2=6'd28;
		 in3=6'd28;
		 in4=6'd28;
		 in5=6'd28;
		 
			if(m_done_tick) begin
				if(btn[1]) xcounter_nxt={3'b101,8'd0};//right button pushed=rightmost seven-segment on
				else if(btn[0]) xcounter_nxt=0;//left button pushed=leftmost seven-segment on
				else begin //increment counter based on x-axis and y-axis movement
					xcounter_nxt=(x[8]==1)? xcounter_reg-{~{x[7:0]}}+1 : xcounter_reg+x[7:0];
					ycounter_nxt=(y[8]==1)? ycounter_reg-{~{y[7:0]}}+1 : ycounter_reg+y[7:0];
					
					if(xcounter_nxt[10:8]==3'd6) xcounter_nxt[10:8]=3'd0;
					else if(xcounter_nxt[10:8]==3'd7) xcounter_nxt[10:8]=3'd5;
					if(ycounter_nxt[10:7]==4'd10) ycounter_nxt[10:7]=4'd0;
					else if(ycounter_nxt[10:7]==4'd15) ycounter_nxt[10:7]=4'd9;
				end
			end
			case(xcounter_nxt[10:8]) //chooses which seven-segment will display the y movement counter
				3'd0: in5={2'd0,ycounter_nxt[10:7]};
				3'd1: in4={2'd0,ycounter_nxt[10:7]};
				3'd2: in3={2'd0,ycounter_nxt[10:7]};
				3'd3: in2={2'd0,ycounter_nxt[10:7]};
				3'd4: in1={2'd0,ycounter_nxt[10:7]};
				3'd5: in0={2'd0,ycounter_nxt[10:7]};
			endcase
			
	 end
	



endmodule
