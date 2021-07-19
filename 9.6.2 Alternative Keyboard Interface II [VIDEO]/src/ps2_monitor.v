`timescale 1ns / 1ps

module ps2_monitor(
	input clk,rst_n,
	input[10:0] din,
	input rx_done_tick,
	output reg wr,
	output reg[7:0] wr_data,
	output reg done_tick
    );
	 //FSM state declarations
	 localparam[1:0] idle=2'd0,
							hex0=2'd1, //extract first hex of din then convert to ascii to be transmitted via UART
							hex1=2'd2, //extract second hex of din then convert to ascii to be transmitted via UART
							done=2'd3;
	reg[1:0] state_reg,state_nxt;
	reg[10:0] din_reg,din_nxt;
	reg[3:0] hex;
	reg[7:0] ascii;
	//FSM register operations
	always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			din_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			din_reg<=din_nxt;
		end
	end
	//FSM next-state logics
	always @* begin
		state_nxt=state_reg;
		din_nxt=din_reg;
		hex=0;
		wr=0;
		done_tick=0;
		wr_data=0;
		case(state_reg) 
			   idle: if(rx_done_tick) begin //wait for ps2_rx to finsih receiving a packet
							din_nxt=din;
							state_nxt=hex0;
						end
			   hex0: begin  //extract first hex of din then convert to ascii to be transmitted via UART
							hex=din_reg[8:5];
							wr_data=ascii;
							wr=1;
							state_nxt=hex1;
						end
			   hex1: begin  //extract second hex of din then convert to ascii to be transmitted via UART
							hex=din_reg[4:1];
							wr_data=ascii;
							wr=1;
							state_nxt=done;
						end
			   done: begin
							wr_data=8'h20; //space for more organized output
							wr=1;
							done_tick=1;
							state_nxt=idle;
						end
			default: state_nxt=idle;
		endcase
	end
	//convert hex to ascii
	always @* begin
		ascii=0;
		case(hex)
			4'h0: ascii=8'h30;
			4'h1: ascii=8'h31;
			4'h2: ascii=8'h32;
			4'h3: ascii=8'h33;
			4'h4: ascii=8'h34;
			4'h5: ascii=8'h35;
			4'h6: ascii=8'h36;
			4'h7: ascii=8'h37;
			4'h8: ascii=8'h38;
			4'h9: ascii=8'h39;
			4'ha: ascii=8'h41; //A
			4'hb: ascii=8'h42; //B
			4'hc: ascii=8'h43; //C
			4'hd: ascii=8'h44; //D
			4'he: ascii=8'h45; //E
			4'hf: ascii=8'h46; //F	
			default: ascii=8'h47; //for debugging
		endcase
	end

endmodule
