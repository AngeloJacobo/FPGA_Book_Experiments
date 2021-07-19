`timescale 1ns / 1ps

module top_module(
	input clk,rst_n,
	input btn0,btn1, //btn0=choose_key , btn1=enter_key 
	input rx, 
	input rd_uart,wr_uart,
	input[7:0] wr_data,
	output[7:0] rd_data,
	output tx,
	output rx_empty,tx_empty,
	output[7:0] seg_out,
	output[5:0] sel_out
    );
	 
	 //FSM state declarations and all wires-reg
	 localparam[2:0] idle=3'd0,
							baud=3'd1,
							databits=3'd2,
							stopbits=3'd3,
							parity=3'd4,
							start=3'd5;
	 wire key0,key1;	
	 wire s_tick;
	 wire rx_done_tick;
	 wire[7:0] dout,tx_read_data;
	 wire parity_error,frame_error;
	 wire rx_full;
	 wire[7:0] tx_rd_data;
	 
	 reg[4:0] in0,in1,in2,in3,in4,in5;				
	 reg[2:0] state_reg,state_nxt;
	 reg[2:0] baud_reg,baud_nxt; //0=1200baud , 1=2400baud , 2=4800baud , 3=9600baud , 4=19200baud , 5=115200baud
	 reg databits_reg,databits_nxt; //0=7bits , 1=8bits
	 reg stopbits_reg,stopbits_nxt; //0=1stopbit , 1=2stopbits
	 reg[1:0] parity_reg,parity_nxt; //0=no parity , 1=odd parity , 2=even parity
	 reg overrun_reg,overrun_nxt;
 	 reg[1:0] error_reg;
	 
	 reg[29:0] baud_disp[5:0];
	 reg[29:0] databits_disp[1:0];
	 reg[29:0] stopbits_disp[1:0];
	 reg[29:0] parity_disp[2:0];
	 reg[29:0] error_disp[3:0];
	 
	 reg[11:0] baud_dvsr;
	 reg[3:0] databits_val;
	 reg[5:0] stopbits_val;
	 
	 //values for the seven segments stored for easier retrieval when needed
	 initial begin
		baud_disp[0]={{5'd29},{5'd29},{5'd1},{5'd2},{5'd0},{5'd0}}; //1200
		baud_disp[1]={{5'd29},{5'd29},{5'd2},{5'd4},{5'd0},{5'd0}}; //2400
		baud_disp[2]={{5'd29},{5'd29},{5'd4},{5'd8},{5'd0},{5'd0}}; //4800
		baud_disp[3]={{5'd29},{5'd29},{5'd9},{5'd6},{5'd0},{5'd0}}; //9600
		baud_disp[4]={{5'd29},{5'd1},{5'd9},{5'd2},{5'd0},{5'd0}}; //19200
		baud_disp[5]={{5'd1},{5'd1},{5'd5},{5'd2},{5'd0},{5'd0}}; //115200
		
		databits_disp[0]={{5'd29},{5'd29},{5'd29},{5'd29},{5'd29},{5'd7}}; //7
		databits_disp[1]={{5'd29},{5'd29},{5'd29},{5'd29},{5'd29},{5'd8}}; //8
		
		stopbits_disp[0]={{5'd29},{5'd29},{5'd29},{5'd29},{5'd29},{5'd1}}; //1
		stopbits_disp[1]={{5'd29},{5'd29},{5'd29},{5'd29},{5'd29},{5'd2}}; //2
		
		parity_disp[0]={{5'd29},{5'd29},{5'd21},{5'd22},{5'd21},{5'd14}}; //NONE
		parity_disp[1]={{5'd29},{5'd29},{5'd29},{5'd22},{5'd13},{5'd13}}; //Odd
		parity_disp[2]={{5'd29},{5'd29},{5'd14},{5'd26},{5'd14},{5'd21}}; //EVEN
		
		error_disp[0]={{5'd30},{5'd30},{5'd30},{5'd30},{5'd30},{5'd30}}; //-----
		error_disp[1]={{5'd15},{5'd24},{5'd10},{5'd30},{5'd14},{5'd24}}; //FRA-ER    frame error
		error_disp[2]={{5'd23},{5'd10},{5'd24},{5'd30},{5'd14},{5'd24}}; //PAR-ER    parity error
		error_disp[3]={{5'd22},{5'd26},{5'd24},{5'd30},{5'd14},{5'd24}}; //OVR-ER    overrun error
	 end
	 
	 //FSM register operations
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_reg<=idle;
			baud_reg<=0;
			databits_reg<=0;
			stopbits_reg<=0;
			parity_reg<=0;
			overrun_reg<=0;
		end
		
		else begin
			state_reg<=state_nxt;
			baud_reg<=baud_nxt;
			databits_reg<=databits_nxt;
			stopbits_reg<=stopbits_nxt;
			parity_reg<=parity_nxt;
			overrun_reg<=overrun_nxt;
		end
	 end
	 
	 //FSM  next-state logics
	 always @*begin
		state_nxt=state_reg;
		baud_nxt=baud_reg;
		databits_nxt=databits_reg;
		stopbits_nxt=stopbits_reg;
		parity_nxt=parity_reg;
		error_reg=0;
		{in5,in4,in3,in2,in1,in0}={{5'd29},{5'd29},{5'd29},{5'd29},{5'd29},{5'd29}};
		case(state_reg) 
				 idle: begin 
							baud_nxt=0;
							databits_nxt=0;
							stopbits_nxt=0;
							parity_nxt=0;
							state_nxt=baud;
										
						 end
			  	 baud: begin //choose baud rate by pressing key0, press key1 to enter
							{in5,in4,in3,in2,in1,in0}=baud_disp[baud_reg];
							if(key1==1) state_nxt=databits;
							else if(key0==1) baud_nxt=(baud_reg==5)? 0 : baud_reg+1;
						 end
			databits: begin //choose number of databits by pressing key0, press key1 to enter
							{in5,in4,in3,in2,in1,in0}=databits_disp[databits_reg];
							if(key1==1) state_nxt=stopbits;
							else if(key0==1) databits_nxt=databits_reg+1;
						 end
			stopbits: begin //choose number of stopbits by pressing key0, press key1 to enter
							{in5,in4,in3,in2,in1,in0}=stopbits_disp[stopbits_reg];
							if(key1==1) state_nxt=parity;
							else if(key0==1) stopbits_nxt=stopbits_reg+1;
						 end
			  parity: begin //choose type of parity by pressing key0, press key1 to enter
							{in5,in4,in3,in2,in1,in0}=parity_disp[parity_reg];
							if(key1==1) state_nxt=start;
							else if(key0==1) parity_nxt=(parity_reg==2)? 0 : parity_reg+1;
						 end
			   start: begin //detects error , stays here until reset 		
							if(frame_error) error_reg=1;
							else if(parity_error) error_reg=2;
							else if(overrun_reg) error_reg=3;
							{in5,in4,in3,in2,in1,in0}=error_disp[error_reg];
						 end
			 default: state_nxt=idle;
		endcase
	 end
	 
	 //determine the baudrate,databits, and stopbits depending on owner's choice 
	 always @* begin
	 baud_dvsr=162;
	 databits_val=8;
	 stopbits_val=16;
	 overrun_nxt=overrun_reg; 
		case(baud_reg) //determine the tick needed for the baud rate
			0: baud_dvsr=2605; //1200 -> 50*10^6 * 1/(16*1200) =2605
			1: baud_dvsr=1303; //2400 
			2: baud_dvsr=652; //4800
			3: baud_dvsr=326; //9600 
			4: baud_dvsr=162; //19200 
			5: baud_dvsr=27; //115200 
		endcase
		case(databits_reg)
			0: databits_val=7;
			1: databits_val=8;
		endcase
		case(stopbits_reg)
			0: stopbits_val=16;
			1: stopbits_val=32;
		endcase
		
		//overrun_error logic
		if(rx_full && rx_done_tick) overrun_nxt=1; // overrun happens when UART receives new value but rx is still full
		else if((!rx_full && rx_done_tick) || rd_uart) overrun_nxt=0; 
	 end
	 //module instantiations
	debounce_explicit m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw({!btn0}),
		.db_level(),
		.db_tick(key0)
    );
	 
	 debounce_explicit m0_1
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw({!btn1}),
		.db_level(),
		.db_tick(key1)
    );
	 
	 baud_generator m1
	(
		.clk(clk),
		.rst_n(rst_n),
		.baud_dvsr(baud_dvsr), //2605 for 12000baud , 1303 for 2400baud , 652 for 4800baud , 326 for 9600baud , 162 for 19200 , 27 for 115200
		.s_tick(s_tick)
    );
	uart_rx m2 //receiver
	(
		.clk(clk),
		.rst_n(rst_n),
		.rx(rx),
		.s_tick(s_tick),
		.databits(databits_val), //either 8 or 7 databits
		.stopbits(stopbits_val), //either 16 or 32 ticks for 1 and 2 stopbits,respectively
		.paritybit(parity_reg), //0-no parity, 1=odd parity , 2=even parity
		.rx_done_tick(rx_done_tick),
		.dout(dout),
		.parity_error(parity_error), //high if there is error
		.frame_error(frame_error) //high if there is error
    );
	 
	fifo #(.W(4),.B(8)) m3 //8x2^2 fifo
	(
		.clk(clk),
		.rst_n(rst_n),
		.wr(rx_done_tick),
		.rd(rd_uart),
		.wr_data(dout),
		.rd_data(rd_data),
		.full(rx_full),
		.empty(rx_empty)
    );
	 
	 uart_tx m4
	(
		.clk(clk),
		.rst_n(rst_n),
		.s_tick(s_tick),
		.tx_start(tx_empty),
		.din(tx_rd_data),
		.databits(databits_val), //either 8 or 7 databits
		.stopbits(stopbits_val), //either 16 or 32 ticks for 1 and 2 stopbits,respectively
		.paritybit(parity_reg), //0-no parity, 1=odd parity , 2=even parity
		.tx_done_tick(tx_done_tick),
		.tx(tx)
    );
	 
	 fifo #(.W(4),.B(8)) m5 //8x2^2 fifo
	(
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr_uart),
		.rd(tx_done_tick),
		.wr_data(wr_data),
		.rd_data(tx_rd_data),
		.full(),
		.empty(tx_empty)
    );
	 
	 LED_mux m6
	(
		.clk(clk),
		.rst(rst_n),
		.in0({1'b0,in0}),
		.in1({1'b0,in1}),
		.in2({1'b0,in2}),
		.in3({1'b0,in3}),
		.in4({1'b0,in4}),
		.in5({1'b0,in5}), //format: {dp,char[4:0]} , dp is active high
		.seg_out(seg_out),
		.sel_out(sel_out)
    );
	 

endmodule
