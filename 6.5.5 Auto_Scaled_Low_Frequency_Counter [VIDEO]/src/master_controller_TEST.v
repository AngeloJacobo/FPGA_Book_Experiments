`timescale 1ns / 1ps

module TEST(
	input clk,rst_n,
	input sw,
	output[7:0] seg_out,
	output[5:0] sel_out,
	output[9:0] signal
    );
	 localparam period=20_000; //in terms of microsec
	 
	 
	 localparam N=(period+1)*25;
	 reg[24:0] counter_reg=0,counter_nxt;
	 reg signal_reg=0,signal_nxt;
	 
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			counter_reg<=0;
			signal_reg<=0;
		end
		else begin
			counter_reg<=counter_nxt;
			signal_reg<=signal_nxt;
		end
	 end
	 
	 always @* begin
	 signal_nxt=signal_reg;
		if(counter_reg!=N-1) begin
			counter_nxt=counter_reg+1;
		end
		else begin
			counter_nxt=0;
			signal_nxt=!signal_reg;			
		end
	 end
	 master_controller m_master(
	.clk(clk),
	.rst_n(rst_n),
	.signal(signal_reg),
	.sw(sw),
	.seg_out(seg_out),
	.sel_out(sel_out),
	.done_tick()
    );
	 assign signal={10{signal_reg}};

endmodule
