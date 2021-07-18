Created by: Angelo Jacobo  
Date: March 5,2021  

# Inside the src folder are:  
* sqwave_gen.v -> square wave generator that can be controlled by m and n (ON duration=m* 100ns  OFF duration=n* 100ns)  
* sqwave_gen_TB.v -> See "sqwave_gen_TB_RESULT.txt" for the result of this testbench  


Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.  


# TASK:  
**4.7.1 Programmable square-wave generator**  

A programmable square-wave generator is a circuit that can generate a square wave with  
variable on (i.e., logic 1) and off (i.e., logic 0) intervals. The durations of the intervals are  
specified by two 4-bit control signals, m and n, which are interpreted as unsigned integers.  
The on and off intervals are m* 100 ns and n* 100 ns, respectively (recall that the period of  
the S3 onboard oscillator is 20 ns). Design a programmable square-wave generator circuit.  
The circuit should be completely synchronous. We need a logic analyzer or oscilloscope  
to verify its operation.  
