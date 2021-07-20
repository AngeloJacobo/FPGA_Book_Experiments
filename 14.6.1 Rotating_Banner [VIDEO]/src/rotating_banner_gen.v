`timescale 1ns / 1ps

 module rotating_banner_gen(
	input clk,rst_n,
	input[3:0] key, //key[1:0]=char size , key[3:2]=rotating speed
	input[9:0] pixel_x,pixel_y,
	input video_on,
	output reg[2:0] rgb
    );
	 
	 reg[1:0] size_q=0; //stores current size ( 0=16x32 , 1=32x64 , 2=64x128 , 3=28x256 )
	 reg[1:0] speed_q=0; //stores current speed
	 reg[6:0] ascii_addr; //determines the char at given tile
	 reg[3:0] row_addr; //determines the row to be scanned on a given ascii char
	 reg[2:0] column_addr; //determines the bit pixel to be scanned on a given row
	 reg text_on; //determines if the tile has a character
	 reg[6:0] array1[0:39]; //register file for bannner with 16x32 char size,index is reverse for easier access
	 reg[6:0] array2[0:19]; //register file for bannner with 32x64 char size,index is reverse for easier access
	 reg[6:0] array3[0:15]; //register file for bannner with 64x128 and 128x256 char sizes,index is reverse for easier access
	 wire key0_tick,key1_tick,key2_tick,key3_tick;
	 wire[7:0] font_data;
	 wire font_bit;
	 wire tick_60Hz;
	 reg tick1,tick2,tick3,tick4; ///determines the speed of rotation,tick1 is the fastest
	 reg[9:0] timer1_q=0,timer2_q=0,timer3_q=0,timer4_q=0;
	 reg[5:0] counter_q=0,counter_d;
	 reg[6:0] array_addr;
	 integer i;

	 initial begin //initial values of array1,array2, and array3
		for(i=0;i<=39;i=i+1) begin //make all values zero to remove unknowns
			array1[i]=0;
			if(i<=19) array2[i]=0;
			if(i<=15)array3[i]=0;
		end
		array1[0]=7'h48; //H
		array1[1]=7'h45; //E
		array1[2]=7'h4c; //L
		array1[3]=7'h4c; //L
		array1[4]=7'h4f; //O
		array1[5]=7'h00; //
		array1[6]=7'h46; //F
		array1[7]=7'h50; //P
		array1[8]=7'h47; //G
		array1[9]=7'h41; //A
		array1[10]=7'h00; //
		array1[11]=7'h57; //W
		array1[12]=7'h4f; //O
		array1[13]=7'h52; //R
		array1[14]=7'h4c; //L
		array1[15]=7'h44; //D
		
		array2[0]=7'h48; //H
		array2[1]=7'h45; //E
		array2[2]=7'h4c; //L
		array2[3]=7'h4c; //L
		array2[4]=7'h4f; //O
		array2[5]=7'h00; //
		array2[6]=7'h46; //F
		array2[7]=7'h50; //P
		array2[8]=7'h47; //G
		array2[9]=7'h41; //A
		array2[10]=7'h00; //
		array2[11]=7'h57; //W
		array2[12]=7'h4f; //O
		array2[13]=7'h52; //R
		array2[14]=7'h4c; //L
		array2[15]=7'h44; //D
		
		array3[0]=7'h48; //H
		array3[1]=7'h45; //E
		array3[2]=7'h4c; //L
		array3[3]=7'h4c; //L
		array3[4]=7'h4f; //O
		array3[5]=7'h00; //
		array3[6]=7'h46; //F
		array3[7]=7'h50; //P
		array3[8]=7'h47; //G
		array3[9]=7'h41; //A
		array3[10]=7'h00; //
		array3[11]=7'h57; //W
		array3[12]=7'h4f; //O
		array3[13]=7'h52; //R
		array3[14]=7'h4c; //L
		array3[15]=7'h44; //D
	 end
	 
	 //register operation for changing size or speed
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			size_q<=0;
			speed_q<=0;
			counter_q<=0;
			timer1_q<=0;
			timer2_q<=0;
			timer3_q<=0;
			timer4_q<=0;
		end
		else begin
			size_q<=key0_tick? size_q+1:key1_tick? size_q-1:size_q;
			speed_q<=key2_tick? speed_q+1:key3_tick? speed_q-1:speed_q;
			counter_q<=counter_d;
			//timers for rotation speed
			if(tick_60Hz) begin
				timer1_q<=(timer1_q==3)?0:timer1_q+1; //timer_1 has duration 1x of 60Hz tick
				timer2_q<=(timer2_q==10)?0:timer2_q+1; //timer_2 has duration 2x of 60Hz tick
				timer3_q<=(timer3_q==20)?0:timer3_q+1; //timer_3 has duration 3x of 60Hz tick
				timer4_q<=(timer4_q==40)?0:timer4_q+1; //timer_4 has duration 4x of 60Hz tick
			end
				//tick logic for its ocrresponding speed
			tick1=(timer1_q==3 && tick_60Hz);
			tick2=(timer2_q==10 && tick_60Hz);
			tick3=(timer3_q==20 && tick_60Hz);
			tick4=(timer4_q==40 && tick_60Hz);			
		end
	 end	
	 
	 assign tick_60Hz= (pixel_x==0 && pixel_y==500); //60Hz tick signal from VGA controller logic(since VGA is set at 60Hz),use as base speed 
	 
	 
	 //logic for speed of rotation
	 always @* begin
		counter_d=counter_q;
		if(key0_tick || key1_tick) counter_d=0; //if char size changes, return the counter_q to default to prevent any unforseenable error 
		else begin
			case(speed_q)
				0: begin
						if(tick1)
						case(size_q)
							0: counter_d=(counter_q==39)? 0:counter_q+1;
							1: counter_d=(counter_q==19)? 0:counter_q+1;
							2: counter_d=(counter_q==15)? 0:counter_q+1;
							3: counter_d=(counter_q==15)? 0:counter_q+1;		
						endcase
					end
				1: begin
						if(tick2)
						case(size_q)
							0: counter_d=(counter_q==39)? 0:counter_q+1;
							1: counter_d=(counter_q==19)? 0:counter_q+1;
							2: counter_d=(counter_q==15)? 0:counter_q+1;
							3: counter_d=(counter_q==15)? 0:counter_q+1;		
						endcase
					end
				2: begin
						if(tick3)
						case(size_q)
							0: counter_d=(counter_q==39)? 0:counter_q+1;
							1: counter_d=(counter_q==19)? 0:counter_q+1;
							2: counter_d=(counter_q==15)? 0:counter_q+1;
							3: counter_d=(counter_q==15)? 0:counter_q+1;		
						endcase
					end
				3: begin
						if(tick4)
						case(size_q)
							0: counter_d=(counter_q==39)? 0:counter_q+1;
							1: counter_d=(counter_q==19)? 0:counter_q+1;
							2: counter_d=(counter_q==15)? 0:counter_q+1;
							3: counter_d=(counter_q==15)? 0:counter_q+1;		
						endcase
					end
			endcase
		end
	 end
	 
	
	 //logic for rotating banner size
	 always @* begin
		text_on=0;
		row_addr=0;
		column_addr=0;
		ascii_addr=0;
		array_addr=0;
		
		if(size_q==0) begin //16x32 size
			text_on= pixel_y[8:5]==7;
			row_addr= pixel_y[4:1];
			column_addr= pixel_x[3:1];
			
			array_addr=pixel_x[9:4]+counter_q; //index for array1 moves due to rotation thus changing the starting point
			if(array_addr>39) array_addr=array_addr-39-1;	//logic for rotation	
			ascii_addr=array1[array_addr]; 			
		end
		
		else if(size_q==1) begin //32x64 size
			text_on= pixel_y[8:6]==3;
			row_addr= pixel_y[5:2];
			column_addr= pixel_x[4:2];
			
			array_addr=pixel_x[9:5]+counter_q; //index for array2 moves due to rotation thus changing the starting point
			if(array_addr>19) array_addr=array_addr-19-1;	//logic for rotation	
			ascii_addr=array2[array_addr];
		end
		
		else if(size_q==2) begin //64x138
			text_on= pixel_y[8:7]==1;
			row_addr= pixel_y[6:3];
			column_addr= pixel_x[5:3];

			array_addr=pixel_x[9:6]+counter_q; //index for array3 moves due to rotation thus changing the starting point
			if(array_addr>15) array_addr=array_addr-15-1;	//logic for rotation	
			ascii_addr=array3[array_addr];			
		end
		
		else if(size_q==3) begin //128x256
			text_on= pixel_y[8]==0;
			row_addr= pixel_y[7:4];
			column_addr= pixel_x[6:4];

			array_addr=pixel_x[9:7]+counter_q; //index for array3 moves due rotation thus changing the starting point
			if(array_addr>15) array_addr=array_addr-15-1;	//logic for rotation	
			ascii_addr=array3[array_addr];
		end
	 end

	   
	 //rgb multiplexing circuit
	 always @* begin
		rgb=0;
		if(!video_on) rgb=0;
		else begin
			if(text_on) rgb=font_bit? 3'b111:0; //text color
			else rgb=0; //background color
		end
	 end
	 
	 
	 assign font_bit=font_data[~(column_addr-1)];
	 
	 
	 debounce_explicit m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(!key[0]),
		.db_level(),
		.db_tick(key0_tick) //increase size
    );
	 
	 debounce_explicit m1
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(!key[1]),
		.db_level(),
		.db_tick(key1_tick) //decrease size
    );
	 
	 debounce_explicit m2
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(!key[2]),
		.db_level(),
		.db_tick(key2_tick) //increase speed
    );
	 
	 debounce_explicit m3
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(!key[3]),
		.db_level(),
		.db_tick(key3_tick) //decrease speed
    );
	 
	 font_rom m4
   (
    .clk(clk),
    .addr({ascii_addr,row_addr}), //[10:4] for ASCII char code, [3:0] for choosing what row to read on a given character code  
    .data(font_data)
   );
	 
endmodule

