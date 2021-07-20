Created by: Angelo Jacobo  
Date: June 13,2021  

# Inside the src folder are:
* sine_func.v -> Uses synchronous ram(block ram) to store values of sine. Has 10-bit input resolution and 8-bit output resolution.  
* sine_func_TB.v -> See "sine_wave_output.png" for the result of this testbench.  
  
Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.  

# Output:
![sine_wave_output](https://user-images.githubusercontent.com/87559347/126264133-d54a55d9-9d77-47d3-a954-e55bfb0dd4ec.png)

# TASK:  
**12.6.4 ROM-based sin(x) function**

One way to implement a sinusoidal function, sin(x), is to use a look-up table. Assume   
that the desired implementation requires 10-bit input resolution [ there are 1024 (2^10)   
points between the input range of 0 and 2pi and 8-bit output resolution [i.e., there are 256   
(2^8) points between the output range of -1 and +I].   

Because of the symmetry of the sin function, we only need to construct a 28-by-7 table   
for the first quadrant (i.e., between 0 and pi/2) and use simple pre- and postprocessing circuits   
to obtain the values in other quadrants. Design this circuit as follows:   

1. Write a program in a conventional programming language to generate a case statement 
that incorporates the 2^8-by-7 look-up table for the first quadrant. 

2. Follow the ROM template in Listing 12.6 to derive the HDL code for the look-up 
table. 

3. Derive a testbench to generate the sinusoidal output for three complete periods. This 
can be done by using a 10-bit counter to generate the 10-bit ROM address for 3 * 2^10
clock cycles. In ModelSim, we can display the y signal in Analog format to emulate 
the effect of a digital-to-analog converter. 
