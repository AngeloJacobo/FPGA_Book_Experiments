`timescale 1ns / 1ps

module reaction_timer(
	input clk,rst_n,
	input start_low,clr_low,stop_low, //active-low button
	output reg[3:0] led,
	output[7:0] seg_out,
	output[5:0] sel_out
    );
	 
	 //FSM state declarations
	 localparam[1:0] idle=2'd0,
							waiting=2'd1,
							play=2'd2,
							done=2'd3;
	 reg[1:0] state_reg,state_nxt;
	 reg[25:0] counter_reg,counter_nxt; //ticks every 1 second
	 reg[3:0] sec_reg,sec_nxt; //delay in "seconds"
	 reg[3:0] mod16_reg,mod16_nxt; //random number generator(free-running counter 2-to-15)
	 reg[3:0] random_reg,random_nxt; //stores value of mod_16_reg when "start"button is pressed
	 reg[15:0] timer_reg,timer_nxt; ///ticks every 1ms
	 reg[13:0] milli_reg,milli_nxt;//delay in terms of "milliseconds"
	 reg[7:0] dig0,dig1,dig2,dig3,dig4,dig5; //value of each seven-segments
	 wire[3:0] dig0_temp,dig1_temp,dig2_temp,dig3_temp,dig4_temp,dig5_temp;
	 reg[6:0] dig0_temp1,dig1_temp1,dig2_temp1,dig3_temp1,dig4_temp1,dig5_temp1;
	 wire start,clr,stop;
	 reg start_bin2bcd;
	 assign start=!start_low, //make the button active high 
				clr=!clr_low,
				stop=!stop_low;
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=0;
			counter_reg<=0;
			sec_reg<=0;
			mod16_reg<=0;
			random_reg<=0;
			timer_reg<=0;
			milli_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			counter_reg<=counter_nxt;
			sec_reg<=sec_nxt;
			mod16_reg<=mod16_nxt;
			random_reg<=random_nxt;
			timer_reg<=timer_nxt;
			milli_reg<=milli_nxt;
		end
	 end
	 
	 //FSM next-state logics
	 always @* begin
		state_nxt=state_reg;
		counter_nxt=counter_reg;
		sec_nxt=sec_reg;
		mod16_nxt=mod16_reg;
		random_nxt=random_reg;
		timer_nxt=timer_reg;
		milli_nxt=milli_reg;
		led=4'b0000;
		dig0=8'b1111_1111;
		dig1=8'b1111_1111;
		dig2=8'b1111_1111;
		dig3=8'b1111_1111;
		dig4=8'b1111_1111;
		dig5=8'b1111_1111;
		start_bin2bcd=0;
		if(!clr) begin
			case(state_reg)
					idle: begin //display "_Hello" 
								dig0=8'b1000_0001;
								dig1=8'b1111_0001;
								dig2=8'b1111_0001;
								dig3=8'b1011_0000;
								dig4=8'b1100_1000;
								dig5=8'b1111_1111;
								if(start) begin
									counter_nxt=0;
									sec_nxt=0;
									random_nxt=mod16_reg;
									state_nxt=waiting;
								end
							end
				waiting: begin
								if(!stop) begin //display OFF
									if(counter_reg!=49_999_999) counter_nxt=counter_reg+1;
									else begin
										sec_nxt=sec_reg+1;
										counter_nxt=0;
										if(sec_nxt==random_reg) begin
											timer_nxt=0;
											milli_nxt=0;
											state_nxt=play;
										end
									end
								end
								else begin
									milli_nxt=9_999;
									state_nxt=done;
									start_bin2bcd=1;
								end
							end
					play: begin
								led=4'b1111;
								if(timer_reg!=49_999) timer_nxt=timer_reg+1;
								else begin
									milli_nxt=milli_reg+1;
									timer_nxt=0;
								end
								if(stop || milli_nxt==1_000) begin
									state_nxt=done;
									start_bin2bcd=1;
								end
							end
					done: begin
								dig0={1'b1,dig0_temp1};
								dig1={1'b1,dig1_temp1};
								dig2={1'b1,dig2_temp1};
								dig3={1'b0,dig3_temp1};
								dig4={1'b1,dig4_temp1};
								dig5={1'b1,dig5_temp1};
							end
				default:	state_nxt=idle;			
			endcase
		end
		else state_nxt=idle;
		
		//free-running counter as the random number generator(counts from 2-to-15 then wraps around)
		if(mod16_reg!=15) mod16_nxt=mod16_reg+1;
		else mod16_nxt=2;
	 end
	 
	 
	 //module instantiations	 
	 bin2bcd m0
	 (
		.clk(clk),
		.rst_n(rst_n),
		.start(start_bin2bcd),
		.bin(milli_nxt),//limit is 6 digit of bcd
		.ready(),
		.done_tick(),
		.dig0(dig0_temp),
		.dig1(dig1_temp),
		.dig2(dig2_temp),
		.dig3(dig3_temp),
		.dig4(dig4_temp),
		.dig5(dig5_temp)
    );
	LED_mux m1
	(
	.clk(clk),
	.rst(rst_n),
	.in0(dig0),
	.in1(dig1),
	.in2(dig2),
	.in3(dig3),
	.in4(dig4),
	.in5(dig5), 
	.seg_out(seg_out),
	.sel_out(sel_out)
    );
	 
	 //decoder for hex-to-7 bit seven-segment value
	 always @* begin
		 dig0_temp1=0;
		 dig1_temp1=0;
		 dig2_temp1=0;
		 dig3_temp1=0;
		 dig4_temp1=0;
		 dig5_temp1=0;
			 case(dig0_temp)
			 4'h0: dig0_temp1=7'b0000_001;
			 4'h1: dig0_temp1=7'b1001_111;
			 4'h2: dig0_temp1=7'b0010_010;
			 4'h3: dig0_temp1=7'b0000_110;
			 4'h4: dig0_temp1=7'b1001_100;
			 4'h5: dig0_temp1=7'b0100_100;
			 4'h6: dig0_temp1=7'b0100_000;
			 4'h7: dig0_temp1=7'b0001_111;
			 4'h8: dig0_temp1=7'b0000_000;
			 4'h9: dig0_temp1=7'b0001_100;
			 4'ha: dig0_temp1=7'b0001_000;
			 4'hb: dig0_temp1=7'b1100_000;
			 4'hc: dig0_temp1=7'b0110_001;
			 4'hd: dig0_temp1=7'b1000_010;
			 4'he: dig0_temp1=7'b0110_000;
			 4'hf: dig0_temp1=7'b0111_000;
			 endcase
			 case(dig1_temp)
			 4'h0: dig1_temp1=7'b0000_001;
			 4'h1: dig1_temp1=7'b1001_111;
			 4'h2: dig1_temp1=7'b0010_010;
			 4'h3: dig1_temp1=7'b0000_110;
			 4'h4: dig1_temp1=7'b1001_100;
			 4'h5: dig1_temp1=7'b0100_100;
			 4'h6: dig1_temp1=7'b0100_000;
			 4'h7: dig1_temp1=7'b0001_111;
			 4'h8: dig1_temp1=7'b0000_000;
			 4'h9: dig1_temp1=7'b0001_100;
			 4'ha: dig1_temp1=7'b0001_000;
			 4'hb: dig1_temp1=7'b1100_000;
			 4'hc: dig1_temp1=7'b0110_001;
			 4'hd: dig1_temp1=7'b1000_010;
			 4'he: dig1_temp1=7'b0110_000;
			 4'hf: dig1_temp1=7'b0111_000;
			 endcase
			 case(dig2_temp)
			 4'h0: dig2_temp1=7'b0000_001;
			 4'h1: dig2_temp1=7'b1001_111;
			 4'h2: dig2_temp1=7'b0010_010;
			 4'h3: dig2_temp1=7'b0000_110;
			 4'h4: dig2_temp1=7'b1001_100;
			 4'h5: dig2_temp1=7'b0100_100;
			 4'h6: dig2_temp1=7'b0100_000;
			 4'h7: dig2_temp1=7'b0001_111;
			 4'h8: dig2_temp1=7'b0000_000;
			 4'h9: dig2_temp1=7'b0001_100;
			 4'ha: dig2_temp1=7'b0001_000;
			 4'hb: dig2_temp1=7'b1100_000;
			 4'hc: dig2_temp1=7'b0110_001;
			 4'hd: dig2_temp1=7'b1000_010;
			 4'he: dig2_temp1=7'b0110_000;
			 4'hf: dig2_temp1=7'b0111_000;
			 endcase
			 case(dig3_temp)
			 4'h0: dig3_temp1=7'b0000_001;
			 4'h1: dig3_temp1=7'b1001_111;
			 4'h2: dig3_temp1=7'b0010_010;
			 4'h3: dig3_temp1=7'b0000_110;
			 4'h4: dig3_temp1=7'b1001_100;
			 4'h5: dig3_temp1=7'b0100_100;
			 4'h6: dig3_temp1=7'b0100_000;
			 4'h7: dig3_temp1=7'b0001_111;
			 4'h8: dig3_temp1=7'b0000_000;
			 4'h9: dig3_temp1=7'b0001_100;
			 4'ha: dig3_temp1=7'b0001_000;
			 4'hb: dig3_temp1=7'b1100_000;
			 4'hc: dig3_temp1=7'b0110_001;
			 4'hd: dig3_temp1=7'b1000_010;
			 4'he: dig3_temp1=7'b0110_000;
			 4'hf: dig3_temp1=7'b0111_000;
			 endcase
			 case(dig4_temp)
			 4'h0: dig4_temp1=7'b0000_001;
			 4'h1: dig4_temp1=7'b1001_111;
			 4'h2: dig4_temp1=7'b0010_010;
			 4'h3: dig4_temp1=7'b0000_110;
			 4'h4: dig4_temp1=7'b1001_100;
			 4'h5: dig4_temp1=7'b0100_100;
			 4'h6: dig4_temp1=7'b0100_000;
			 4'h7: dig4_temp1=7'b0001_111;
			 4'h8: dig4_temp1=7'b0000_000;
			 4'h9: dig4_temp1=7'b0001_100;
			 4'ha: dig4_temp1=7'b0001_000;
			 4'hb: dig4_temp1=7'b1100_000;
			 4'hc: dig4_temp1=7'b0110_001;
			 4'hd: dig4_temp1=7'b1000_010;
			 4'he: dig4_temp1=7'b0110_000;
			 4'hf: dig4_temp1=7'b0111_000;
			 endcase
			 case(dig5_temp)
			 4'h0: dig5_temp1=7'b0000_001;
			 4'h1: dig5_temp1=7'b1001_111;
			 4'h2: dig5_temp1=7'b0010_010;
			 4'h3: dig5_temp1=7'b0000_110;
			 4'h4: dig5_temp1=7'b1001_100;
			 4'h5: dig5_temp1=7'b0100_100;
			 4'h6: dig5_temp1=7'b0100_000;
			 4'h7: dig5_temp1=7'b0001_111;
			 4'h8: dig5_temp1=7'b0000_000;
			 4'h9: dig5_temp1=7'b0001_100;
			 4'ha: dig5_temp1=7'b0001_000;
			 4'hb: dig5_temp1=7'b1100_000;
			 4'hc: dig5_temp1=7'b0110_001;
			 4'hd: dig5_temp1=7'b1000_010;
			 4'he: dig5_temp1=7'b0110_000;
			 4'hf: dig5_temp1=7'b0111_000;
			 endcase

	 end
	 
	 


endmodule
