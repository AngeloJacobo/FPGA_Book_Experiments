`timescale 1ns / 1ps

module top_module(
	input clk,rst_n,
	input btn0,btn1, //btn0=enter key , btn1=activate the autobaud-parity detector then wait for the "" and "p" input
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
	 wire key0;	
	 wire s_tick;
	 wire rx_done_tick;
	 wire[7:0] dout,tx_read_data;
	 wire parity_error,frame_error;
	 wire rx_full;
	 wire[7:0] tx_rd_data;
	 wire autobaud_done,bin2bcd_done;
	 wire[3:0] dig0,dig1,dig2,dig3,dig4,dig5;
	 wire[1:0] paritybit; //0=no parity , 1=odd parity , 2=even parity
	 wire[11:0] baud_dvsr;
	 wire[17:0] baud_rate;
	 reg[4:0] in0,in1,in2,in3,in4,in5;	
	 
	 reg[2:0] state_reg,state_nxt;
	 reg overrun_reg,overrun_nxt;
 	 reg[1:0] error_reg;
	 reg[29:0] parity_disp[2:0];
	 reg[29:0] error_disp[3:0];
	


	 //values for the seven segments
	 initial begin
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
			overrun_reg<=0;
		end
		
		else begin
			state_reg<=state_nxt;
			overrun_reg<=overrun_nxt;
		end
	 end
	 
	 //FSM  next-state logics
	 always @*begin
		state_nxt=state_reg;
		error_reg=0;
		{in5,in4,in3,in2,in1,in0}={{5'd29},{5'd29},{5'd29},{5'd29},{5'd29},{5'd29}};
		case(state_reg) 
				 idle: if(bin2bcd_done==1) state_nxt=baud; 	
			  	 baud: begin //display the detected baud rate
							{in5,in4,in3,in2,in1,in0}={{1'b0,dig5},{1'b0,dig4},{1'b0,dig3},{1'b0,dig2},{1'b0,dig1},{1'b0,dig0}};
							if(key0==1) state_nxt=databits;
						 end
			databits: begin //display number of databits(which is fixed to 8)
							{in5,in4,in3,in2,in1,in0}={{5'd29},{5'd29},{5'd29},{5'd29},{5'd29},{5'd8}};
							if(key0==1) state_nxt=stopbits;
						 end
			stopbits: begin //display number of stopbits(which is fixed to 1)
							{in5,in4,in3,in2,in1,in0}={{5'd29},{5'd29},{5'd29},{5'd29},{5'd29},{5'd1}};
							if(key0==1) state_nxt=parity;
						 end
			  parity: begin //cdisplay the detected type of parity
							{in5,in4,in3,in2,in1,in0}=parity_disp[paritybit];
							if(key0==1) state_nxt=start;
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
	 
	 //overrun_error logic
	 always @* begin
		overrun_nxt=overrun_reg; 
		if(rx_full && rx_done_tick) overrun_nxt=1;
		else if((!rx_full && rx_done_tick) || rd_uart) overrun_nxt=0;
	 end
	 
	 
	 //module instantiations
	autobaud_plus_autoparity m00(
		.clk(clk),
		.rst_n(rst_n),
		.key0(btn1),
		.rx(rx),
		.s_tick(s_tick),
		.baud_dvsr(baud_dvsr),
		.baud_rate(baud_rate),
		.done_tick(autobaud_done),
		.paritybit(paritybit)
    );
	 
	debounce_explicit m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw({!btn0}),
		.db_level(),
		.db_tick(key0)
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
		.databits(8), //either 8 or 7 databits
		.stopbits(16), //either 16 or 32 ticks for 1 and 2 stopbits,respectively
		.paritybit(paritybit), //0-no parity, 1=odd parity , 2=even parity
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
		.databits(8), //either 8 or 7 databits
		.stopbits(16), //either 16 or 32 ticks for 1 and 2 stopbits,respectively
		.paritybit(paritybit), //0-no parity, 1=odd parity , 2=even parity
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
	 
	bin2bcd m7
	(
		.clk(clk),
		.rst_n(rst_n),
		.start(autobaud_done),
		.bin(baud_rate),
		.ready(),
		.done_tick(bin2bcd_done),
		.dig0(dig0),
		.dig1(dig1),
		.dig2(dig2),
		.dig3(dig3),
		.dig4(dig4),
		.dig5(dig5),
		.dig6(),
		.dig7(),
		.dig8(),
		.dig9(),
		.dig10()
    );

endmodule
