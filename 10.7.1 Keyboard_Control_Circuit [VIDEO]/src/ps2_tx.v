`timescale 1ns / 1ps

module ps2_tx(
	input clk,rst_n,
	input wr_ps2,
	input[7:0] din,
	inout ps2d,ps2c,
	output reg tx_idle,tx_done_tick
    );
	 //FSM state declarations
	 localparam[2:0] idle=3'd0,
							rts=3'd1,
							start=3'd2,
							data=3'd3,
							stop=3'd4;
	 reg[2:0] state_reg,state_nxt;
	 reg[12:0] counter_reg,counter_nxt;
	 reg[3:0] n_reg,n_nxt;
	 reg[8:0] data_reg,data_nxt;
	 reg[7:0] filter_reg;
	 wire[7:0] filter_nxt;
	 reg ps2c_reg;
	 wire ps2c_nxt;
	 reg ps2c_out,ps2d_out;
	 reg tri_c,tri_d;
	 wire fall_edg;
	
	//FSM register operations
	always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			counter_reg<=0;
			n_reg<=0;
			data_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			counter_reg<=counter_nxt;
			n_reg<=n_nxt;
			data_reg<=data_nxt;
		end
	end
	//FSM next-state logics
	always @* begin
		state_nxt=state_reg;
		counter_nxt=counter_reg;
		n_nxt=n_reg;
		data_nxt=data_reg;
		tx_idle=0;
		tx_done_tick=0;
		ps2c_out=1; //default clock out
		ps2d_out=1; //drfault data out  
		tri_c=0; //tri-state data bus is default off(high Z)
		tri_d=0; //tri-state clock bus is default off(high Z)
		case(state_reg)
			   idle: begin  //wait for wr_ps2 signal to be asserted(signal for transmitting data to ps2)
							tx_idle=1;
							if(wr_ps2==1) begin
								counter_nxt=0;
								n_nxt=0;
								data_nxt={!(^din),din}; //data={oddparity,8-bitdata}
								state_nxt=rts;
							end
						end
			    rts: begin //forces the clock line to be 0 for at least 100us(signal for request to send)
							ps2c_out=0;
							tri_c=1;
							if(counter_reg==13'h1fff) state_nxt=start; 
							else counter_nxt=counter_reg+1;
						end
			  start: begin //forces the data line to be 0(signal for start bit) and disable the rts(back to hi-Z)
							ps2d_out=0;
							tri_d=1;
							if(fall_edg==1) state_nxt=data;
						end
			   data: begin //shifts the next data bit for every falling edge of the clock line
							ps2d_out=data_reg[0];
							tri_d=1;
							if(fall_edg==1) begin
								data_nxt={1'b0,data_reg[8:1]};
								if(n_reg==8) state_nxt=stop; //finishes all data bits and 1 parity bit
								else n_nxt=n_reg+1;
							end
						end
			   stop: begin
							if(fall_edg==1) begin
								tx_done_tick=1;
								state_nxt=idle;
							end
						end
			default: state_nxt=idle;
		endcase
	end
		 
	  //filtering the ps2 clock from very short glitches, with falling edge detector
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			filter_reg<=0;
			ps2c_reg<=0;
		end
		else begin
			filter_reg<=filter_nxt;
			ps2c_reg<=ps2c_nxt;
		end
	 end
	 assign filter_nxt={ps2c,filter_reg[7:1]};
	 assign ps2c_nxt=(filter_reg==8'hff)?1:
							(filter_reg==8'h00)?0:
							 ps2c_reg;
	 assign fall_edg=(ps2c_reg && !ps2c_nxt)? 1:0;
	 
	 //tri-state logic for ps2c and ps2d
	 assign ps2c=tri_c?ps2c_out:1'bz;
	 assign ps2d=tri_d?ps2d_out:1'bz;
							  


endmodule
