Created by: Angelo Jacobo     
Date: March 21,2021    

# Inside the src folder are:  
* babbage_diff.v -> Uses concept of babbage difference engine to evaluate functions(heavy in multiplication) using only recursive addition operation.   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Change f0, g1, h2, and c for your desired 3rd order polynomial function.  
* babbage_diff_TB.v -> See babbage_diff_TB_RESULT.txt for the simulation result.  
* babbage_diff_TEST.v -> Combines the babbage_diff, bin2bcd, debounce_explicit, and LED_mux modules. "sw0" increments value of input to the function.  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;"sw1" switches display from the value of input to the value of the function output.  
* debounce_explicit.v -> debounce module for "sw0" and "sw1"  
* bin2bcd.v -> converts binary output from babbage engine to bcd format, to be used as input to LED_mux  
* LED_mux.v -> time multiplexing module for  the seven-segment LEDs.   
* babbage_diff_TEST.ucf -> Constraint file for main_controller.v  


Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.



# TASK:
**6.5.7 Babbage difference engine emulation circuit**

The Babbage difference engine is a mechanical digital computation device designed to  
tabulate a polynomial function. It was proposed by Charles Babbage, an English mathematician,  
in the nineteenth century. The engine is based on Newton's method of differences  
and avoids the need for multiplication.   

Design this circuit using the RT methodology:  

1. Derive the ASMD chart.

2. Derive the HDL code based on the ASMD chart.

3. Derive a testbench and use simulation to verify operation of the code.

4. Synthesize the circuit, program the FPGA, and verify its operation.

5. Let h(n) = n3 + 2n2 + 2n + 1. Use the method above to find the recursive representation of h(n) (note that three levels of recursive equations are needed for a
three-order polynomial). Repeat steps 1 to 4



**Equations used here:**
* f(x) = x^3 +2x^2 + 2x +1 
	
* f(x) = -> 1   		x=0		f0=1  
     = -> f(x-1)+g(x)   x>0

* g(x) = -> 5   		x=1		g1=5  
     = -> g(x-1)+h(x)  	x>1  

* h(x) = -> 10 		x=2		h2=10  
     = -> h(x-1)+6 	x>2		c=6





