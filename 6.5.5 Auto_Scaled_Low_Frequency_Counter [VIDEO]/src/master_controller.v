`timescale 1ns / 1ps

module master_controller(
	input clk,rst_n,
	input signal,sw,
	output[7:0] seg_out,
	output[5:0] sel_out,
	output reg done_tick
    );
	 //FSMstate declarations
	 localparam[2:0] idle=3'd0,
							pcounter=2'd1,
							div=3'd2,
							bin2bcd=3'd3,
							adjust=3'd4;
	 reg[2:0] state_reg,state_nxt;
	 reg start_pcounter,start_div,start_bin2bcd,start_adjust;
	 wire done_pcounter,done_div,done_bin2bcd,done_adjust;
	 wire[19:0] period;
	 wire[36:0] bin;
	 wire[3:0] dig0,dig1,dig2,dig3,dig4,dig5,dig6,dig7,dig8,dig9,dig10;
	 wire[4:0] in0,in1,in2,in3,in4,in5;
	 wire signal_hi;
	 reg sw_reg;
	 wire sw_edg;
	 
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		 if(!rst_n) begin
				state_reg<=0;
				sw_reg<=0;
		 end
		 else begin
			state_reg<=state_nxt;
			sw_reg<=sw;
		 end
	 end
	 
	 //edge detector for "sw"
	 assign sw_edg= !sw && sw_reg; //sw is active low
	 
	 
	 //FSM next-state logics
	 always @* begin
		start_pcounter=0;
		start_div=0;
		start_bin2bcd=0;
		start_adjust=0;
		state_nxt=state_reg;
		done_tick=0;
		case(state_reg) 
			    idle: if(sw_edg) begin
							start_pcounter=1;
							state_nxt=pcounter;
						 end
			pcounter: if(done_pcounter) begin
							start_div=1;
							state_nxt=div;
						 end
				  div: if(done_div) begin
							start_bin2bcd=1;
							state_nxt=bin2bcd;
						 end
			 bin2bcd: if(done_bin2bcd) begin
							start_adjust=1;
							state_nxt=adjust;
						 end
			  adjust: if(done_adjust) begin
							state_nxt=idle;
							done_tick=1;
						 end
			 default: state_nxt=idle;
		endcase
	 end
	 assign signal_hi=!signal;
	 //module declarations
	 period_counter m0
	 (
		.clk(clk),
		.rst_n(rst_n),
		.start(start_pcounter),
		.signal(signal_hi),
		.ready(),
		.done_tick(done_pcounter),
		.period(period) //limit of 1.023 seconds of period
    );
	 
	 div #(.W(37),.N(6)) m1 //W is the width of both dividend and divisor, N is the size of the register that stores binary value of W: N=log_2(W)+1
	(
		.clk(clk),
		.rst_n(rst_n),
		.start(start_div),
		.dividend(37'd10**11),
		.divisor({17'd0,period}),
		.quotient(bin),
		.remainder(),
		.ready(),
		.done_tick(done_div)
    );
	 
	 bin2bcd m2
	 (
		.clk(clk),
		.rst_n(rst_n),
		.start(start_bin2bcd),
		.bin(bin),//11 digit max of {11{9}}
		.ready(),
		.done_tick(done_bin2bcd),
		.dig0(dig0),
		.dig1(dig1),
		.dig2(dig2),
		.dig3(dig3),
		.dig4(dig4),
		.dig5(dig5),
		.dig6(dig6),
		.dig7(dig7),
		.dig8(dig8),
		.dig9(dig9),
		.dig10(dig10)
    );
	 
	 adjust m3 //outputs the six most significant digits with corresponding decimal
	 ( 
		.clk(clk),
		.rst_n(rst_n),
		.start(start_adjust),
		.dig0(dig0),
		.dig1(dig1),
		.dig2(dig2),
		.dig3(dig3),
		.dig4(dig4),
		.dig5(dig5),
		.dig6(dig6),
		.dig7(dig7),
		.dig8(dig8),
		.dig9(dig9),
		.dig10(dig10),
		.in0(in0),
		.in1(in1),
		.in2(in2),
		.in3(in3),
		.in4(in4),
		.in5(in5), //6 most significant digits 
		.done_tick(done_adjust)
    );
	 
	LED_mux m4
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


endmodule
