Created by: Angelo Jacobo   
Date: May 10,2021  

# Inside the src folder are:   
* mouse_test.v -> Uses the mouse module to make the leds move based on the x-axis movement of the ps2 mouse  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Press key0 to transmit the code for enabling stream mode of the mouse  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
Press key1 to reset and disable the stream mode of he mouse  
* mouse.v -> Module for ps/2 mouse interfacing.  
* mouse_test.ucf -> Constraint file for mouse_test.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  



# TASK:
**10.7.2 Enhanced mouse interface**

For the mouse interface discussed in Section 10.5, we can alter the design to manually  
enable or disable the steam mode. This can be done by using two pushbuttons of the FPGA  
prototyping board. One button issues the reset command, FF, which disables the stream  
mode during operation, and the other button issues the F4 command to enable the steam  
mode. Modify the original interface to incorporate this feature, and resynthesize the LED  
testing circuit to verify its operation.   
