Created by: Angelo Jacobo 
Date: Feb 20,2021

Inside the src folder are:
fp_to_int.v -> 13-bit floating point to 8-bit signed-magnitude integer CONVERTER
fp_to_int_TB.v -> See "fp_to_int_TB_RESULT.txt" for the result of this testbench
int_to_fp.v -> 8-bit signed-magnitude integer to 13-bit floating point CONVERTER
int_to_fp_TB.v -> See "fp_to_int_TB_RESULT.txt" for the result of this testbench

Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.

TASK:
3.1 1.5 Floating-point and signed integer conversion circuit

A number may need to be converted to different formats in a large system. Assume that
we use the 13-bit format in Section 3.9.4 for the floating-point representation and the
8-bit signed data type for the integer representation. An integer-to-floating-point conversion
circuit converts an 8-bit integer input to a normalized, 13-bit floating-point output.
A floating-point-to-integer conversion circuit reverses the operation. Since the range of
a floating-point number is much larger, conversion may lead to the underflow condition
(i.e., the magnitude of the converted number is smaller than "00000001 ") or the overflow
condition (i.e., the magnitude of the converted number is larger than "01 1 11 11 1 ").

1. Design an integer-to-floating-point conversion circuit and derive the code.
2. Derive a testbench and use simulation to verify operation of the code.
3. Design a testing circuit and derive the code.
4. Synthesize the circuit, program the FPGA, and verify its operation.
5. Design a floating-point-to-integer conversion circuit. In addition to the 8-bit integer
output, the design should include two status signals, uf and of, for the underflow
and overflow conditions. Derive the code and repeat steps 2 to 4. 

