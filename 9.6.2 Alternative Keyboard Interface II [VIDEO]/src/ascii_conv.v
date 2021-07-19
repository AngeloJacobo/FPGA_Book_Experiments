`timescale 1ns / 1ps

module ascii_conv( //converts the real data from kb module to ASCII
	input[8:0] rd_data,
	output reg[7:0] ascii
    );
 always @* begin
		ascii=0;
		case(rd_data)
			{1'b0,8'h45}: ascii = 8'h30; //0
			{1'b0,8'h16}: ascii = 8'h31; //1
			{1'b0,8'h1e}: ascii = 8'h32; //2
			{1'b0,8'h26}: ascii = 8'h33; //3
			{1'b0,8'h25}: ascii = 8'h34; //4
			{1'b0,8'h2e}: ascii = 8'h35; //5
			{1'b0,8'h36}: ascii = 8'h36; //6
			{1'b0,8'h3d}: ascii = 8'h37; //7
			{1'b0,8'h3e}: ascii = 8'h38; //8
			{1'b0,8'h46}: ascii = 8'h39; //9
			
			{1'b1,8'h1c}: ascii = 8'h41; //A
			{1'b1,8'h32}: ascii = 8'h42; //B
			{1'b1,8'h21}: ascii = 8'h43; //C
			{1'b1,8'h23}: ascii = 8'h44; //D
			{1'b1,8'h24}: ascii = 8'h45; //E
			{1'b1,8'h2b}: ascii = 8'h46; //F
			{1'b1,8'h34}: ascii = 8'h47; //G
			{1'b1,8'h33}: ascii = 8'h48; //H
			{1'b1,8'h43}: ascii = 8'h49; //I
			{1'b1,8'h3b}: ascii = 8'h4a; //J
			{1'b1,8'h42}: ascii = 8'h4b; //K
			{1'b1,8'h4b}: ascii = 8'h4c; //L
			{1'b1,8'h3a}: ascii = 8'h4d; //M
			{1'b1,8'h31}: ascii = 8'h4e; //N
			{1'b1,8'h44}: ascii = 8'h4f; //O
			{1'b1,8'h4d}: ascii = 8'h50; //P
			{1'b1,8'h15}: ascii = 8'h51; //Q
			{1'b1,8'h2d}: ascii = 8'h52; //R
			{1'b1,8'h1b}: ascii = 8'h53; //S
			{1'b1,8'h2c}: ascii = 8'h54; //T
			{1'b1,8'h3c}: ascii = 8'h55; //U
			{1'b1,8'h2a}: ascii = 8'h56; //V
			{1'b1,8'h1d}: ascii = 8'h57; //W
			{1'b1,8'h22}: ascii = 8'h58; //X
			{1'b1,8'h35}: ascii = 8'h59; //Y
			{1'b1,8'h1a}: ascii = 8'h5a; //Z
			
			{1'b0,8'h1c}: ascii = 8'h61; //a
			{1'b0,8'h32}: ascii = 8'h62; //b
			{1'b0,8'h21}: ascii = 8'h63; //c
			{1'b0,8'h23}: ascii = 8'h64; //d
			{1'b0,8'h24}: ascii = 8'h65; //e
			{1'b0,8'h2b}: ascii = 8'h66; //f
			{1'b0,8'h34}: ascii = 8'h67; //g
			{1'b0,8'h33}: ascii = 8'h68; //h
			{1'b0,8'h43}: ascii = 8'h69; //i
			{1'b0,8'h3b}: ascii = 8'h6a; //j
			{1'b0,8'h42}: ascii = 8'h6b; //k
			{1'b0,8'h4b}: ascii = 8'h6c; //l
			{1'b0,8'h3a}: ascii = 8'h6d; //m
			{1'b0,8'h31}: ascii = 8'h6e; //n
			{1'b0,8'h44}: ascii = 8'h6f; //o
			{1'b0,8'h4d}: ascii = 8'h70; //p
			{1'b0,8'h15}: ascii = 8'h71; //q
			{1'b0,8'h2d}: ascii = 8'h72; //r
			{1'b0,8'h1b}: ascii = 8'h73; //s
			{1'b0,8'h2c}: ascii = 8'h74; //t
			{1'b0,8'h3c}: ascii = 8'h75; //u
			{1'b0,8'h2a}: ascii = 8'h76; //v
			{1'b0,8'h1d}: ascii = 8'h77; //w
			{1'b0,8'h22}: ascii = 8'h78; //x
			{1'b0,8'h35}: ascii = 8'h79; //y
			{1'b0,8'h1a}: ascii = 8'h7a; //z
			
			
			{1'b0,8'h0e}: ascii = 8'h60; // `
			{1'b0,8'h4e}: ascii = 8'h2d; // - 
			{1'b0,8'h55}: ascii = 8'h3d; // =
			{1'b0,8'h54}: ascii = 8'h5b; // [
			{1'b0,8'h5b}: ascii = 8'h5d; // ]
			{1'b0,8'h5d}: ascii = 8'h5c; // \
			{1'b0,8'h4c}: ascii = 8'h3b; // ;
			{1'b0,8'h52}: ascii = 8'h27; // '
			{1'b0,8'h41}: ascii = 8'h2c; // ,
			{1'b0,8'h49}: ascii = 8'h2e; // .
			{1'b0,8'h4a}: ascii = 8'h2f; // /
			
			{1'b0,8'h29}: ascii = 8'h20; //space
			{1'b0,8'h5a}: ascii = 8'h0d; //enter
			{1'b0,8'h66}: ascii = 8'h08; //backspace
			default: ascii = 8'h2a; //*
			
		endcase
	 end

endmodule
