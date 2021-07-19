`timescale 1ns / 1ps

module monitor
	#(parameter N=3)
	(
	input clk,rst_n,
	input syn_clr,load,en,up,
	input[N-1:0] d,
	input[N-1:0] q,
	input max_tick,min_tick
    );
	 reg syn_clr_reg,load_reg,en_reg,up_reg,rst_reg;
	 reg[N-1:0] d_reg,result,q_reg;
	 reg[39:0] msg;
	 initial begin
		$display("time sync_clr/load/en/up q result msg");
	 end
	 always @(posedge clk) begin
		syn_clr_reg<=syn_clr;
		load_reg<=load;
		en_reg<=en;
		up_reg<=up;
		d_reg<=d;
		q_reg<=q;
		rst_reg<=1;
		msg=(result===q)?" ":"ERROR";
		$strobe("%0d %b%b%b%b %0d %0d %s",$time,syn_clr,load,en,up,q,result,msg);
	 end
	 
	 always @* begin
		if(!rst_n) rst_reg=0;
		if(!rst_reg) result=0;
		else begin
			if(syn_clr_reg) result=0;
			else if(load_reg) result=d;
			else if(en_reg && up_reg) result=q_reg+1;
			else if(en_reg && !up_reg) result=q_reg-1;
			else result=q_reg;
		end
	 end
	 
endmodule
