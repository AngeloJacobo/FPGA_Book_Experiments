Created by: Angelo Jacobo  
Date: April 28,2021  

[![](https://user-images.githubusercontent.com/87559347/126129366-ceb1841c-ab8a-4c91-8268-1d18c06f510e.png)]( https://youtu.be/kn6DTLnBa1w)

# Inside the src folder are:  
* kb_banner.v -> Combines the rotating_LED(from experiment 4.7.5) and LED-mux modules.  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of "g" for go  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of "p" for pause  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of "d"  to reverse direction of rotation  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of a digit will insert the digit itself to the current banner of numbers  
* rotating_LED.v -> Shifts the banner of numbers continuously. The limit is 10 numbers(default is from 0 to 9)  
* LED_mux.v -> Time-multiplexing module for the seven-segments  
* kb_banner.ucf -> Constraint file for kb_banner.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  



# TASK:  
**9.6.5 Keyboard-controlled rotating LED banner**  

Consider the rotating LED banner circuit in Experiment 4.7.5. We can use a keyboard to  
control its operation and dynamically modify the digits in the banner:  

* When the G (for "go") key is pressed, the LED banner rotates.
* When the P (for "pause") key is pressed, the LED banner pauses. 
* When the D (for "direction") key is pressed, the LED banner reverses the direction
	of rotation.
* When a decimal digit (i.e., 0, 1, . . . , 9) key is pressed, the banner will be modified.
The banner can be treated as a 10-word FIFO buffer. The new digit will be inserted at
the beginning (i.e., the leftmost position) of the banner, and the rightmost digit will
be shifted out and discarded.  

All other keys will be ignored.  
Design the new rotating LED banner, synthesize the circuit, and verify its operation. 
