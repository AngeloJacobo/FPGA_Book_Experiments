`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:28:25 06/13/2021 
// Design Name: 
// Module Name:    sine_func 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sine_func( 
	input clk,rst_n,
	input[9:0] x, //input has a 10-bit resolution(from 0 to 2pi)
	output[7:0] y //output has 8-bit resolution(from -1 to 1)
    );
	 
	reg[7:0] y_q=0,y_d;
	reg[7:0] x_addr; //determines the address to be inserted in ROM
	wire[6:0] dout;
	
	always  @(posedge clk,negedge rst_n) begin
		if(!rst_n) y_q<=0;
		else y_q<=y_d;
	end
	
	//logic to obtain values of other quadrants
	always @* begin
		y_d=dout;
		case(x[9:8])
			2'b00: begin	
						x_addr=x[7:0]; //first quadrant(0 to pi/2) 
						y_d=dout+2**7; // middle point of sine wave is at 2^7
					end
			2'b01: begin
						x_addr=255-x[7:0]; //second quadrant(pi/2 to pi)
						y_d=dout+2**7;
					 end
			2'b10: begin  //third quadrant(pi to 3pi/2)
						x_addr=x[7:0];
						y_d=2**7-dout; //negative sign
					 end
			2'b11: begin  //fourth quadrant(3pi/2 to 2pi)
						x_addr=255-x[7:0];
						y_d=2**7-dout; //negative sign
					 end
		endcase

	end
	
	assign y=y_q;

	 rom_syn m0
	(
		.clk(clk),
		.addr(x_addr),  
		.dout(dout)
	);


endmodule

module rom_syn //synchronous rom(uses block ram) to store sine values
	(
			input clk,
			input[7:0] addr,
			output reg[6:0] dout
	);
	reg[7:0] addr_q;
	always @(posedge clk) begin
		addr_q<=addr;
	end
	always @* begin
		dout=7'd0;
		case(addr_q) //data is from sine(0) to sine(pi/2) only
				0	:  dout=7'd	0	;
				1	:  dout=7'd	1	;
				2	:  dout=7'd	2	;
				3	:  dout=7'd	2	;
				4	:  dout=7'd	3	;
				5	:  dout=7'd	4	;
				6	:  dout=7'd	5	;
				7	:  dout=7'd	5	;
				8	:  dout=7'd	6	;
				9	:  dout=7'd	7	;
				10	:  dout=7'd	8	;
				11	:  dout=7'd	9	;
				12	:  dout=7'd	9	;
				13	:  dout=7'd	10	;
				14	:  dout=7'd	11	;
				15	:  dout=7'd	12	;
				16	:  dout=7'd	12	;
				17	:  dout=7'd	13	;
				18	:  dout=7'd	14	;
				19	:  dout=7'd	15	;
				20	:  dout=7'd	16	;
				21	:  dout=7'd	16	;
				22	:  dout=7'd	17	;
				23	:  dout=7'd	18	;
				24	:  dout=7'd	19	;
				25	:  dout=7'd	19	;
				26	:  dout=7'd	20	;
				27	:  dout=7'd	21	;
				28	:  dout=7'd	22	;
				29	:  dout=7'd	23	;
				30	:  dout=7'd	23	;
				31	:  dout=7'd	24	;
				32	:  dout=7'd	25	;
				33	:  dout=7'd	26	;
				34	:  dout=7'd	26	;
				35	:  dout=7'd	27	;
				36	:  dout=7'd	28	;
				37	:  dout=7'd	29	;
				38	:  dout=7'd	29	;
				39	:  dout=7'd	30	;
				40	:  dout=7'd	31	;
				41	:  dout=7'd	32	;
				42	:  dout=7'd	32	;
				43	:  dout=7'd	33	;
				44	:  dout=7'd	34	;
				45	:  dout=7'd	35	;
				46	:  dout=7'd	35	;
				47	:  dout=7'd	36	;
				48	:  dout=7'd	37	;
				49	:  dout=7'd	38	;
				50	:  dout=7'd	38	;
				51	:  dout=7'd	39	;
				52	:  dout=7'd	40	;
				53	:  dout=7'd	41	;
				54	:  dout=7'd	41	;
				55	:  dout=7'd	42	;
				56	:  dout=7'd	43	;
				57	:  dout=7'd	44	;
				58	:  dout=7'd	44	;
				59	:  dout=7'd	45	;
				60	:  dout=7'd	46	;
				61	:  dout=7'd	46	;
				62	:  dout=7'd	47	;
				63	:  dout=7'd	48	;
				64	:  dout=7'd	49	;
				65	:  dout=7'd	49	;
				66	:  dout=7'd	50	;
				67	:  dout=7'd	51	;
				68	:  dout=7'd	52	;
				69	:  dout=7'd	52	;
				70	:  dout=7'd	53	;
				71	:  dout=7'd	54	;
				72	:  dout=7'd	54	;
				73	:  dout=7'd	55	;
				74	:  dout=7'd	56	;
				75	:  dout=7'd	56	;
				76	:  dout=7'd	57	;
				77	:  dout=7'd	58	;
				78	:  dout=7'd	59	;
				79	:  dout=7'd	59	;
				80	:  dout=7'd	60	;
				81	:  dout=7'd	61	;
				82	:  dout=7'd	61	;
				83	:  dout=7'd	62	;
				84	:  dout=7'd	63	;
				85	:  dout=7'd	63	;
				86	:  dout=7'd	64	;
				87	:  dout=7'd	65	;
				88	:  dout=7'd	65	;
				89	:  dout=7'd	66	;
				90	:  dout=7'd	67	;
				91	:  dout=7'd	67	;
				92	:  dout=7'd	68	;
				93	:  dout=7'd	69	;
				94	:  dout=7'd	69	;
				95	:  dout=7'd	70	;
				96	:  dout=7'd	71	;
				97	:  dout=7'd	71	;
				98	:  dout=7'd	72	;
				99	:  dout=7'd	73	;
				100	:  dout=7'd	73	;
				101	:  dout=7'd	74	;
				102	:  dout=7'd	74	;
				103	:  dout=7'd	75	;
				104	:  dout=7'd	76	;
				105	:  dout=7'd	76	;
				106	:  dout=7'd	77	;
				107	:  dout=7'd	78	;
				108	:  dout=7'd	78	;
				109	:  dout=7'd	79	;
				110	:  dout=7'd	79	;
				111	:  dout=7'd	80	;
				112	:  dout=7'd	81	;
				113	:  dout=7'd	81	;
				114	:  dout=7'd	82	;
				115	:  dout=7'd	82	;
				116	:  dout=7'd	83	;
				117	:  dout=7'd	84	;
				118	:  dout=7'd	84	;
				119	:  dout=7'd	85	;
				120	:  dout=7'd	85	;
				121	:  dout=7'd	86	;
				122	:  dout=7'd	87	;
				123	:  dout=7'd	87	;
				124	:  dout=7'd	88	;
				125	:  dout=7'd	88	;
				126	:  dout=7'd	89	;
				127	:  dout=7'd	89	;
				128	:  dout=7'd	90	;
				129	:  dout=7'd	90	;
				130	:  dout=7'd	91	;
				131	:  dout=7'd	92	;
				132	:  dout=7'd	92	;
				133	:  dout=7'd	93	;
				134	:  dout=7'd	93	;
				135	:  dout=7'd	94	;
				136	:  dout=7'd	94	;
				137	:  dout=7'd	95	;
				138	:  dout=7'd	95	;
				139	:  dout=7'd	96	;
				140	:  dout=7'd	96	;
				141	:  dout=7'd	97	;
				142	:  dout=7'd	97	;
				143	:  dout=7'd	98	;
				144	:  dout=7'd	98	;
				145	:  dout=7'd	99	;
				146	:  dout=7'd	99	;
				147	:  dout=7'd	100	;
				148	:  dout=7'd	100	;
				149	:  dout=7'd	101	;
				150	:  dout=7'd	101	;
				151	:  dout=7'd	102	;
				152	:  dout=7'd	102	;
				153	:  dout=7'd	103	;
				154	:  dout=7'd	103	;
				155	:  dout=7'd	103	;
				156	:  dout=7'd	104	;
				157	:  dout=7'd	104	;
				158	:  dout=7'd	105	;
				159	:  dout=7'd	105	;
				160	:  dout=7'd	106	;
				161	:  dout=7'd	106	;
				162	:  dout=7'd	107	;
				163	:  dout=7'd	107	;
				164	:  dout=7'd	107	;
				165	:  dout=7'd	108	;
				166	:  dout=7'd	108	;
				167	:  dout=7'd	109	;
				168	:  dout=7'd	109	;
				169	:  dout=7'd	109	;
				170	:  dout=7'd	110	;
				171	:  dout=7'd	110	;
				172	:  dout=7'd	111	;
				173	:  dout=7'd	111	;
				174	:  dout=7'd	111	;
				175	:  dout=7'd	112	;
				176	:  dout=7'd	112	;
				177	:  dout=7'd	112	;
				178	:  dout=7'd	113	;
				179	:  dout=7'd	113	;
				180	:  dout=7'd	114	;
				181	:  dout=7'd	114	;
				182	:  dout=7'd	114	;
				183	:  dout=7'd	115	;
				184	:  dout=7'd	115	;
				185	:  dout=7'd	115	;
				186	:  dout=7'd	116	;
				187	:  dout=7'd	116	;
				188	:  dout=7'd	116	;
				189	:  dout=7'd	116	;
				190	:  dout=7'd	117	;
				191	:  dout=7'd	117	;
				192	:  dout=7'd	117	;
				193	:  dout=7'd	118	;
				194	:  dout=7'd	118	;
				195	:  dout=7'd	118	;
				196	:  dout=7'd	119	;
				197	:  dout=7'd	119	;
				198	:  dout=7'd	119	;
				199	:  dout=7'd	119	;
				200	:  dout=7'd	120	;
				201	:  dout=7'd	120	;
				202	:  dout=7'd	120	;
				203	:  dout=7'd	120	;
				204	:  dout=7'd	121	;
				205	:  dout=7'd	121	;
				206	:  dout=7'd	121	;
				207	:  dout=7'd	121	;
				208	:  dout=7'd	122	;
				209	:  dout=7'd	122	;
				210	:  dout=7'd	122	;
				211	:  dout=7'd	122	;
				212	:  dout=7'd	122	;
				213	:  dout=7'd	123	;
				214	:  dout=7'd	123	;
				215	:  dout=7'd	123	;
				216	:  dout=7'd	123	;
				217	:  dout=7'd	123	;
				218	:  dout=7'd	124	;
				219	:  dout=7'd	124	;
				220	:  dout=7'd	124	;
				221	:  dout=7'd	124	;
				222	:  dout=7'd	124	;
				223	:  dout=7'd	124	;
				224	:  dout=7'd	125	;
				225	:  dout=7'd	125	;
				226	:  dout=7'd	125	;
				227	:  dout=7'd	125	;
				228	:  dout=7'd	125	;
				229	:  dout=7'd	125	;
				230	:  dout=7'd	125	;
				231	:  dout=7'd	126	;
				232	:  dout=7'd	126	;
				233	:  dout=7'd	126	;
				234	:  dout=7'd	126	;
				235	:  dout=7'd	126	;
				236	:  dout=7'd	126	;
				237	:  dout=7'd	126	;
				238	:  dout=7'd	126	;
				239	:  dout=7'd	126	;
				240	:  dout=7'd	126	;
				241	:  dout=7'd	126	;
				242	:  dout=7'd	127	;
				243	:  dout=7'd	127	;
				244	:  dout=7'd	127	;
				245	:  dout=7'd	127	;
				246	:  dout=7'd	127	;
				247	:  dout=7'd	127	;
				248	:  dout=7'd	127	;
				249	:  dout=7'd	127	;
				250	:  dout=7'd	127	;
				251	:  dout=7'd	127	;
				252	:  dout=7'd	127	;
				253	:  dout=7'd	127	;
				254	:  dout=7'd	127	;
				255	:  dout=7'd	127	;
		endcase
	end
endmodule
	
	
	
	
	
	
