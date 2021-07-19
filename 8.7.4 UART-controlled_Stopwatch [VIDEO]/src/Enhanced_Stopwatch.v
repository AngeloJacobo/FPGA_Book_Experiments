`timescale 1ns / 1ps

module Enhanced_Stopwatch(   
	input clk,rst_n,
	input up,go,clr, // up-> 1:Count up 0:Count down    go->1:play 0:pause    clr-->back to 0.00.0
	output[4:0] in0,in1,in2,in3,in4,in5
    );
	 
	 //NOTE: LED display format of stopwatch: M.S1S0.D. This will automatically stop at 0.00.0 when counting down and will stop at 9.59.9 when counting up
	 reg[22:0] mod_5M=0; //period of 0.1 sec (5M/50MHz=0.1 sec)
	 reg[3:0] D=0,S0=0,M=0; //D=Decimal  S0=1st digit of seconds   S1=2nd digit of seconds   M=Minutes
	 reg[2:0] S1=0; //S1 counts from 0 to 5 only so 3 bits is enough
	 reg[22:0] mod_5M_nxt=0;
	 reg[3:0] D_nxt=0,S0_nxt=0,M_nxt=0;
	 reg[2:0] S1_nxt=0;
	 reg mod_5M_max=0,D_max=0,S0_max=0,S1_max=0,M_max=0;
	 //registers
	 always @(posedge clk,negedge rst_n) begin
		 if(!rst_n) begin
			mod_5M<=0;
			D<=0;
			S0<=0;
			S1<=0;
			M<=0;
	
		 end
		 
		 else begin
			 if(clr) begin
				mod_5M<=0;
				D<=0;
				S0<=0;
				S1<=0;
				M<=0;	
			 end
			 else if(go) begin 
				mod_5M<=mod_5M_nxt;
				D<=D_nxt;
				S0<=S0_nxt;
				S1<=S1_nxt;
				M<=M_nxt;
			 end
		 end
	 end
	 
	 //next-state logics
	 always @* begin
	 mod_5M_nxt=mod_5M;
	 D_nxt=D;
	 S0_nxt=S0;
    S1_nxt=S1;
    M_nxt=M;	
	 mod_5M_max=0;
	 D_max=0;
	 S0_max=0;
	 S1_max=0;
	 M_max=0;
 			 mod_5M_nxt=  up? mod_5M+1:mod_5M-1;  //counter with 0.1 period
			 mod_5M_max= (mod_5M_nxt==5_000_000|| mod_5M_nxt=={23{1'b1}}) ? 1:0; //Notify next line when 5_000_000(max when counting up) is reached or when 23{1'b1}(counting down from zero) is reached
			 mod_5M_nxt= (mod_5M_nxt==5_000_000) ? 0:mod_5M_nxt; //5_000_000  must never be reach(since 4_999_999 is the ceiling) so go back to zero. This happens when we count up from 4_999_999
			 mod_5M_nxt= (mod_5M_nxt=={23{1'b1}}) ? 4_999_999:mod_5M_nxt; //{23{1'b1}} must never be reach since 4_999_999 is the hihgest . This happens when we count down from zero.
			 
			 if(mod_5M_max) begin //decimal digit(counts from 0.0 to 0.9 sec
			 D_nxt=up?D+1:D-1;
			 D_max=(D_nxt==10 || D_nxt==4'b1111)?1:0;  //Notify next line when 4'd10(max when counting up) is reached or when 4'b1111(counting down from zero) is reached
			 D_nxt=(D_nxt==10)?0:D_nxt; //10  must never be reach(since 9 is the ceiling) so go back to zero. This happens when we count up from 9
			 D_nxt=(D_nxt==4'b1111)?9:D_nxt; ////4'b1111 must never be reach(since 9 or 4'b1010 is the highest) so go back to zero. This happens when we count down from zero.
			 end
			 
			 if(D_max && mod_5M_max) begin //first digit of seconds(counts from 0 to 9 sec)
			 S0_nxt=up?S0+1:S0-1;
			 S0_max=(S0_nxt==10 || S0_nxt==4'b1111)?1:0; //Notify next line when 4'd10(max when counting up) is reached or when 4'b1111(counting down from zero) is reached
			 S0_nxt=(S0_nxt==10)?0:S0_nxt; //10  must never be reach(since 9 is the ceiling) so go back to zero. This happens when we count up from 9
			 S0_nxt=(S0_nxt==4'b1111)? 9:S0_nxt; ////4'b1111 must never be reach(since 9 or 4'b1010 is the highest) so go back to zero. This happens when we count down from zero.
			 end
			 
			 if(S0_max && D_max && mod_5M_max) begin //second digit of seconds(counts from 0 to 5)
			 S1_nxt=up?S1+1:S1-1;
			 S1_max=(S1_nxt==6 || S1_nxt==3'b111)?1:0;//Notify next line when 3'd6(max when counting up) is reached or when 4'b1111(counting down from zero) is reached
			 S1_nxt=(S1_nxt==6)?0:S1_nxt; //6  must never be reach(since 5 is the ceiling) so go back to zero. This happens when we count up from 5
			 S1_nxt=(S1_nxt==3'b111)?5:S1_nxt; ////3'b111 must never be reach(since 5 or 3'b101 is the highest) so go back to zero. This happens when we count down from zero.
			 end
			 
			 if(S1_max && S0_max && D_max && mod_5M_max) begin //Minutes digit(counts from 0 to 9)
			 M_nxt=up?M+1:M-1;
			 M_max=(M_nxt==10 || M_nxt==4'b1111)?1:0; //If 10 is reached then notify next line to STOP COUNTING SINCE 9.59.9 4_999_999 is the MAX)
																  //If 0 is 4'b1111 is reached then notify next line to STOP COUNTING SINCE 0.00.0 0_000_000 is the MIN)
			 end		
		
		 if(M_max==1) begin //if M_max_nxt is asserted,then replaced all register with previous value, WITHOUT THIS THE STOPWATCH WILL STOP AT F.59.9 no at 0.00.00 when counting down
			 mod_5M_nxt=mod_5M;
			 D_nxt=D;
			 S0_nxt=S0;
			 S1_nxt=S1;
			 M_nxt=M;
		 end
	 
	 end
	 assign in0={1'b0,D},
			  in1={1'b1,S0},
			  in2={2'b0,S1},
			  in3={1'b1,M},
			  in4=0,
			  in5=0;
	





endmodule