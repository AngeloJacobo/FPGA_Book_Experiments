`timescale 1ns / 1ps

module sqwave_gen(
	input clk,rst_n,
	input[3:0] m,n,
	output out
    );
	 
	 reg[6:0] m_reg=0,n_reg=0; //counter for ON period of m*(100ns) and OFF period of n*(100ns)
	 reg sq_reg=0; //square wave output
	 reg[6:0] m_nxt=0,n_nxt=0;
	 reg sq_nxt=0;
	 reg m_max=0,n_max=0;
	 
	 //registers
	 always @(posedge clk,negedge rst_n) begin
		 if(!rst_n) begin
			m_reg<=0;
			n_reg<=0;
			sq_reg<=0;
		end
		
		else begin
			m_reg<=m_nxt;
			n_reg<=n_nxt;
			sq_reg<=sq_nxt;
		end
	end
	
	//next-state logic
	always @* begin
	m_nxt=m_reg;
	n_nxt=n_reg;
	m_max=0;
	n_max=0;
	sq_nxt=0;
		
		if( m==4'd0 || n==4'd0) begin  //if m or n is zero then out must remain in one position
			m_nxt=0;
			n_nxt=0;
			casez({|m,|n}) //reduction operator
			2'b00: sq_nxt=0;
			2'b01: sq_nxt=0;
			2'b10: sq_nxt=1;
			default: sq_nxt=0;
			endcase
		end
		
		//OFF logic with duration of n*100ns
		else if(sq_reg==0) begin
			m_nxt=0;
			n_nxt=(n_reg==5*n-1)?0:n_reg+1;  //50MHz*100ns*n=5*n
			n_max=(n_reg==5*n-1)?1:0;        //50MHz*100ns*n=5*n
			sq_nxt=n_max?1:0;
			end
		//ON logic with duration of m*100ns
		else if(sq_reg==1) begin
			n_nxt=0;
			m_nxt=(m_reg==5*m-1)?0:m_reg+1;
			m_max=(m_reg==5*m-1)?1:0;
			sq_nxt=m_max?0:1;
		end
	end
	
	assign out=sq_reg;
		
endmodule
