`timescale 1ns / 1ps

module kb_interface(
	input clk,rst_n,
	input ps2d,ps2c,
	output[7:0] seg_out,
	output[5:0] sel_out
    );
	 reg up_reg=1,up_nxt;
	 reg go_reg=0,go_nxt;
	 reg clr=0;
	 reg rd_fifo;
	 
	 wire[5:0] in0,in1,in2,in3,in4,in5;
	 wire fifo_empty;
	 wire[8:0] rd_data;
	 
	 //register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			up_reg<=1;
			go_reg<=0;
		end
		else begin
			up_reg<=up_nxt;
			go_reg<=go_nxt;
		end
	 end
	 //next-state logic
	 always @* begin
		up_nxt=up_reg;
		go_nxt=go_reg;
		clr=0;
		rd_fifo=0;
		if(!fifo_empty) begin 
			if(rd_data[7:0] == 8'h21) begin //C for clear
				clr=1;
				up_nxt=1;
			end
			else if(rd_data[7:0] == 8'h34) go_nxt=1; //G for go
			else if(rd_data[7:0] == 8'h4d) go_nxt=0; //P for pause
			else if(rd_data[7:0] == 8'h3c) up_nxt=!up_reg; //U to reverse the counting
			rd_fifo=1;
		end
	 end
	 
	 
	kb m0
	(   //extract only the real bytes from received packets of data(no break code)
		.clk(clk),
		.rst_n(rst_n),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.rd_fifo(rd_fifo),//
		.rd_data(rd_data), //{shift,data}
		.fifo_empty(fifo_empty)
    );
	 
	 Enhanced_Stopwatch m1
	 (   
		.clk(clk),
		.rst_n(rst_n),
		.up(up_reg),
		.go(go_reg), // up-> 1:Count up 0:Count down    go->1:play 0:pause
		.clr(clr),
		.in0(in0), //5 bits={dp,hex}
		.in1(in1),
		.in2(in2),
		.in3(in3),
		.in4(in4),
		.in5(in5)
    );
	 
	 LED_mux
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



endmodule
