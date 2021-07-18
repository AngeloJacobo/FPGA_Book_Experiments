`timescale 1ns / 1ps

module Stack
	#(parameter W=4,B=8)
	(
	input clk,rst,
	input [B-1:0] wr_data,
	input push,pop, //write,read
	output reg empty,full,
	output[B-1:0] rd_data,
	output[W-1:0] stack_ptr
    );
	 
	 initial begin
	 empty=1;
	 full=0;
	 end
	 
	 reg[B-1:0] array_reg[2**W-1:0];
	 reg[W-1:0] stack_pointer=0;
	 reg empty_nxt,full_nxt;
	 reg[W-1:0] stack_pointer_nxt=0;
	 
	 //register-file operation
	 always @(posedge clk) begin
	 if(!full && push) //synchronous write
		array_reg[stack_pointer]<=wr_data;
	 end
	 assign rd_data=array_reg[stack_pointer];  //asynchronous read
	 
	 //register operations
	 always @(posedge clk,posedge rst) begin
		if(rst) begin 
			stack_pointer<=0;
			empty<=1;
			full<=0;
		end
		else begin
			stack_pointer<=stack_pointer_nxt;
			empty<=empty_nxt;
			full<=full_nxt;
		end
	 end
	 
	 //next-state logics
	 always @* begin
	 stack_pointer_nxt=stack_pointer;
	 full_nxt=full;
	 empty_nxt=empty;
		 case({push,pop})
			//2'b00: do nothing
			2'b01: if(!empty) begin //read
						stack_pointer_nxt=stack_pointer-1;
						full_nxt=0;
						empty_nxt=(stack_pointer_nxt==0)?1:0;
					 end
			2'b10: if(!full) begin//write
						stack_pointer_nxt=stack_pointer+1;
						empty_nxt=0;
						full_nxt=(stack_pointer_nxt==0)?1:0;
					 end
			//2'b11: after writing,read it immediately, THUS STACK_POINTER WILL NOT MOVE		 
			
		 endcase
	 end
	 assign stack_ptr=stack_pointer;

	 


endmodule
