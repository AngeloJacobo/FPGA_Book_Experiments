Created by: Angelo Jacobo  
Date: April 23,2021  

# Inside the src folder are:  
* rotating_LED.v -> Shifts the banner of numbers continuously. The limit is 10 numbers(default is from 0 to 9)   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of "g" or "G" for go  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of "p" or "P" for pause  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of "d" or "D" to reverse the rotation  
* rotating_LED_TEST.v -> Combines the rotating_LED, uart, and LED-mux.  
* uart.v -> UART circuit  
* LED_mux.v -> Time-multiplexing module for the seven-segments  
* rotating_LED_TEST.ucf -> Constraint file for ehn_stopwatch_TEST.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.



# TASKS:
**8.7.5 UART-controlled rotating LED banner**

Consider the rotating LED banner circuit in Experiment 4.7.5. With the UART, we can  
use a PC's HyperTerminal to control its operation and dynamically modify the digits in the  
banner:  
* When a g or G (for "go") ASCII code is received, the LED banner rotates.  
* When a p or P (for "pause") ASCII code is received, the LED banner pauses.  
* When a d or D (for "direction") ASCII code is received, the LED banner reverses the  
	direction of rotation.  

When a decimal-digit (i.e., 0, 1, . . . , 9) ASCII code is received, the banner will be  
modified. The banner can be treated as a 10-word FIFO buffer. The new digit will be  
inserted at the beginning (i.e., the leftmost position) of the banner and the rightmost  
digit will be shifted out and discarded  

All other codes will be ignored.  
Design the new rotating LED banner, synthesize the circuit, connect it to a PC, and use  
HyperTerminal to verify its operation.  
