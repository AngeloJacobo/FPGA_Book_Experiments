`timescale 1ns / 1ps

module fifo_monitor #(parameter W=4,B=8)
	(
	input clk,
	input rd,
	input[B-1:0] rd_data,
	input full,empty
    );

	 reg[7:0] array_reg[1024:0];
	 integer i;
	 reg [39:0] msg;
	 
	 initial begin	
		$display("Output Desired");
		i=0;
		array_reg[0]="A";
		array_reg[1]="B";
		array_reg[2]="C";
		array_reg[3]="D";
		array_reg[4]="E";
		array_reg[5]="F";
		array_reg[6]="G";
		array_reg[7]="H";
		//array_reg[8];
		//array_reg[9];
		array_reg[10]="I";
		array_reg[11]="J";
		array_reg[12]="K";
		array_reg[13]="L";
		array_reg[14]="M";
		array_reg[15]="N";
		array_reg[16]="O";
		array_reg[17]="P";
		array_reg[18]="Q";
		array_reg[19]="R";
		array_reg[20]="S";
		array_reg[21]="T";
		array_reg[22]="U";
		array_reg[23]="V";
		array_reg[24]="W";
		array_reg[25]="X";
		array_reg[26]="I";
		array_reg[27]="I";
		array_reg[28]="I";
		array_reg[29]="I";
		array_reg[30]=1;
		array_reg[31]=2;
		array_reg[32]=3;
		array_reg[33]=4;
		array_reg[34]=5;
		array_reg[35]=6;
		array_reg[36]=7;
		array_reg[37]=8;
		array_reg[38]=9;
		array_reg[39]=10;
		array_reg[40]=11;
		array_reg[41]=12;
		array_reg[42]=13;
		array_reg[43]=14;
		array_reg[44]=15;
		array_reg[45]=16;
		array_reg[46]=17;
		array_reg[47]=18;
		array_reg[48]=19;
		array_reg[49]=20;
	 end
	 

	 
	 always @(posedge clk) begin
			if(rd) begin
				i<=i+1;
			end
			if(array_reg[i]==rd_data) begin
				msg=" ";
			end
			else msg="ERROR";
		
			$display("%h %h %s",rd_data,array_reg[i],msg);
			
	 end


endmodule
