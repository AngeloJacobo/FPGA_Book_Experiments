Created by: Angelo Jacobo
Date: June 13,2021

Inside the src folder are:
cos_sine_func.v -> Uses dual port rom via core generator for dual access of memory storage for cosine/sine output
				Has 10-bit input resolution and 8-bit output resolution.
cos_sine_func_TB.v -> See "sine_cos_output.png" for the result of this testbench.

Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.


TASK:
12.6.5 ROM-based sin(x) and cos(x) functions
