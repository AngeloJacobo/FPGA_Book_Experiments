Created by: Angelo Jacobo  
Date: Feb 10,2021  

# Inside the src folder are:  
* greater_than_2bit.v -> 2-bit greater than circuit. Uses the sum-of-product terms from the table to form the overall logic.  
* greater_than_4bit.v -> 4-bit greater than circuit. Uses the greater_than_2bit,eq2,and eq1 modules to form the overall logic  
* greater_than_2bit_TB.v -> See "greater_than_2bit_TB_RESULT.txt" for the result of this testbench  
* greater_than_4bit_TB.v -> See "greater_than_4bit_TB_RESULT.txt" for the result of this testbench  

Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.  

![table](https://user-images.githubusercontent.com/87559347/126031862-baae47bd-a907-4108-941a-54d706409810.png)  


# TASK:  
**2.9.1 Gate-level greater-than circuit**   

The greater-than circuit compares two inputs, a and b, and asserts an output when a is   
greater than b. We want to create a 4-bit greater-than circuit from the bottom up and use  
only gate-level logical operators. Design the circuit as follows: 

1. Derive the truth table for a 2-bit greater-than circuit and obtain the logic expression 
in the sum-of-products format. Based on the expression, derive the HDL code using 
only logical operators. 

2. Derive a testbench for the 2-bit greater-than circuit. Perform a simulation and verify 
the correctness of the design. 

3. Use four switches as the inputs and one LED as the output. Synthesize the circuit 
and download the configuration file to the prototyping board. Verify its operation. 

4. Use the 2-bit greater-than circuits and 2-bit equality comparators and a minimal 
number of "glue gates" to construct a 4-bit greater-than circuit. First draw a block 
diagram and then derive the structural HDL code according to the diagram. 

5. Derive a testbench for the 4-bit greater-than circuit. Perform a simulation and verify 
the correctness of the design. 

6. Use eight switches as the inputs and one LED as the output. Synthesize the circuit 
and download the configuration file to the prototyping board. Verify its operation. 

