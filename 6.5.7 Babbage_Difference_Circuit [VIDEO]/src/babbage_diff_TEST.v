`timescale 1ns / 1ps

module babbage_diff_TEST(
	input clk,rst_n,
	input sw0,sw1, //active low
	output[7:0] seg_out,
	output[5:0] sel_out
    );
	 //FSM state declarations
	 localparam[1:0] idle=2'd0,
							babbage=2'd1,
							bin2bcd=2'd2;
	 reg[1:0] state_reg,state_nxt;
	 reg[5:0] mod64_reg,mod64_nxt;
	 reg start_babbage,start_bin2bcd;
	 wire done_babbage,done_bin2bcd;
	 wire sw_redg;
	 wire[17:0] bin;
	 wire[3:0] dig0,dig1,dig2,dig3,dig4,dig5;
	 wire[3:0] mod_dig0,mod_dig1;
	 reg[3:0] in0,in1,in2,in3,in4,in5;
	 wire sw0_hi;
	 assign sw0_hi=!sw0;
	 
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			mod64_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			mod64_reg<=mod64_nxt;
		end
	 end
	 //FSM next-state logics
	 always @* begin
		state_nxt=state_reg;
		mod64_nxt=mod64_reg;
		start_babbage=0;
		start_bin2bcd=0;
		case(state_reg)
			   idle: begin
							if(sw_redg) begin
								mod64_nxt=mod64_reg+1;
								start_babbage=1;
								state_nxt=babbage;
							end
						end
			babbage: if(done_babbage) begin
							start_bin2bcd=1;
							state_nxt=bin2bcd;
						end
			bin2bcd: if(done_bin2bcd) state_nxt=idle;
			default: state_nxt=idle;		
		endcase	
	 end
	 
	 //debounce
	debounce_explicit deb(
		.clk(clk),
		.rst_n(rst_n),
		.sw(sw0_hi),
		.db_level(),
		.db_tick(sw_redg)
    );
	 
	 //module instantiations
	babbage_diff m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.start(start_babbage),
		.i(mod64_reg), //6 bit value f "n"	
		.ans(bin),
		.ready(),
		.done_tick(done_babbage)
    );	
	bin2bcd m1 //for mod64 counter value
	(
		.clk(clk),
		.rst_n(rst_n),
		.start(start_bin2bcd),
		.bin(mod64_reg),//limit is 6 digit of bcd
		.ready(),
		.done_tick(),
		.dig0(mod_dig0),
		.dig1(mod_dig1),
		.dig2(),
		.dig3(),
		.dig4(),
		.dig5()
    );
	 bin2bcd m2 //for babbage value
	(
		.clk(clk),
		.rst_n(rst_n),
		.start(start_bin2bcd),
		.bin(bin),//limit is 6 digit of bcd
		.ready(),
		.done_tick(done_bin2bcd),
		.dig0(dig0),
		.dig1(dig1),
		.dig2(dig2),
		.dig3(dig3),
		.dig4(dig4),
		.dig5(dig5)
    );
	LED_mux m3
	(
		.clk(clk),
		.rst(rst_n),
		.in0({1'b0,in0}),
		.in1({1'b0,in1}),
		.in2({1'b0,in2}),
		.in3({1'b0,in3}),
		.in4({1'b0,in4}),
		.in5({1'b0,in5}), //format: {dp,hex[3:0]}
		.seg_out(seg_out),
		.sel_out(sel_out)
    );
	 
	 //sw1 chooses which value to display: babbage value or counter(n) value
	 always  @* begin
		if(sw1) begin
			in0=mod_dig0;
			in1=mod_dig1;
			in2=0;
			in3=0;
			in4=0;
			in5=0;
		end
		else begin
			in0=dig0;
			in1=dig1;
			in2=dig2;
			in3=dig3;
			in4=dig4;
			in5=dig5;
		end
	 end
	 
	 
	 
	 
	 
endmodule
