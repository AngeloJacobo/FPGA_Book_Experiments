`timescale 1ns / 1ps

module kb_control_circuit(
	input clk,rst_n,
	input key0,key1,key2,
	inout ps2d,ps2c	
    );
	 //FSM state-declarations
	 localparam[1:0] idle=2'd0,
							byte1=2'd1,
							byte2=2'd2,
							done=2'd3;
	 reg[1:0] state_reg,state_nxt;
	 reg[3:0] hex_reg,hex_nxt;
	 reg wr_ps2;
	 reg[7:0] din;
	 wire tx_done_tick;
	 wire key0_tick,key1_tick,key2_tick;
	 
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=0;
			hex_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			hex_reg<=hex_nxt;
		end
	 end
	 
	 //FSM next-state logics
	 always @* begin
		state_nxt=state_reg;
		wr_ps2=0;
		din=0;
		hex_nxt=hex_reg;
		case(state_reg) 
		  	   idle: begin //wait for the tick of any button
							if(key0_tick) hex_nxt=4'b0010; //on num-lock led
							else if(key1_tick) hex_nxt=4'b0001; //on scroll-lock led
							else if(key2_tick) hex_nxt=4'b0100;//on caps-lock led
							if(key0_tick||key1_tick||key2_tick) state_nxt=byte1;
						end
			  byte1: begin //send first byte 
							din=8'hed;
							wr_ps2=1;
							if(tx_done_tick) state_nxt=byte2;
						end
			  byte2: begin //send second byte(contains the data on which led to turn on)
							din={4'h0,hex_reg};
							wr_ps2=1;
							if(tx_done_tick) state_nxt=done;
						end
			   done: state_nxt=idle;
			default: state_nxt=idle;
		endcase
	 end
	 
	 
	 
	 //module instantations
	ps2_tx m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.wr_ps2(wr_ps2),
		.din(din),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.tx_idle(),
		.tx_done_tick(tx_done_tick)
    );
	 
	 debounce_explicit m1
	 (
		.clk(clk),
		.rst_n(rst_n),
		.sw({!key0}),
		.db_level(),
		.db_tick(key0_tick)
    );
	 debounce_explicit m2
	 (
		.clk(clk),
		.rst_n(rst_n),
		.sw({!key1}),
		.db_level(),
		.db_tick(key1_tick)
    );
	 debounce_explicit m3
	 (
		.clk(clk),
		.rst_n(rst_n),
		.sw({!key2}),
		.db_level(),
		.db_tick(key2_tick)
    );


endmodule
