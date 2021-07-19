`timescale 1ns / 1ps

module uart_plus_stopwatch(
	input clk,rst_n,
	input rx,
	output[7:0] seg_out,
	output[5:0] sel_out,
	output tx
    );
	 
	 reg rd_uart;
	 wire rx_empty;
	 wire[7:0] rd_data;
	 reg clr; //clr=1 is clear
	 reg up_reg=1,up_nxt; //up=1 is upward
	 reg go_reg=0,go_nxt; //go=1 is play
	 reg wr_uart;
	 reg[7:0] displaytime[5:0];
	 reg[7:0] wr_data,wr_data_nxt;
	 wire[4:0] in0,in1,in2,in3,in4,in5;
	 reg[2:0] index=0,index_nxt; //index to determine what wr_data will be written to UART. This will be the index for the register file
	 reg lock=0,lock_nxt; //this will stay at "1' until all necessary wr_data is transmitted
	Enhanced_Stopwatch m0
	(   
		.clk(clk),
		.rst_n(rst_n),
		.up(up_reg),
		.go(go_reg),
		.clr(clr), // up-> 1:Count up 0:Count down    go->1:play 0:pause    clr-->back to 0.00.0
		.in0(in0),
		.in1(in1),
		.in2(in2),
		.in3(in3),
		.in4(in4),
		.in5(in5)
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
		.in5(in5),
		.seg_out(seg_out),
		.sel_out(sel_out)
    );
	 uart #(.DBIT(8),.SB_TICK(16),.DVSR(326),.DVSR_WIDTH(9),.FIFO_W(4)) m2
	(
		.clk(clk),
		.rst_n(rst_n),
		.rd_uart(rd_uart),
		.wr_uart(wr_uart),
		.wr_data(wr_data),
		.rx(rx),
		.tx(tx),
		.rd_data(rd_data),
		.rx_empty(rx_empty),
		.tx_full()
    );
	 
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			index<=0;
			up_reg<=1;
			go_reg<=0;
			lock<=0;

		end
		else begin
			index<=index_nxt;
			up_reg<=up_nxt;
			go_reg<=go_nxt;
			lock<=lock_nxt;

		end
	 end
	 always @* begin
		up_nxt=up_reg;
		go_nxt=go_reg;
		lock_nxt=lock;
		index_nxt=index;
		wr_uart=0;
		rd_uart=0;
		clr=0;
		
		if(!rx_empty) begin
			if(rd_data==8'h43 || rd_data==8'h63) begin //c or C clears stopwatch
				clr=1;
				up_nxt=1;
			end
			else if (rd_data==8'h47|| rd_data==8'h67) begin //g or G plays the stopwatch
				go_nxt=1;
			end
			else if (rd_data==8'h50 || rd_data==8'h70) begin //p or P pauses stopwatch
				go_nxt=0;
			end
			else if(rd_data==8'h55 || rd_data==8'h75) begin //u or U reverses direction of stopwatch
				up_nxt=!up_reg;
			end
			else if(rd_data==8'h52 || rd_data==8'h72) begin //r or R transmits current time to UART tx
				lock_nxt=1;
				index_nxt=0;
			end
			rd_uart=1;
		end
		
		if(lock) begin
			wr_data=displaytime[index];
			wr_uart=1;
			if(index==5) lock_nxt=0; //finish transmitting all data btyes
			else index_nxt=index+1;
		end	
	 end
	 
	 always @* begin //
		displaytime[0]={4'h3,in3[3:0]};//minutes
		displaytime[1]=8'h3a; //":"
		displaytime[2]={4'h3,in2[3:0]}; //second-digit of seconds
		displaytime[3]={4'h3,in1[3:0]}; //first-digit of seconds
		displaytime[4]=8'h3a; //":"
		displaytime[5]={4'h3,in0[3:0]};	//decimal or the 100ms
	 end
	 


endmodule
