Created by: Angelo Jacobo   
Date: June 21,2021  

[![image](https://user-images.githubusercontent.com/87559347/126282599-d48c9eed-6355-4799-bd04-f75d9276808a.png)](https://youtu.be/1TRjZsweEBs)

# Inside the src folder are:  
* vga_mouse.v -> Combines the vga_core and mouse modules.The mouse movement is followed and leaves a "trace".  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Left click turns on/off the trace   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Right click clears the screen of all traces  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[2:0] to change trace color   
* mouse.v -> ps/2 mouse module  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.  
* vga_mouse.ucf -> Constraint file for vga_mouse.v   

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  


# TASK:  
**13.7.10 Small-screen mouse scribble circuit** 

Mouse scribble circuit keeps track of the trace of the mouse movement in a 256-by-256  
screen, somewhat similar to the dot trace circuit discussed in Section 13.5. Its specification   
is as follows:   
* The 3-bit switch determines the color of the trace. 
* Clicking the left button of the mouse turns on and off the trace alternately. 
* Clicking the right button of the mouse clears the screen. 

Synthesize and verify operation of the circuit.
