`timescale 1ns / 1ps

module ps2_rxtx(
	input clk,rst_n,
	input[7:0] din, //8 bit data for tx
	input wr_ps2,
	inout ps2d,ps2c,
	output[10:0] dout, //11bit-data received from rx
	output rx_done_tick,
	output tx_done_tick
    );
	 wire tx_idle;
	 
	 ps2_rx m0
	 (
		.clk(clk),
		.rst_n(rst_n),
		.rx_en(tx_idle),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.dout(dout), //startbit,8databits,paritybit,stopbit
		.rx_done_tick(rx_done_tick)
    );
	 
	 ps2_tx m1
	 (
		.clk(clk),
		.rst_n(rst_n),
		.wr_ps2(wr_ps2),
		.din(din),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.tx_idle(tx_idle),
		.tx_done_tick(tx_done_tick)
    );


endmodule
