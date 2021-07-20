`timescale 1ns / 1ps

module sdram_TEST(
	input clk,rst_n,
	input rx,
	input[2:0] key,
	//FPGA to SDRAM
	output sdram_clk,
	output sdram_cke, 
	output sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n, 
	output[12:0] sdram_addr,
	output[1:0] sdram_ba, 
	output[1:0] sdram_dqm, 
	inout[15:0] sdram_dq, 
	output[3:0] led,
	output[7:0] seg_out,
	output[5:0] sel_out	
    );
	 //FSM state declarations
	 localparam[3:0] idle=0, 
						  write_test=1, //write data to all address
						  wait_ctr=2, //waiting time for T_RC(active to active delay needed by SDRAM)
						  read_test=3, //read data in all address 
						  wait_valid=4, //wait for data from read cmd and check if its correct
						  top_module=5, //inject error/random data to an arbitrary address 
						  addr_1=6,
						  addr_2=7,
						  data_1_rx=8,
						  data_2_rx=9,
						  sdram_write=10,
						  wait_rest=11;
						  
	 (*KEEP="TRUE"*)reg[3:0] state_q,state_d;
	 wire CLK_OUT;
	 wire key_tick0,key_tick1,key_tick2;
	 
	 reg rw,rw_en;
	 wire ready,s2f_data_valid;
	 reg[23:0] f_addr_q=0,f_addr_d; //23:11=row  , 10:9=bank  , 8:0 col
	 reg[15:0] f2s_data; //fpga-to-sdram data
	 wire[15:0] s2f_data; //sdram to fpga data 
	 (*KEEP="TRUE"*)reg[23:0] error_q=0,error_d; 
	 (*KEEP="TRUE"*)reg[23:0] inj_error_q=0,inj_error_d;
	 reg[3:0] led_q=0,led_d;
	 reg[15:0] f2s_data_q,f2s_data_d;
	 reg rd_uart;
	 wire[7:0] rd_data;
	 wire rx_empty;
	 reg rxd;

	 
	 always @(posedge CLK_OUT,negedge rst_n) begin
		if(!rst_n) begin
			state_q<=idle;
			f_addr_q<=0;
			error_q<=0;
			led_q<=0;
		   inj_error_q<=0;
			f2s_data_q<=0;			
		end
		else begin
			state_q<=state_d;
			f_addr_q<=f_addr_d;
			error_q<=error_d;	
			led_q<=led_d;
			inj_error_q<=inj_error_d;
			f2s_data_q<=f2s_data_d;
		end
	 end
	 
	 always @* begin
		state_d=state_q;
		f_addr_d=f_addr_q;
		error_d=error_q;	
		led_d=led_q;
		inj_error_d=inj_error_q;
		f2s_data_d=f2s_data_q;
		f2s_data=0;
		rw=0;
		rw_en=0;
		rd_uart=0;
		rxd=1;		
		case(state_q)
			      idle: begin //wait for any pushbutton tick
								if(key_tick0==1) begin
									state_d=write_test;
									inj_error_d=0;
								 end
								else if(key_tick1==1) begin
									state_d=read_test; 
									error_d=0;
								end
								else if(key_tick2==1) state_d=top_module;
								f_addr_d={24{1'b1}};
							end
							
							
							////////////write data to all addresses/////////////
			write_test: begin 
								if(ready==1) begin
									rw=0;
									rw_en=1;
									f2s_data=~f_addr_q[15:0]; //data is the inverse of the 16 LSB of the address
									if(f_addr_q==0) begin //if all data is already written,back to idle
										state_d=idle;  
										led_d=4'b1001;
									end
									else begin
										state_d=write_test;
										f_addr_d=f_addr_q-1;
									end
								end
							end							
							
						  ///////////////read data of all addresses/////////////
			 read_test: if(ready==1) begin 
								rw=1;
								rw_en=1;
								state_d=wait_valid;
							end	
			wait_valid: if(s2f_data_valid==1) begin //wait for read data to be valid
								 if(f_addr_q==0) begin //if all data is already read,back to idle
											state_d=idle;  
											led_d=4'b0110;
								 end
								 else begin
										f_addr_d=f_addr_q-1;
										state_d=read_test;									
								 end
								 if(s2f_data!=~f_addr_q[15:0]) error_d=error_q+1;
							 end
							 
							 
							 //////////////logic for transmitting data to sdram via UART/////////////////
			top_module: begin
								rxd=rx; //only at this state is the rx of UART can receive data
								if(rx_empty==0) begin 
									f_addr_d[23:16]=rd_data; //store 1st 8 bits of address
									rd_uart=1'b1; 
									state_d=addr_1;
									led_d=0;
								end
							end
				addr_1: begin
								rxd=rx; 
								if(rx_empty==0) begin 
									f_addr_d[15:8]=rd_data; //2nd 8 bits of address
									rd_uart=1'b1;
									state_d=addr_2;
								end
							end
				addr_2: begin
								rxd=rx;
								if(rx_empty==0) begin
									f_addr_d[7:0]=rd_data; //3rd 8 bits for a total of 24-bit address for sdram
									rd_uart=1'b1;
									state_d=data_1_rx;
									led_d[0]=1;
								end
						  end
			data_1_rx: begin
								rxd=rx;
								if(rx_empty==0) begin
									f2s_data_d[15:8]=rd_data;
									rd_uart=1'b1;
									state_d=data_2_rx;
								end
						   end
			data_2_rx: begin
								rxd=rx;
								if(rx_empty==0) begin
								f2s_data_d[7:0]=rd_data;
								rd_uart=1'b1;
								state_d=sdram_write;
								end
							end
			sdram_write: if(ready==1) begin
								rw=0;   //write
								rw_en=1;
								f2s_data=f2s_data_q;
								state_d=idle;
								led_d[3]=1;
								inj_error_d=inj_error_q+1;
							 end
				 default: state_d=idle;
		endcase
	 end
	 
	 assign led=led_q;
	 
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
		.f2s_data(f2s_data), //fpga-to-sdram data
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
		.wr_uart(),
		.wr_data(),
		.rx(rxd),
		.tx(),
		.rd_data(rd_data),
		.rx_empty(rx_empty),
		.tx_full()
    );	 
	 
	LED_mux m3
	(
		.clk(CLK_OUT),
		.rst(rst_n),
		.in0({2'b00,error_q}),
		.in1({2'b00,inj_error_q}),
		.in2({6'd28}),
		.in3({6'd28}),
		.in4({6'd28}),
		.in5({6'd28}), //format: {dp,char[4:0]} , dp is active high
		.seg_out(seg_out),
		.sel_out(sel_out)
    );
	 
	 
	debounce_explicit m4
	(
		.clk(CLK_OUT),
		.rst_n(rst_n),
		.sw({!key[0]}),
		.db_level(),
		.db_tick(key_tick0)
    );
	 debounce_explicit m5
	(
		.clk(CLK_OUT),
		.rst_n(rst_n),
		.sw({!key[1]}),
		.db_level(),
		.db_tick(key_tick1)
    );
	 debounce_explicit m6
	(
		.clk(CLK_OUT),
		.rst_n(rst_n),
		.sw({!key[2]}),
		.db_level(),
		.db_tick(key_tick2)
    );
	 

endmodule
