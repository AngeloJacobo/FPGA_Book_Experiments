Created by: Angelo Jacobo  
Date: March 27,2021  

# Inside the src folder are:  
dual_comparator.v -> mode=1 converts the inputs(a & b) to signed while mode=0 converts the inputs to unsigned."agbt" is asserted if a is greater than b  
fibo_TB.v -> See the waveform of this testbench.  

Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.  


# TASK:  
**7.7.5 Dual-mode comparator**  

A dual-mode comparator takes the two 8-bit data inputs, a and b, as unsigned or signed  
integers. A control signal, mode, indicates the desired mode. The circuit has one output,  
agtb, which is asserted when the interpreted value of a is greater than the interpreted value  
of b.  

1. Assume that the signed data type is allowed. Design the circuit and derive the code.

2. Synthesize the circuit and verify its operation.

3. Assume that the signed data type is not allowed in the code. Repeat steps 1 and 2. 
