`timescale 1ns / 1ps

module debouncing_TEST(
	input clk,rst_n,
	input sw, //active low
	output[7:0] seg_out,
	output[5:0] sel_out
    );
	 
	 reg[3:0] counter_db=0,counter_sw=0; //counts from 0-to-9 then wraps up
	 reg sw_reg=0,db_reg=0;
	 wire[3:0] counter_db_nxt,counter_sw_nxt;
	 wire tick_db,tick_sw;
	 wire sw_1;
	 assign sw_1=!sw; //dual_edge_detector_MEALY  only accepts active high inputs so reverse the active-low button first
	 //debounce module instantiation
	debouncing_button debounce_module
	(
	.clk(clk),
	.rst_n(rst_n),
	.sw_low(sw), //active low
	.db(db) //active high output
    );
	 
	 
	 //dual edge detector
	 dual_edge_detector_MEALY mealy_m0(
	.clk(clk),
	.rst_n(rst_n),
	.level(db), //active-high
	.edg(tick_db)
    );
	 
	 dual_edge_detector_MEALY mealy_m1(
	.clk(clk),
	.rst_n(rst_n),
	.level(sw_1), //active-high
	.edg(tick_sw)
    );
	 
	 
	 // 10-mod-counter circuit
	 always@(posedge clk,negedge rst_n) begin
		if(!rst_n) begin 
			counter_db<=0;
			counter_sw<=0;	
		end
		else begin
			counter_db<=counter_db_nxt;
			counter_sw<=counter_sw_nxt;
		end
	 end
	 assign counter_db_nxt=tick_db?((counter_db==9)?0:counter_db+1):counter_db; //increment if tick is asserted(or when rising edge signal occurs)
	 assign counter_sw_nxt=tick_sw?((counter_sw==9)?0:counter_sw+1):counter_sw; //increment if tick is asserted(or when rising edge signal occurs)
	 
	 //Seven-segment-TIME-MUX Circuit
		LED_mux led_mux
		(
		.clk(clk),
		.rst(rst_n),
		.in0({1'b0,counter_db}),
		.in1({1'b1,counter_sw}),
		.in2(0),
		.in3(0),
		.in4(0),
		.in5(0),
		.seg_out(seg_out),
		.sel_out(sel_out)
		 );

endmodule
