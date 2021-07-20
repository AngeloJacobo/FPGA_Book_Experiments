`timescale 1ns / 1ps

module fifo
	#(parameter W=11,B=8) //W for address width , B for data bits  (2k by 8 fifo and uses block RAM for storage)
	(
	input clk,rst_n,
	input wr,rd,
	input[B-1:0] wr_data,
	output[B-1:0] rd_data,
	output reg full,empty	
    );
	 initial begin
		full=0;
		empty=1;
	 end
	 
	 reg[W-1:0] rd_ptr_q=0,rd_ptr_d; 
	 reg[W-1:0] wr_ptr_q=0,wr_ptr_d;
	 reg full_d,empty_d;
	 reg we; //write enable signal for the block ram
	 
	 
	 //assign rd_data=array_reg[rd_ptr];
	 
	 //register operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			rd_ptr_q<=0;
			wr_ptr_q<=0;
			wr_ptr_q<=0;
			full<=0;
			empty<=1;
		end
		else begin
			rd_ptr_q<=rd_ptr_d;
			wr_ptr_q<=wr_ptr_d;
			full<=full_d;
			empty<=empty_d;
		end
	 end
	 
	 
	 always @* begin
	   rd_ptr_d=rd_ptr_q;
		wr_ptr_d=wr_ptr_q;
	   full_d=full;
	   empty_d=empty;
		we=0;
			case({rd,wr})
				2'b01: if(!full) begin //advance the write pointer if not yet full
							we=1;
							wr_ptr_d=wr_ptr_q+1'b1;
							empty_d=0;
							full_d=(wr_ptr_d==rd_ptr_q);
						 end
				2'b10: if(!empty) begin //advance the read pointer if not yet empty(notice that read is synchronous but the operation is immediate, 
							rd_ptr_d=rd_ptr_q+1'b1;          //read data changes instantly as read pointer changes
							full_d=0;
							empty_d=(rd_ptr_d==wr_ptr_q);
						 end
				2'b11: if(!empty && !full) begin  //read and write simultaneous if and only if its not empty and not full
								we=1;                          
								rd_ptr_d=rd_ptr_q+1'b1;
								wr_ptr_d=wr_ptr_q+1'b1;
						 end
			endcase
	 end
	 
	 dual_port_syn
	 #(.ADDR_WIDTH(W),.DATA_WIDTH(B)) m0
		(
			.clk(clk),
			.we(we),
			.din(wr_data),
			.addr_a(wr_ptr_q),
			.addr_b(rd_ptr_d),
			.dout(rd_data)
		);
endmodule

module dual_port_syn //syncrhonous dual port ram(uses block ram)
	#(
		parameter ADDR_WIDTH=11, //12k by 8 RAM (16k block RAM)
					 DATA_WIDTH=8
	)
	(
		input clk,
		input we,
		input[DATA_WIDTH-1:0] din,
		input[ADDR_WIDTH-1:0] addr_a,addr_b, //addr_a for writing address, addr_b for reading address
		output[DATA_WIDTH-1:0] dout
	);
	reg[DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	reg[ADDR_WIDTH-1:0]addr_b_q;
	
	always @(posedge clk) begin
		if(we) ram[addr_a]=din;
		addr_b_q<=addr_b;
	end
	assign dout=ram[addr_b_q];
	
endmodule



