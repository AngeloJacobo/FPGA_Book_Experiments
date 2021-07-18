`timescale 1ns / 1ps

module parking_lot_counter_TEST(
	input clk,rst_n,
	input a,b,
	output[7:0] seg_out,
	output[5:0] sel_out
    );
	 reg[3:0] mod_16_reg=0;
	 wire[3:0] mod_16_nxt;
	 wire a_db,b_db,enter,exit;
	 reg[3:0] in0,in1;
	 
	 //debounce the button "a" and "b" first
	 debouncing_button db_m0(
	.clk(clk),
	.rst_n(rst_n),
	.sw_low(a), //active low
	.db(a_db) //active high
    );
	 debouncing_button db_m1(
	.clk(clk),
	.rst_n(rst_n),
	.sw_low(b), //active low
	.db(b_db) //active high
    );
	 
	 // instantiation of lot-counter circuit
	 parking_lot_counter lot_m0(
		.clk(clk), 
		.rst_n(rst_n), 
		.a(a_db), 
		.b(b_db), 
		.enter(enter), 
		.exit(exit)
	);
	
	//Mod-16 counter that increments/decrements based on the tick of enter/exit
	always @(posedge clk,negedge rst_n) begin
		if(!rst_n) mod_16_reg<=0;
		else mod_16_reg<=mod_16_nxt;
	end
		assign mod_16_nxt=enter? mod_16_reg+1:(exit? mod_16_reg-1:mod_16_reg);
	
	//Logic for converting hexadecimal to 2-digit BCD 
	always @* begin
		if(mod_16_reg>9) begin
			in0=mod_16_reg-4'd10;
			in1=4'd1;
		end
		else begin
			in0=mod_16_reg;
			in1=4'd0;
		end
	end
	//Instantiation of LED-mux module
		LED_mux led_mux
		(
		.clk(clk),
		.rst(rst_n),
		.in0(in0),
		.in1(in1),
		.in2(0),
		.in3(0),
		.in4(0),
		.in5(0),
		.seg_out(seg_out),
		.sel_out(sel_out)
		 );
		
endmodule
