Created by: Angelo Jacobo  
Date: Feb 15,2021  

# Inside the src folder are:  
Rotate_8.v -> 8-bit Rotator(left or right)   
Rotate_16.v -> 16-bit Rotator(left or right)  
Rotate_32.v -> 32-bit Rotator(left or right)  
Multi_Barrel_Shifter8x16x32x.v -> Combined the 8, 16,and 32 bit rotators. Adjust the parameter to choose between the three.  
barreLshifter_TB.v -> See "barreLshifter_TB_RESULT.txt" for the result of this testbench.  

Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.  


# TASK:  
**3.11.1 Multifunction barrel shifter**

Consider an 8-bit shifting circuit that can perform rotating right or rotating left.   
An additional I-bit control signal, LR, specifies the desired direction.  

1. Design the circuit using one rotate-right circuit, one rotate-left circuit, and one 2-to-1 multiplexer to select the desired result. Derive the code.

2. Derive a testbench and use simulation to verify operation of the code

3. Expand the code for a 16-bit circuit and synthesize the code. 

4. Expand the code for a 32-bit circuit and synthesize the code.

