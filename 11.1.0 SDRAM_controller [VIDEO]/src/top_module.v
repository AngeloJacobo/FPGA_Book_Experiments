`timescale 1ns / 1ps

module top_module(
	//pc to UART
	input clk,rst_n,
	input key,
	input rx,
	output tx,
	//FPGA to SDRAM
	output sdram_clk,
	output sdram_cke, 
	output sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n, 
	output[12:0] sdram_addr,
	output[1:0] sdram_ba, 
	output[1:0] sdram_dqm, 
	inout[15:0] sdram_dq, 
	output[3:0] led
    );
	 	 
	 //FSM state declarations
	 localparam[3:0] idle=0,
							addr_1=1,
							addr_2=2,
							data_1_rx=3,
							data_2_rx=4,
							sdram_write=5,
							sdram_read=6,
							sdram_read_wait=7,
							tx_1=8,
							tx_2=9;
	(*KEEP="TRUE"*)reg[3:0] state_q,state_d;
	
	wire CLK_OUT;
	wire key_tick;
	reg rw,rw_en;
	wire ready,s2f_data_valid;
	reg[23:0] f_addr_q,f_addr_d; //23:11=row  , 10:9=bank  , 8:0 col
	reg[15:0] f2s_data_q,f2s_data_d; //fpga-to-sdram data
	wire[15:0] s2f_data; //sdram to fpga data
	
	reg rd_uart;
	reg wr_uart;
	reg[7:0] wr_data;
	wire[7:0] rd_data;
	wire rx_empty;
	reg[15:0] wr_data_q,wr_data_d;
	reg[3:0] led_q,led_d;
	reg read_test_q,read_test_d; 
	always @(posedge CLK_OUT,negedge rst_n) begin
		if(!rst_n) begin
			state_q<=idle;
			f_addr_q<=0;
			f2s_data_q<=0;		
			wr_data_q<=0;
			led_q<=0;
			read_test_q<=0;
		end
		else begin
			state_q<=state_d;
			f_addr_q<=f_addr_d;
			f2s_data_q<=f2s_data_d;
			wr_data_q<=wr_data_d;
			led_q<=led_d;
			read_test_q<=read_test_d;
		end
	end
	
	always @* begin
		state_d=state_q;
		f_addr_d=f_addr_q;
		f2s_data_d=f2s_data_q;
		rd_uart=0;
		led_d=led_q;
		wr_data_d=wr_data_q;
		wr_uart=0;
		rw=0;
		rw_en=0;
		wr_data=0;
		case(state_q)
			idle: begin
						if(rx_empty==0) begin 
							f_addr_d[23:16]=rd_data; //store 1st 8 bits of address
							rd_uart=1'b1; //flush the read data at the end of clock
							state_d=addr_1;
							led_d=0;
							led_d[0]=1;
						end
					end
			addr_1: if(rx_empty==0) begin 
						f_addr_d[15:8]=rd_data; //2nd 8 bits of address
						rd_uart=1'b1;
						state_d=addr_2;
						led_d[1]=1;
					end
			addr_2: if(rx_empty==0) begin
						f_addr_d[7:0]=rd_data; //3rd 8 bits for a total of 24-bit address for sdram
						rd_uart=1'b1;
						state_d=read_test_q?sdram_read:data_1_rx;    
						led_d[2]=1;
					end
	
			//write to sdram(store new word)
			data_1_rx: if(rx_empty==0) begin
								f2s_data_d[15:8]=rd_data;
								rd_uart=1'b1;
								state_d=data_2_rx;
								led_d[2]=0;
							end

			data_2_rx: if(rx_empty==0) begin
								f2s_data_d[7:0]=rd_data;
								rd_uart=1'b1;
								state_d=sdram_write;
							end
			sdram_write: if(ready==1) begin
								rw=0;   //write
								rw_en=1;
								led_d[2]=1;
								state_d=idle;
							 end
			
			//read sdram(read stored word)
			sdram_read: if(ready==1 && s2f_data_valid==0) begin //ready==1
								rw=1;
								rw_en=1;
								state_d=sdram_read_wait;
							end
			sdram_read_wait: if(s2f_data_valid==1) begin //s2f_data_valid==1
									wr_data_d=s2f_data; //s2f_data
									state_d=tx_1;
								  end
					tx_1:	begin
								wr_uart=1;
								wr_data=wr_data_q[15:8]; //wr_data=wr_data_q[15:8];
								state_d=tx_2;
							end
					tx_2: begin
								wr_uart=1;
								wr_data=wr_data_q[7:0]; //wr_data=wr_data_q[7:0];
								state_d=idle;
								led_d=4'b1111;
							end
				default: state_d=idle;
		endcase
		
		read_test_d=read_test_q;
		if(key_tick==1) begin
			read_test_d=!read_test_q;
			led_d=4'd0;
		end
	end
	
	 assign led=led_q;	 
	 
	 //Instantiate all needed modules
	 
	 //100MHz clock
	 dcm_100MHz m0
   (
		 .clk(clk), // IN
		 // Clock out ports
		 .CLK_OUT(CLK_OUT),     // OUT
		 // Status and control signals
		 .RESET(RESET),// IN
		 .LOCKED(LOCKED)
	 );      // OUT
	 
	 
	 sdram_controller m1(
		//fpga to controller
		.clk(CLK_OUT), //clk=100MHz
		.rst_n(rst_n),  
		.rw(rw), // 1:read , 0:write
		.rw_en(rw_en), //must be asserted before read/write
		.f_addr(f_addr_q), //23:11=row  , 10:9=bank  , 8:0 col
		.f2s_data(f2s_data_q), //fpga-to-sdram data
		.s2f_data(s2f_data), //sdram to fpga data
		.s2f_data_valid(s2f_data_valid), //asserts if read-out data is now valid
		.ready(ready), //"1" if sdram is available for nxt read/write operation
		//controller to sdram
		.s_clk(sdram_clk),
		.s_cke(sdram_cke), 
		.s_cs_n(sdram_cs_n),
		.s_ras_n(sdram_ras_n ), 
		.s_cas_n(sdram_cas_n),
		.s_we_n(sdram_we_n), 
		.s_addr(sdram_addr), 
		.s_ba(sdram_ba), 
		.LDQM(sdram_dqm[0]),
		.HDQM(sdram_dqm[1]),
		.s_dq(sdram_dq) 
    );	
	 
	uart #(.DBIT(8),.SB_TICK(16),.DVSR(326),.DVSR_WIDTH(9),.FIFO_W(2)) m2
	(
		.clk(CLK_OUT),
		.rst_n(rst_n),
		.rd_uart(rd_uart),
		.wr_uart(wr_uart),
		.wr_data(wr_data),
		.rx(rx),
		.tx(tx),
		.rd_data(rd_data),
		.rx_empty(rx_empty),
		.tx_full()
    );
	 
	debounce_explicit m3
	(
		.clk(CLK_OUT),
		.rst_n(rst_n),
		.sw({!key}),
		.db_level(),
		.db_tick(key_tick)
    );
	 


endmodule
