`timescale 1ns / 1ps

module uart_rx  
	(
		input clk,rst_n,
		input rx,
		input s_tick,
		input[3:0] databits, //either 8 or 7 databits
		input[5:0] stopbits, //either 16 or 32 ticks for 1 and 2 stopbits,respectively
		input [1:0] paritybit, //0-no parity, 1=odd parity , 2=even parity
		output reg rx_done_tick,
		output[7:0] dout,
		output reg parity_error, //high if there is error
		output reg frame_error //high if there is error
    );
	 //FSM state declarations
	 localparam[2:0] idle=3'd0,
							start=3'd1,
							data=3'd2,
							parity=3'd3,
							stop=3'd4;
	 reg[2:0] state_reg,state_nxt;
	 reg[5:0] s_reg,s_nxt; //check if number of ticks is 7(middle of start bit), or 15(middle of a data bit)
	 reg[2:0] n_reg,n_nxt; //checks how many data bits is already passed(value is 7 for last bit)
	 reg[7:0] b_reg,b_nxt; //stores 8-bit binary value of received data bits
	 reg parity_error_nxt,frame_error_nxt;
	 //FSM register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			s_reg<=0;
			n_reg<=0;
			b_reg<=0;
			parity_error<=0;
			frame_error<=0;
		end
		else begin
			state_reg<=state_nxt;
			s_reg<=s_nxt;
			n_reg<=n_nxt;
			b_reg<=b_nxt;	
			parity_error<=parity_error_nxt;
			frame_error<=frame_error_nxt;
		end
	 end
	 //FSM next-state logic
	 always @* begin
		state_nxt=state_reg;
		s_nxt=s_reg;
		n_nxt=n_reg;
		b_nxt=b_reg;
		rx_done_tick=0;
		parity_error_nxt=parity_error;
		frame_error_nxt=frame_error;
		case(state_reg)
			 idle: if(rx==0) begin //wait for start bit(rx of zero)
						s_nxt=0;
						state_nxt=start;
					 end						
			start: if(s_tick==1) begin //wait for middle of start bit
						if(s_reg==7) begin
							s_nxt=0;
							n_nxt=0;
							state_nxt=data;
						end
						else s_nxt=s_reg+1;
					 end
		    data: if(s_tick==1) begin //wait to pass all middle points of every data bits
						if(s_reg==15) begin
							b_nxt={rx,b_reg[7:1]};
							s_nxt=0;
							if(n_reg==databits-1) state_nxt=parity;
							else n_nxt=n_reg+1;
						end
						else s_nxt=s_reg+1;
					 end
			parity: if(paritybit==0) state_nxt=stop; //no parity
			
						else  begin  //odd or even parity
							if(s_tick==1) begin 
								if(s_reg==15) begin //go to middle point of parity bit
									parity_error_nxt=(paritybit==1)? !{^{dout,rx}} : {^{dout,rx}} ; 
									s_nxt=0;
									state_nxt=stop;
								end
								else s_nxt=s_reg+1;
							end
						end
			
			 stop: if(s_tick==1) begin  //wait to pass the required stop bits
						if(s_reg==stopbits-1) begin
							frame_error_nxt=!rx;
							rx_done_tick=1;
							state_nxt=idle;
						end
  						else s_nxt=s_reg+1;
					 end	
		 default: state_nxt=idle;
		endcase
	 end
	 assign dout=(databits==8)? b_reg : (b_reg>>1);
endmodule
