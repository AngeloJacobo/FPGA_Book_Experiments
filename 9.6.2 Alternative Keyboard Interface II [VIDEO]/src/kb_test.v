`timescale 1ns / 1ps

module kb_test(
	input clk,rst_n,
	input ps2d,ps2c,
	output tx
    );
	 wire rd_fifo;
	 wire[8:0] rd_data;
	 wire[7:0] ascii;
	 wire fifo_empty;
	 kb m0 //extract only the real bytes(only the makecode,no breakcode) from received packets of data. Data is stored at fifo waiting to be read
	 (
		.clk(clk),
		.rst_n(rst_n),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.rd_fifo({!fifo_empty}),
		.rd_data(rd_data),
		.fifo_empty(fifo_empty) 
    );
	 
	 ascii_conv m1 //converts data from "kb" module to ASCII
	 (
		.rd_data(rd_data),
		.ascii(ascii)
    );
	 
	 uart #(.DBIT(8),.SB_TICK(16),.DVSR(326),.DVSR_WIDTH(9),.FIFO_W(4)) m2//baudrate=9600  transfers the ASCII to pc
	(
		.clk(clk),
		.rst_n(rst_n),
		.rd_uart(0),
		.wr_uart({!fifo_empty}),
		.wr_data(ascii),
		.rx(1),
		.tx(tx),
		.rd_data(),
		.rx_empty(),
		.tx_full()
    );
	 



endmodule
