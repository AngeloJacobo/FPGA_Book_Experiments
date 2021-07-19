`timescale 1ns / 1ps

module ps2_rx(
	input clk,rst_n,
	input rx_en,
	input ps2d,ps2c,
	output[10:0] dout,
	output reg rx_done_tick
    );
	 //FSM state declarations
	 localparam[1:0] idle=2'd0,
							scan=2'd1,
							done=2'd2;
	 reg[1:0] state_reg,state_nxt;
	 reg[10:0] data_reg,data_nxt;
	 reg[3:0] n_reg,n_nxt;
	 reg[7:0] filter_reg,filter_nxt;
	 reg ps2c_f_reg,ps2c_f_nxt;
	 reg ps2c_reg;
	 wire ps2c_edg;
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=0;
			data_reg<=0;
			n_reg<=0;
			filter_reg<=0;
			ps2c_f_reg<=0;
			ps2c_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			data_reg<=data_nxt;
			n_reg<=n_nxt;
			filter_reg<=filter_nxt;
			ps2c_f_reg<=ps2c_f_nxt;
			ps2c_reg<=ps2c_f_reg;
		end
	 end
	 
	 //FSM next-state logic
	 always @* begin
		state_nxt=state_reg;
		data_nxt=data_reg;
		n_nxt=n_reg;
		rx_done_tick=0;
		case(state_reg)
			   idle: if(ps2c_edg && rx_en) begin //wait for the falling edge of the start bit
							data_nxt={ps2d,data_reg[10:1]};
							n_nxt=0;
							state_nxt=scan;
						end						
			   scan: if(ps2c_edg) begin //wait to finish receiving all data bits(bit0-9,paritybit,then stopbit)
							data_nxt={ps2d,data_reg[10:1]};
							if(n_reg==9) state_nxt=done;
							else n_nxt=n_reg+1;
						end
			   done: begin //finish
							rx_done_tick=1;
							state_nxt=idle;
						end
			default: state_nxt=idle;	
		endcase
	 end
	 //ps2c filter logic. The ps2c_f_reg is the filtered output.
	 always @* begin 
		filter_nxt={ps2c,filter_reg[7:1]}; 
		if(filter_reg==8'b1111_1111) ps2c_f_nxt=1;  //Any glitches shorter than 8 turns will be ignored
		else if(filter_reg==8'b0000_0000) ps2c_f_nxt=0; 
		else ps2c_f_nxt=ps2c_f_reg;
	 end
	 //falling edge detection for ps2c_f_reg
	 assign ps2c_edg=(ps2c_reg && !ps2c_f_reg)?1:0;
	assign dout=data_reg;
endmodule
