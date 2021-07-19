Created by: Angelo Jacobo 
Date: April 28,2021  

# Inside the src folder are:  
* kb_interface.v -> Combines the Enhanced_Stopwatch(from experiment 4.7.6), kb, and LED-mux modules.  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of "c" for clear  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of "g" for go  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of "p" for pause 
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Input of "u"  to reverse counting  
* Enhanced_Stopwatch.v -> Stopwatch with enable/stop and can count up/down.  
* kb.v -> stores bytes of data retrieved from keyboard   
* LED_mux.v -> Time-multiplexing module for the seven-segments   
* kb_interface.ucf -> Constraint file for kb_interface.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  



# TASK:
**9.6.4 Keyboard-controlled stopwatch**

Consider the enhanced stopwatch in Experiment 4.7.6. Operation of the stopwatch is  
controlled by three switches on the prototyping board. We can use the keyboard to send  
commands to the stopwatch:  

* When the C (for "clear") key is pressed, the stopwatch aborts the current counting, is
cleared to zero, and sets the counting direction to "up."
* When the G (for "go") key is pressed, the stopwatch starts to count.
* When the P (for "pause") key is pressed, the counting pauses.
* When the U (for "up-down") key is pressed, the stopwatch reverses the direction of
	counting.
	
All other keys will be ignored.
Design the new stopwatch, synthesize the circuit, and verify its operation. 
