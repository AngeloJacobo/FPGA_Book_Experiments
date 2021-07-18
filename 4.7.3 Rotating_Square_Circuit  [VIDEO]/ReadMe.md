Created by: Angelo Jacobo  
Date: March 6,2021  

# Inside the src folder are:  
rotate_sq.v -> Rotating square circuit for 6 seven-segments with enable and clockwise/counterclockwise control  
rotate_sq_TB.v -> Testbench with a period of 100ns per box  
rotate_sq_TEST.v -> Module that combines the rotate_sq module and Led_mux module.   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; "en" for play/pause  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; "cw" for clockwise/counterclockwise control of the rotating boxes  
Led_mux.v -> Module for seven-segment time-multiplexing circuit.  
rotate_sq_TEST.ucf -> Constraint file for rotate_sq_TEST.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  

# TASK:
**4.7.3 Rotating square circuit**

In a seven-segment LED display, a square pattern can be created by enabling the a, b, f,  
and g segments or the c, d, e, and g segments. We want to design a circuit that circulates  
the square patterns in the four-digit seven-segment LED display. The clockwise circulating  
pattern is shown in Figure 4.12. The circuit should have an input, en, which enables or  
pauses the circulation, and an input, cw, which specifies the direction (i.e., clockwise or  
counterclockwise) of the circulation.  

Design the circuit and verify its operation on the prototyping board. Make sure that the
circulation rate is slow enough for visual inspection.   
