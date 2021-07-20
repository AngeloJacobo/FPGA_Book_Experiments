`timescale 1ns / 1ps

module fifo_test_vector #(parameter W=4,B=8)
	(
		output reg clk,rst_n,
		output reg wr,rd,
		output reg[B-1:0] wr_data
    );
	 always begin
		clk=0;
		#5;
		clk=1;
		#5;
	 end
	 
	 initial begin
		initialize();
		write("A"); ////0
		write("B"); ////1
		write("C"); ////2
		write("D"); ////3
		write("E"); ////4
		write("F"); ////5
		write("G"); ////6
		write("H"); ////7
		read(10); //read(from A to H to x) until empty
		write("I"); ////8
		write("J"); ////9
		write("K"); ////10
		write("L"); ////11
		write("M"); ////12
		write("N"); ////13
		write("O"); ////14
		write("P"); ////15
		write("Q"); ////0
		write("R"); ////1
		write("S"); ////2
		write("T"); ////3
		write("U"); ////4
		write("V"); ////5
		write("W"); ////6
		write("X"); ////7 
		write("Y"); //full
		write("Z"); //full
		read(20); //read(from I to X to I) until empty
		write(1);
		write(2);
		write(3);
		write(4);
		write(5);
		write(6);
		write(7);
		write(8); 
		rd_wr(9); //1
		rd_wr(10); //2
		rd_wr(11); //3
		rd_wr(12); //4
		rd_wr(13); //5
		rd_wr(14); //6
		rd_wr(15); //7
		rd_wr(16); //8
		rd_wr(17); //9
		rd_wr(18); //10
		rd_wr(20); //11
		rd_wr(21); //12
		rd_wr(22); //13
		rd_wr(23); //14
		rd_wr(24); //15
		rd_wr(25); //16
		rd_wr(26); //17
		rd_wr(27); //18
		$stop;
	 end
	 
	 task initialize(); begin
		@(negedge clk);
		rst_n=1;
		wr=0;
		rd=0;
		wr_data=0;
	 end
	 endtask

	 task read(input integer i); begin
		@(negedge clk);
		rd=1;
		repeat(i) @(negedge clk);
		rd=0;
	 end
	 endtask
	 
	 task write(input integer data); begin
		@(negedge clk);
		wr=1;
		wr_data=data;
		@(negedge clk);
		wr=0;
	 end
	 endtask
	
	task rd_wr(input integer data); begin
		@(negedge clk);
		wr=1; 
		rd=1;
		wr_data=data;
		@(negedge clk);
		wr=0; rd=0;
	 end
	 endtask

endmodule
