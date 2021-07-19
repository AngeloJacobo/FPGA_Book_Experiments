Created by: Angelo Jacobo   
Date: March 19,2021  

Inside the src folder are:  
* master_controller.v -> Combines period_counter, div, bin2bcd, adjust, and LED-mux modules. The frequency of the input signal is displayed on the seven-segments.
				Note: Max frequency: 1Hz (1s)
				      Min Frequency: 500KHz (2us)
* master_controller_TEST.v -> Generates signal to be used as input to master_controller module. Edit the localparam "period" for your desired output frequency.
					Output signal is also connected to the fpga board pins to be tested on the oscilloscope.
* period_counter.v -> counts the period of the signal
* div.v -> divides the period output from 1 (reciprocal the period to get frequency)
* bin2bcd.v -> converts frequency value from div to bcd format
* adjust.v -> adjust the bcd format from bcd2bin so that the first digit is NOT ZERO.
* LED_mux.v -> Time-multiplexing module for the seven-segments
* master_controller_TEST.ucf -> Constraint file for master_controller_TEST.v


# Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.



# TASK:
**6.5.5 Auto-scaled low-frequency counter**

The operation ofthe low-frequency counter in Section 6.3.5 is very restricted. The frequency  
range of the input signal is limited between 1 and 10 Hz. It loses accuracy when the  
frequency is beyond this range. Recall that the accuracy of this frequency counter depends  
on the accuracy of the period counter of Section 6.3.5, which counts in terms of millisecond  
ticks. We can modify the t counter to generate a microsecond tick (i.e., counting from 0   
to 49) and increase the accuracy 1000-fold. This allows the range of the frequency counter  
to increase to 9999 Hz and still maintain at least four-digit accuracy.  

Using a microsecond tick introduces more than four accuracy digits for low-frequency  
input, and the number must be shifted and truncated to be displayed on the seven-segment  
LED. An auto-scaled low-frequency counter performs the adjustment automatically, displays the four most significant digits,   
and places a decimal point in the proper place. For example, according to their range, the frequency measurements will be shown as " 1.234",  
" 12.34", "123.4", or "1234".  

The auto-scaled low-frequency counter needs an additional BCD adjustment circuit. It  
first checks whether the most significant BCD digit (i.e., the four MSBs) of a BCD sequence  
is zero. If this is the case, the circuit shifts the BCD sequence to the left four positions and  
increments the decimal point counter. The operation is repeated until the most significant  
BCD digit is not "0000".  

The complete auto-scaled low-frequency counter can be implemented as follows:  

1. Modify the period counter to use the microsecond tick.    

2. Extend the size of the binary-to-BCD conversion circuit.  

3. Derive the ASMD chart for the BCD adjustment circuit and the HDL code.  

4. Modify the control FSM to include the BCD adjustment in the last step.  

5. Design a simple decoding circuit that uses the decimal-point counter's output to  
activate the desired decimal point of the seven-segment LED display.

6. Derive a testbench and use simulation to verify operation of the code.  

7. Synthesize the circuit, program the FPGA, and verify its operation.   
