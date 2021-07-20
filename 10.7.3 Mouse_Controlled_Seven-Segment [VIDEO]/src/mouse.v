`timescale 1ns / 1ps

module mouse(
	input clk,rst_n,
	input key0,key1, 
	inout ps2c,ps2d,
	output[8:0] x,y,
	output[2:0] btn,
	output reg m_done_tick
    );
	 
	 //FSM state-declarations
	 localparam[2:0] idle=3'd0,
							response=3'd1,
							byte1=3'd2,
							byte2=3'd3,
							byte3=3'd4,
							done=3'd5,
							reset=3'd6,
							rest=3'd7;
	 reg[2:0] state_reg,state_nxt;
	 reg[8:0] x_reg,x_nxt;
	 reg[8:0] y_reg,y_nxt;
	 reg[2:0] btn_reg,btn_nxt;
	 reg[7:0] din;
	 reg wr_ps2;
	 wire key0_tick,key1_tick;
	 wire[7:0] rx_data;
	 wire[10:0] dout;
	 wire rx_done_tick,tx_done_tick;
	 
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			x_reg<=0;
			y_reg<=0;
			btn_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			x_reg<=x_nxt;
			y_reg<=y_nxt;
			btn_reg<=btn_nxt;
		end
	 end
	 
	 //FSM next-state logics
	 always @* begin
		state_nxt=state_reg;
		x_nxt=x_reg;
		y_nxt=y_reg;
		btn_nxt=btn_reg;
		wr_ps2=0;
		m_done_tick=0;
		din=0;
		if(key1_tick) state_nxt=reset;
		else if(key0_tick) state_nxt=idle;
		else begin
			case(state_reg)
					idle: begin //transmit code F4 for enable stream
								din=8'hf4;
								wr_ps2=1;
								if(tx_done_tick==1) state_nxt=response;
							end
				response: if(rx_done_tick==1) state_nxt=byte1;//wait for the acknowledge response FE
				  byte1: if(rx_done_tick==1) begin //first packet
								x_nxt[8]=rx_data[5]; //4
								y_nxt[8]=rx_data[6]; //5
								btn_nxt=rx_data[3:1]; //2:0
								state_nxt=byte2;
							end
				  byte2: if(rx_done_tick==1) begin //2nd packet
								x_nxt[7:0]=rx_data;
								state_nxt=byte3;
							end
				  byte3: if(rx_done_tick==1) begin //3rd packet
								y_nxt[7:0]=rx_data;
								state_nxt=done;
							end
					done: begin
								m_done_tick=1;
								state_nxt=byte1;
							end
				  reset: begin
								din=8'hff;
								wr_ps2=1;
								state_nxt=rest;
							end
				   rest: state_nxt=rest;
				default: state_nxt=idle;
			endcase
		end
	 end
	 
	ps2_rxtx m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.din(din), //transmitted data is always F4(enable stream mode of mouse)
		.wr_ps2(wr_ps2),
		.ps2d(ps2d),
		.ps2c(ps2c),
		.dout(dout), //11bit-data received from rx
		.rx_done_tick(rx_done_tick),
		.tx_done_tick(tx_done_tick)
    );
	 assign rx_data=dout[8:1]; //real data extracted(no start,parity,and stop bits)
	 
	 assign x=x_reg;
	 assign y=y_reg;
	assign btn=btn_reg;
	
	debounce_explicit m1(
		.clk(clk),
		.rst_n(rst_n),
		.sw({!key0}),
		.db_level(),
		.db_tick(key0_tick)
    );
	 
	debounce_explicit m2(
		.clk(clk),
		.rst_n(rst_n),
		.sw({!key1}),
		.db_level(),
		.db_tick(key1_tick)
    );


	 
	
	


endmodule
