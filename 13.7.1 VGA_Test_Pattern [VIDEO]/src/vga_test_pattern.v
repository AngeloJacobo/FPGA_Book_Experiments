`timescale 1ns / 1ps

module vga_test_pattern(
		input key,
		input video_on,
		input[11:0] pixel_x,pixel_y,
		output reg[4:0] r,
		output reg[5:0] g,
		output reg[4:0] b
    ); 
	 //640x480 resolution
	 localparam  SCREEN_LENGTH=640,
					 SCREEN_WIDTH=480,
					 LENGTH=SCREEN_LENGTH/8,
					 WIDTH=SCREEN_WIDTH/8;
					 ;
	always @* begin
		r=0;
		g=0;
		b=0;
		if(video_on) begin
			if(key) begin //vertical strip
				if(pixel_x<=LENGTH-1) r=0;  //000
				else if(pixel_x<=(2*LENGTH-1)) b=5'b111_11; //001
				else if(pixel_x<=(3*LENGTH-1)) g=6'b111_111; //010
				else if(pixel_x<=(4*LENGTH-1)) begin //011
					g=6'b111_111;
					b=5'b111_11;
				end
				else if(pixel_x<=(5*LENGTH-1)) r=5'b111_11; //100
				else if(pixel_x<=(6*LENGTH-1)) begin //101
					r=5'b111_11;
					b=5'b111_11;
				end
				else if(pixel_x<=(7*LENGTH-1)) begin //110
					r=5'b111_11;
					g=6'b111_111;
				end
				else if(pixel_x<=(8*LENGTH-1)) begin //111
					r=5'b111_11;
					g=6'b111_111;
					b=5'b111_11;
				end
			end
			
			else begin //horizontal strip
				if(pixel_y<=WIDTH-1) r=0; //000
				else if(pixel_y<=(2*WIDTH-1)) b=5'b111_11; //001
				else if(pixel_y<=(3*WIDTH-1)) g=6'b111_111; //010
				else if(pixel_y<=(4*WIDTH-1)) begin //011
					g=6'b111_111;
					b=5'b111_11;
				end
				else if(pixel_y<=(5*WIDTH-1)) r=5'b111_11; //100
				else if(pixel_y<=(6*WIDTH-1)) begin //101
					r=5'b111_11;
					b=5'b111_11;
				end
				else if(pixel_y<=(7*WIDTH-1)) begin //110
					r=5'b111_11;
					g=6'b111_111;
				end
				else if(pixel_y<=(8*WIDTH-1)) begin //111
					r=5'b111_11;
					g=6'b111_111;
					b=5'b111_11;
				end
			end
		end
	end
	

endmodule
