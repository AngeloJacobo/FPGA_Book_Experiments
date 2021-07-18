`timescale 1ns / 1ps

module led_dimmer_PLUS_sevenseg(
 input clk,rst_n,
 input sw,
 output[7:0] seg_out,
 output[5:0] sel_out
    );
	 reg[3:0] w_counter=0; //each press of sw will increment w_counter by 1 which would then be used as the duty cycle for the pwm output(control brightness of LED 7-segment)
	 reg holder=0;
	 wire[7:0] seg_out_temp0,seg_out_temp1;
	 wire key;
	 
	 
	 //button circuit
	 debouncer m0(
	.clk(clk),
	.rst_n(rst_n),
	.pushbutton(sw),  
	.key(key)                
	); 
	 always @(posedge clk,negedge rst_n) begin
		 if(!rst_n) begin
			w_counter=0;
			holder=0;
		 end
		 else begin
				 if(key) begin
					if(!holder) begin
						w_counter=w_counter+1'b1;
						holder=1;
						end
				 end 		
				 else holder=0; 
		  end
	 end
	 
	//w_counter will control the brightness of seven-segments while displaying the value of w_counter itself
	LED_mux ledmux
	(
	.clk(clk),
	.rst(rst_n),
	.in0({1'b0,w_counter}),
	.in1(0),
	.in2(0),
	.in3(0),
	.in4(0),
	.in5(0), //format: {dp,hex[3:0]} dp is active high
	.seg_out(seg_out_temp0),  
	.sel_out(sel_out)
    );
	 
	 
	 genvar i; //makes 8 circuits
	 for(i=0;i<=7;i=i+1) begin
	 
		led_dimmer dimmer(
		.clk(clk),
		.rst_n(rst_n),
		.w(w_counter),
		.en(!seg_out_temp0[i]), //en accepts active high input only so reverse the input first
		.pwm(seg_out_temp1[i]) 
		 );
		 
		 assign seg_out[i]=!seg_out_temp1[i]; //reverse the signal since seven segment needs active inputs
		 
	 end

endmodule



module debouncer(
	input clk,rst_n,pushbutton,  //push-button is active-low
	output key                   //output is active high for easier use with other modules
	); 

	reg pushbutton_1=1'b0;       
	reg[31:0] cnt=32'd0;         //debounce timer   
	assign key=pushbutton_1;

	always @(posedge clk,negedge rst_n)
	begin
		if(!rst_n) 
			begin 
				pushbutton_1<=1'b0; 
				cnt<=32'd0;
			end
		else if(pushbutton_1!=(!pushbutton)) 
			begin 
				pushbutton_1<=(cnt==32'd500_000)?(!pushbutton_1):pushbutton_1; //pushbutton must stabilize for 500_000 cycles(10ms for 50MHz) before output changes
				cnt<=(cnt==32'd500_000)?20'd0:(cnt+1'b1);
			end
		else cnt<=32'd0;
	end

	
endmodule
	