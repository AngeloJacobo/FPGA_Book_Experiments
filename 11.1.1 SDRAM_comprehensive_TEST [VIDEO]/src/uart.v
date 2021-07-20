`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:43:21 04/09/2021 
// Design Name: 
// Module Name:    uart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
   module uart
	#(parameter DBIT=8,SB_TICK=16,DVSR=326,DVSR_WIDTH=9,FIFO_W=2)
	(
	input clk,rst_n,
	input rd_uart,wr_uart,
	input[7:0] wr_data,
	input rx,
	output tx,
	output[7:0] rd_data,
	output rx_empty,tx_full
    );

	 
	 wire s_tick,rx_done_tick,empty;
	 wire[7:0] dout,rd_data_tx;
	 
	 
	baud_generator #(.N(DVSR),.N_width(DVSR_WIDTH)) m0
	(
	.clk(clk),
	.rst_n(rst_n),
	.s_tick(s_tick)
    );
	 
	 uart_rx #(.DBIT(DBIT),.SB_TICK(SB_TICK)) m1 //DBIT=data bits , SB_TICK=ticks for stop bit (16 for 1 bit ,32 for 2 bits)
	(
		.clk(clk),
		.rst_n(rst_n),
		.rx(rx),
		.s_tick(s_tick),
		.rx_done_tick(rx_done_tick),
		.dout(dout)
    );
	 fifo #(.W(FIFO_W),.B(DBIT)) m2
	(
		.clk(clk),
		.rst_n(rst_n),
		.wr(rx_done_tick),
		.rd(rd_uart),
		.wr_data(dout),
		.rd_data(rd_data),
		.full(),
		.empty(rx_empty)
    );
	uart_tx #(.DBIT(DBIT),.SB_TICK(SB_TICK)) m3
	(
		.clk(clk),
		.rst_n(rst_n),
		.s_tick(s_tick), 
		.tx_start(empty),
		.din(rd_data_tx),
		.tx_done_tick(tx_done_tick),
		.tx(tx)
    );
	 fifo #(.W(FIFO_W),.B(DBIT)) m4
	(
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr_uart),
		.rd(tx_done_tick),
		.wr_data(wr_data),
		.rd_data(rd_data_tx),
		.full(tx_full),
		.empty(empty)
    );

endmodule
