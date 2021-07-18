`timescale 1ns / 1ps

module early_debounce(
	input clk,rst_n,
	input sw_low,//active low input
	output reg db //active high output
    );
	 //FSM declarations
	 localparam[2:0] start=3'd0,
						  one=3'd1,
						  delay1=3'd2,
						  delay2=3'd3,
						  zero=3'd4,
						  delay3=3'd5;
	 reg[2:0] state_reg,state_nxt;
	 
	 //20-ms counter delarations
	 localparam N=21; // 2^N/50MHz=2^20/50MHz=20.97ms period
	 reg[N-1:0] counter_reg=0;
	 wire tick;
	 wire level=!sw_low;
	 //FSM and 20ms-counter register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=start;
			counter_reg<=0;
		end
		else begin
			state_reg<=state_nxt;
			counter_reg<=counter_reg+1;
		end
	 end
	assign tick=(counter_reg==0); //ticks at the end of every 20.97ms
	 
	 
	 //FSM next-state and output logic
	 always @* begin
		state_nxt=state_reg;
		db=0;
		case(state_reg)
			 start: if(level) state_nxt=one; //rising edge
				one: begin   //wait for 20ms
							db=1;
							if(tick) state_nxt=delay1;
					  end
			delay1: begin //wait for 20ms
						db=1;
						if(tick) state_nxt=delay2;
					  end
			delay2: begin
						 db=1;
						 if(!level) state_nxt=zero; //wait here until falling edge comes
					  end
			  zero: if(tick) state_nxt=delay3;
			delay3: if(tick) state_nxt=start;
			default: state_nxt=start;						
		endcase
	 end

endmodule
