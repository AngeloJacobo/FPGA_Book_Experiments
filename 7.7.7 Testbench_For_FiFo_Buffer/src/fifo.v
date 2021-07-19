`timescale 1ns / 1ps

module fifo
	#(parameter W=11,B=8)
	(
	input clk,rst_n,
	input wr,rd,
	input[B-1:0] wr_data,
	output[B-1:0] rd_data,
	output reg full,empty	
//	output reg[W-1:0] rd_ptr,wr_ptr
    );
	 initial begin
		full=0;
		empty=1;
	 end
	 reg[W-1:0] rd_ptr=0,wr_ptr=0;
	 reg[B-1:0] array_reg[2**W-1:0];

	 
	 //register file operation
	 always @(posedge clk) begin
		if(wr && !full && !(wr&&rd&&empty)) array_reg[wr_ptr]=wr_data;
	 end
	 assign rd_data=array_reg[rd_ptr];
	 
	 //fifo operation
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			rd_ptr=0;
			wr_ptr=0;
			full=0;
			empty=1;
		end
		else begin
			case({rd,wr})
				2'b01: if(!full) begin
							wr_ptr=wr_ptr+1;
							empty=0;
							full=(wr_ptr==rd_ptr);
						 end
				2'b10: if(!empty) begin
							rd_ptr=rd_ptr+1;
							full=0;
							empty=(rd_ptr==wr_ptr);
						 end
				2'b11: if(!empty && !full) begin
								rd_ptr=rd_ptr+1;
								wr_ptr=wr_ptr+1;
						 end
			endcase
		end
	 end

endmodule
