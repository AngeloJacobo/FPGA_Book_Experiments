Created by: Angelo Jacobo  
Date: June 13,2021  

# Inside the src folder are:
* cos_sine_func.v -> Uses dual port rom via core generator for dual access of memory storage for cosine/sine output  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Has 10-bit input resolution and 8-bit output resolution.
* cos_sine_func_TB.v -> See "sine_cos_output.png" for the result of this testbench.  

Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.  


# TASK: 
**12.6.5 ROM-based sin(x) and cos(x) functions**

In many communication modulation schemes, the sin(x) and cos(x) functions are needed  
at the same time. Assume that the format of the input and output is similar to that in      
Experiment 12.6.4.  

Although we can follow the previous procedure and create a new ROM for the cos(x)     
function, a better alternative is to share the same ROM for both sin(x) and cos(x) functions.    
This is based on the observations that cos(x) is only a phase shift of sin(x) and that the   
FPGA's block RAM can provide dual-port access.   

Note that this circuit requires essentially a "dual-port ROM." No HDL behaviorial template is  
given for this type of memory. We need to experiment with HDL codes and to check   
the synthesis report to ensure that only one block RAM is inferred. It may be necessary   
to use the Core Generator program or direct HDL component instantiation to achieve this   
goal.  

Construct this special ROM and derive the HDL code for the pre- and postprocessing   
circuits. Use a testbench similar to that in Experiment 12.6.4 to verify the circuit's operation.
