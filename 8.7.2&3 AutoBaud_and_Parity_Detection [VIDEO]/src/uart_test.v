`timescale 1ns / 1ps

module uart_test(
	input clk,rst_n,
	input btn0,btn1,btn2,
	input rx,
	output tx,
	output[7:0] seg_out,
	output[5:0] sel_out,
	output[3:0] led
    );
	 
	 wire btn2_tick;
	 wire[7:0] wr_data,rd_data;
	 wire rx_empty,tx_empty;
	 
	 top_module m0
	 (
		.clk(clk),
		.rst_n(rst_n),
		.btn0(btn0),
		.btn1(btn1),	//btn0=enter key , btn1=activate autobaud-parity detector 
		.rx(rx), 
		.rd_uart(btn2_tick),
		.wr_uart(btn2_tick),
		.wr_data(wr_data),
		.rd_data(rd_data),
		.tx(tx),
		.rx_empty(rx_empty),
		.tx_empty(tx_empty),
		.seg_out(seg_out),
		.sel_out(sel_out)
    );
	 debounce_explicit m1
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw({!btn2}),
		.db_level(),
		.db_tick(btn2_tick)
    );
	 
	 assign wr_data=rd_data+1;
	 assign led={4{rx_empty}};
	 

endmodule
