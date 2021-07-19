`timescale 1ns / 1ps

module main_controller(
	input clk,rst_n,
	input sw1,sw2, //sw1=increase fibo input, sw2=display either the fibo input or the output
	output[7:0] seg_out,
	output[5:0] sel_out
    );
	 localparam[1:0] idle=2'd0,
							bcd2bin=2'd1,
							fibonacci=2'd2,
							bin2bcd=2'd3;
	 reg[1:0] state_reg,state_nxt;
	 reg start_bcd2bin,start_fibo,start_bin2bcd;
	 wire done_bcd2bin,done_fibo,done_bin2bcd;
	 wire[3:0] dig0_counter,dig1_counter;
	 wire [6:0] bin;
	 wire[20:0] fibo;
	 reg[3:0] dig0,dig1,dig2,dig3,dig4,dig5;
	 wire[3:0] dig0_bin,dig1_bin,dig2_bin,dig3_bin,dig4_bin,dig5_bin;
	 wire done_counter;
	 //FSM state declarations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) state_reg<=idle;
		else state_reg<=state_nxt;
	 end
	 
	 //FSM next-state logics
	 always @* begin
		state_nxt=state_reg;
		start_bcd2bin=0;
		start_fibo=0;
		start_bin2bcd=0;
		case(state_reg)
				idle: if(done_counter) begin
							start_bcd2bin=1;
							state_nxt=bcd2bin;
						end
			bcd2bin: if(done_bcd2bin) begin
							start_fibo=1;
							state_nxt=fibonacci;
						end
		 fibonacci: if(done_fibo) begin
							start_bin2bcd=1;
							state_nxt=bin2bcd;
						end
			bin2bcd: if(done_bin2bcd) state_nxt=idle;
			default: state_nxt=idle;
		endcase
	 end
	 always @* begin
		if(sw2) begin
			dig0=dig0_counter;
			dig1=dig1_counter;
			dig2=0;
			dig3=0;
			dig4=0;
			dig5=0;
		end
		else begin
			dig0=dig0_bin;
			dig1=dig1_bin;
			dig2=dig2_bin;
			dig3=dig3_bin;
			dig4=dig4_bin;
			dig5=dig5_bin;
		end
	 end

	 //instantiation of all module used
	bcd_counter m0 //mod-50 counter
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(sw1),
		.dig1(dig1_counter),
		.dig0(dig0_counter),
		.done_tick(done_counter)
    );
	 
	bcd2bin m1 //convert 2 digit to binary(0-to-49)
	(
		.clk(clk),
		.rst_n(rst_n),
		.start(start_bcd2bin),
		.dig1(dig1_counter),
		.dig0(dig0_counter),
		.bin(bin), 
		.ready(),
		.done_tick(done_bcd2bin)
    );
	 
	fibonacci m2 //outputs fibonacci value of bin(bin>29 will get "999_999" as a result)
	(
	.clk(clk),
	.rst_n(rst_n),
	.start(start_fibo),
	.i(bin),
	.fibo(fibo),
	.ready(),
	.done_tick(done_fibo)
    );
	 
	 bin2bcd m3( //convertes fibo binary to bcd
	.clk(clk),
	.rst_n(rst_n),
	.start(start_bin2bcd),
	.bin(fibo),//limit is 6 digit of bcd so only 19 bits of fibo will be considered
	.ready(),
	.done_tick(done_bin2bcd),
	.dig0(dig0_bin),
	.dig1(dig1_bin),
	.dig2(dig2_bin),
	.dig3(dig3_bin),
	.dig4(dig4_bin),
	.dig5(dig5_bin)
    );
	 
	 LED_mux m4 //bcd value will used as input to 6-seven-segment display
	(
	.clk(clk),
	.rst(rst_n),
	.in0(dig0),
	.in1(dig1),
	.in2(dig2),
	.in3(dig3),
	.in4(dig4),
	.in5(dig5), //format: {dp,hex[3:0]}
	.seg_out(seg_out),
	.sel_out(sel_out)
    );

endmodule
