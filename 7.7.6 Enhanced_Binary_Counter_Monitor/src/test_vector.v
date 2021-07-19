`timescale 1ns / 1ps

module test_vector
	#(parameter N=3,T=20)
	(
	output reg clk,rst_n,
	output reg syn_clr,load,en,up,
	output reg[N-1:0] d
    );
	 
	 always begin
		clk=0;
		#(T/2);
		clk=1;
		#(T/2);
	 end
	 
	 initial begin
		initialize(); 
		counting(10,1); //count up for 10 cycles(0-7-2)
		load_data(5); //load 5
		counting (7,0); //count down for 7 cycles(7-0-6)
		_syn_clr(); //clear
		counting(4,1); //count up for 4 cycles (0-4);
		asyn_clr(); //rst
		load_data(7); //load 7
		counting(7,0) ; //count down for 7 cycles (7-0)		
		$stop;
	 end
	 
	 task initialize(); begin //initialize value
		@(negedge clk);
		rst_n=1;
		syn_clr=0;
		load=0;
		en=0;
		up=0;
		d=0;
	 end
	 endtask
	 
	 task asyn_clr(); begin //reset
		@(negedge clk);
		rst_n=0;
		#(T/4);
		rst_n=1;
	 end
	 endtask
	 
	 task _syn_clr(); begin
		@(negedge clk);
		syn_clr=1;
		@(negedge clk);
		syn_clr=0;
	 end
	 endtask
	 
	 task load_data(input integer n); begin //load value
		@(negedge clk);
		load=1;
		d=n;
		@(negedge clk);
		load=0;
	 end
	 endtask
	 
	 task counting(input integer count,input updown); begin //count up/down
		@(negedge clk);
		en=1;
		up=updown;
		repeat(count) @(negedge clk);
		en=0;
	 end
	 endtask

	 
	 









endmodule




