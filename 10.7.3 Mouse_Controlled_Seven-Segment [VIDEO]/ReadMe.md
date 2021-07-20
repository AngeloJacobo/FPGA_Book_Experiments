Created by: Angelo Jacobo   
Date: May 11,2021   

[![](https://user-images.githubusercontent.com/87559347/126260369-1446bcaa-06fd-40a3-af96-72adf5cdd7f8.png )](https://youtu.be/Kh9UoJ0pERw )

# Inside the src folder are:    
* mouse_test.v -> Uses the mouse module to make the seven-segments move (only 1 seven-segment is lit) based on the x-axis movement.  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Displayed on the lit seven-segment is a counter that increments/decrements based on the movement of the y-axis	  	  	
* mouse.v -> Module for ps/2 mouse interfacing.  
* LED_mux.v -> Seven-segment LED time-multiplexing module    
* mouse_test.ucf -> Constraint file for mouse_test.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.   



# TASK:
**10.7.3 Mouse-controlled seven-segment LED display**

We can use the mouse to enter four decimal digits on the four-digit seven-segment LED  
display. The circuit functions as follows:   
* Only one of the four decimal points of the LED display is lit. The lit decimal point
indicates the location of the selected digit.
* The location of the selected digit follows the x-axis movement of the mouse.
* The content of the select seven-segment LED display is a decimal digit (i.e., 0, . . . ,9)
and changes with the y-axis movement of the mouse.

Design and synthesize this circuit and verify its operation. 
