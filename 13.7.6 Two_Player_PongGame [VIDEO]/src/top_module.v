`timescale 1ns / 1ps

module top_module
	(
		input clk, rst_n,
		input rx, //player 1 paddle controller: "w" for up, "s" for down
		input[1:0] key, //player 2 paddle controller: key[0] for up, key[1] for down
		output[4:0] vga_out_r,
		output[5:0] vga_out_g,
		output[4:0] vga_out_b,
		output vga_out_vs,vga_out_hs
    );
	 
	wire clk_out;
	wire video_on;
	wire[11:0] pixel_x,pixel_y;
	reg rd_uart;
	reg[1:0] player2_q,player2_d;
	wire[7:0] rd_data;
	wire rx_empty;
	 
	 
	 //register logic for player 2(uses keyboard via UART)
	 always @(posedge clk_out,negedge rst_n) begin
		if(!rst_n) player2_q<=0;
		else player2_q<=player2_d;
	 end
	 
	 
	 //uart logic for controlling the paddle of player_2
	 always @* begin
		player2_d=player2_q;
		rd_uart=0;
		
			if((pixel_y==500 && pixel_x==10)||(pixel_y==500 && pixel_x==20)) begin 
				rd_uart=1; //empty the uart fifo when no display(i.e. during refresh)
				player2_d=0;
			end
			else if(!rx_empty) begin
				if(rd_data==8'h73) player2_d=2'b10; //move down when "s" is pressed
				else if(rd_data==8'h77) player2_d=2'b01; //move up "w" is pressed
			end
	end
	
	
	//instantiate modules
	dcm_25MHz m0
   (// Clock in ports
		 .clk(clk),      // IN
		 // Clock out ports
		 .clk_out(clk_out),     // OUT
		 // Status and control signals
		 .RESET(RESET),// IN
		 .LOCKED(LOCKED)
	 );
	 vga_core m1
	(
		.clk(clk_out),
		.rst_n(rst_n), //clock must be 25MHz for 640x480 
		.hsync(vga_out_hs),
		.vsync(vga_out_vs),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y)
    );
	 
	 pong_animated m2 //pong game with 2 players. Player 1 uses FPGA board switch. Player 2 uses keyboard via UART
	 (
		.clk(clk_out),
		.rst_n(rst_n),
		.key({player2_q,key}),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.r(vga_out_r),
		.g(vga_out_g),
		.b(vga_out_b)
    );	
	 
	 uart m3
	(
		.clk(clk),
		.rst_n(rst_n),
		.rd_uart(rd_uart),
		.wr_uart(),
		.wr_data(),
		.rx(rx),
		.tx(),
		.rd_data(rd_data),
		.rx_empty(rx_empty),
		.tx_full()
    );
			
	
	 
	 
	 
endmodule 
