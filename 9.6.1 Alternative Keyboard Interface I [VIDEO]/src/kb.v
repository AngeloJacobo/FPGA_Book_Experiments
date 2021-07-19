`timescale 1ns / 1ps

module kb(   //extract only the real bytes from received packets of data(no break code)
	input clk,rst_n,
	input ps2d,ps2c,
	input rd_fifo,
	output [7:0] rd_data,
	output fifo_empty
    );
	 wire[10:0] dout;
	 wire rx_dont_tick;
	 wire wr;
	 wire [7:0] wr_data;
	 
 
	 ps2_rx m0 //receive packets from ps2 keyboard
	 (
		.clk(clk),
		.rst_n(rst_n),
		.rx_en(1),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.dout(dout),
		.rx_done_tick(rx_done_tick)
    );
	 
	 kb_data m1 //extract the real data from the packets(the hex f0(break code) is removed)
	 (
		.clk(clk),
		.rst_n(rst_n),
		.rx_done_tick(rx_done_tick),
		.din(dout[8:1]),
		.wr(wr),
		.wr_data(wr_data)
    );
	 
	  fifo #(.W(4),.B(8)) m2 //store the packets of data
	(
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.rd(rd_fifo), 
		.wr_data(wr_data),
		.rd_data(rd_data),
		.full(),
		.empty(fifo_empty) 
    );
	 
endmodule


