`timescale 1ns / 1ps

module kb(   //extract only the real bytes from received packets of data(no break code)
	input clk,rst_n,
	input ps2d,ps2c,
	input rd_fifo,
	output [8:0] rd_data,
	output fifo_empty
    );
	 wire[10:0] dout;
	 wire rx_dont_tick;
	 wire wr;
	 wire [8:0] wr_data;
	 
 
	 ps2_rx m0
	 (
		.clk(clk),
		.rst_n(rst_n),
		.rx_en(1),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.dout(dout),
		.rx_done_tick(rx_done_tick)
    );
	 
	 kb_data m1
	 (
		.clk(clk),
		.rst_n(rst_n),
		.rx_done_tick(rx_done_tick),
		.din(dout[8:1]),
		.wr(wr),
		.wr_data(wr_data)
    );
	 
	  fifo #(.W(4),.B(9)) m2
	(
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.rd(rd_fifo), //
		.wr_data(wr_data),
		.rd_data(rd_data),//
		.full(),
		.empty(fifo_empty) //
    );
	 
endmodule


