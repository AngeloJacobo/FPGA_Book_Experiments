`timescale 1ns / 1ps

module debouncing_button(
	input clk,rst_n,
	input sw_low, //active low
	output reg db
    );
	 
	 localparam N=20; //free-running counter, 2^N/50MHz=2^20/50MHz=20.9ms 
	 
	 //symbolic declaration for FSM
	 localparam [2:0] zero=3'd0,
							mid0_1=3'd1,
							mid0_2=3'd2,
							one=3'd3,
							mid1_1=3'd4,
							mid1_2=3'd5;
							
	 reg[2:0] state_reg=0,state_nxt=0;
	 reg[N-1:0] counter=0; 
	 wire[N-1:0] counter_nxt;
	 wire sw,tick;
	 assign sw=!sw_low; //sw is now active high
	 
	 //Logic for FSM and free-running-counter 
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
				state_reg<=zero;
				counter<=0;
		end
		
		else begin
				state_reg<=state_nxt;
				counter<=counter_nxt;			
		 end
	 end
	 //next-state logic of FSM and free-running-counter
	 assign counter_nxt=counter+1;
	 assign tick=(counter==0);
	 always @* begin
		 state_nxt=state_reg;
		 db=0;
		 case(state_reg)
				zero: if(sw) state_nxt=mid0_1;
				mid0_1: begin
							if(!sw) state_nxt=zero;
							else if(tick) state_nxt=mid0_2;
						  end
				mid0_2: begin 
							if(!sw) state_nxt=zero;
							else if(tick) state_nxt=one;
						  end
					one: begin
							 db=1;
							 if(!sw) state_nxt=mid1_1;
						  end
				mid1_1: begin
							 db=1;
							 if(sw) state_nxt=one;
							 else if(tick) state_nxt=mid1_2;
						  end
			  mid1_2:  begin
							 db=1;
							 if(sw) state_nxt=one;
							 else if(tick) state_nxt=zero;
						  end
			  default: state_nxt=zero;
		  endcase
	 end


endmodule
