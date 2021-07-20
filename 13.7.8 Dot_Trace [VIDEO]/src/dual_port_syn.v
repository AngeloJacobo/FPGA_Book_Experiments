`timescale 1ns / 1ps

module single_port_syn //128k by 3 single port sync ram(uses block ram)
#(parameter ADDR_WIDTH=16,
				DATA_WIDTH=3)
(
	input clk,
	input we,
	input[ADDR_WIDTH-1:0] addr,
	input[DATA_WIDTH-1:0] din,
	output[DATA_WIDTH-1:0] dout
);
	reg[DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	reg[ADDR_WIDTH-1:0] addr_q;
	
	always @(posedge clk) begin
		if(we) ram[addr]=din;
		addr_q<=addr;
	end
	assign dout=ram[addr_q];
endmodule
