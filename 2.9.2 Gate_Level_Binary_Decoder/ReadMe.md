Created by: Angelo Jacobo   
Date: Feb 10,2021  

# Inside the src folder are:  
binary_decoder_2x4.v -> 2-to-4 Binary decoder. The sum-of-products from the table is used as the overall logic.  
binary_decoder_3x8.v -> Uses two binary_decoder_2x4 modules to make a 3-to-8 decoder.  
binary_decoder_4x16.v -> Uses 4 binary_decoder_2x4 modules to make a 4-to-16 decoder.  
binary_decoder_2x4_TB.v -> See "binary_decoder_2x4_TB_RESULT.txt" for the result of this testbench.  
binary_decoder_3x8_TB.v -> See "binary_decoder_3x8_TB_RESULT.txt" for the result of this testbench.  
binary_decoder_4x16_TB.v -> See "binary_decoder_4x16_TB_RESULT.txt" for the result of this testbench.  


Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.  

![table](https://user-images.githubusercontent.com/87559347/126032436-7b580a1f-94b9-4785-a509-1e64ed4bf14a.png)

![3x8_diagram](https://user-images.githubusercontent.com/87559347/126032440-4a9d95c4-efdd-4e94-ac33-6cd2d47f5241.png)

![4x16_diagram](https://user-images.githubusercontent.com/87559347/126032441-6df45faf-b6a6-4a35-aab2-2ab480fea0a6.png)


# TASK:
**2.9.2 Gate-level binary decoder** 

An n-to-2^n binary decoder asserts one of 2^n bits according to the input combination. The 
functional table of a 2-to-4 decoder with an enable signal is shown in Table 2.2. We want to 
create several decoders using only gate-level logical operators. The procedure is as follows: 

1. Determine the logic expressions for the 2-to-4 decoder with enable and derive the 
	HDL code using only logical operators. 
	
2. Derive a testbench for the decoder. Perform a simulation and verify the correctness 
	of the design. 
	
3. Use two switches as the inputs and four LEDs as the outputs. Synthesize the circuit 
	and download the configuration file to the prototyping board. Verify its operation.
	
4. Use the 2-to-4 decoders to derive a 3-to-8 decoder. First draw a block diagram and 
	then derive the structural HDL code according to the diagram. 
	
5. Derive a testbench for the 3-to-8 decoder. Perform a simulation and verify the correctness of the design. 

6.  Use three switches as the inputs and eight LEDs as the outputs. Synthesize the circuit 
	and download the configuration file to the prototyping board, Verify its operation. 
	
7. Use the 2-to-4 decoders to derive a 4-to-16 decoder. First draw a block diagram and 
	then derive the structural HDL code according to the diagram. 
	
8. Derive a testbench for the 4-to-16 decoder. Perform a simulation and verify the 
	correctness of the design. 
