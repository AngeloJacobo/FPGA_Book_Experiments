`timescale 1ns / 1ps

module vga_core(
	input clk,rst_n, //clock must be 25MHz for 640x480 
	input[2:0] key,
	output hsync,vsync,
	output reg video_on,
	output[11:0] pixel_x,pixel_y
    );		//650x480 parameters
	 localparam HD=640, //Horizontal Display
					HRet=96, //Horizontal Retrace
					
					VD=480, //Vertical Display
					VRet=2; //Vertical Retrace

	reg[11:0] vctr_q=0,vctr_d; //counter for vertical scan
	reg[11:0] hctr_q=0,hctr_d; //counter for vertical scan
	reg hsync_q=0,hsync_d;
	reg vsync_q=0,vsync_d;
	wire key1_tick,key2_tick;
	
	reg[5:0] HR_q=16,HR_d; //horizontal right border
	reg[5:0]  HL_q=48,HL_d; //horizontal left border
	reg[5:0] VB_q=10,VB_d; //vertical bottom border
	reg[5:0] VT_q=33,VT_d; //vertical top border
	
	//vctr and hctr register operation
	always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			vctr_q<=0;
			hctr_q<=0;
			vsync_q<=0;
			hsync_q<=0;
			HR_q<=16;
			HL_q<=48;
			VB_q<=10;
			VT_q<=33;
		end
		else begin
			vctr_q<=vctr_d;
			hctr_q<=hctr_d;
			vsync_q<=vsync_d;
			hsync_q<=hsync_d;
			HR_q<=HR_d;
			HL_q<=HL_d;
			VB_q<=VB_d;
			VT_q<=VT_d;
		end
	end
	
	//horizontal and vertical counter logic for horizontal sync and vertical sync
	always @* begin
		vctr_d=vctr_q;
		hctr_d=hctr_q;
		video_on=0;
		hsync_d=1; 
		vsync_d=1; 
		HR_d=HR_q;
		HL_d=HL_q;
		VB_d=VB_q;
		VT_d=VT_q;
			
			
		//logic for movable screen
		//key_tick adjust left/right/top/bottom borders 
		
		if(key1_tick || key2_tick) begin
			if(key[0]) begin//vertical movement
				if(key1_tick) begin //MOVE UP
					VT_d=(VT_q!=0)?VT_q-1:VT_q;
					VB_d=(VT_q!=0)? VB_q+1:VB_q;
				end
				else if(key2_tick) begin //MOVE DOWN
					VT_d=(VB_q!=0)?VT_q+1:VT_q;
					VB_d=(VB_q!=0)?VB_q-1:VB_q;
				end
			end
			else begin //horizontal movement
				if(key1_tick) begin //MOVE RIGHT
					HR_d=(HR_q!=0)? HR_q-1:HR_q;
					HL_d=(HR_q!=0)? HL_q+1:HL_q;
				end
				else if(key2_tick) begin //MOVE LEFT
					HR_d=(HL_q!=0)? HR_q+1:HR_q;
					HL_d=(HL_q!=0)? HL_q-1:HL_q;
				end
			end
		end
		
		
		if(hctr_q==HD+HR_q+HRet+HL_q-1) hctr_d=0; //horizontal counter
		else hctr_d=hctr_q+1'b1;
		
		if(vctr_q==VD+VB_q+VRet+VT_q-1) vctr_d=0; //vertical counter
		else if(hctr_q==HD+HR_q+HRet+HL_q-1) vctr_d=vctr_q+1'b1;
		
		if(hctr_q<HD && vctr_q<VD) video_on=1; //video_on 
		
		if( (hctr_d>=HD+HR_q) && (hctr_d<=HD+HR_q+HRet-1) ) hsync_d=0; //horizontal sync 
		if( (vctr_d>=VD+VB_q) && (vctr_d<=VD+VB_q+VRet-1) ) vsync_d=0; //vertical sync
				
	end
		assign vsync=vsync_q;
		assign hsync=hsync_q;
		assign pixel_x=hctr_q;
		assign pixel_y=vctr_q;
		
	debounce_explicit m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(!key[1]),
		.db_level(),
		.db_tick(key1_tick)
    );
	 debounce_explicit m1
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(!key[2]),
		.db_level(),
		.db_tick(key2_tick)
    );

endmodule
