Created by: Angelo Jacobo     
Date: June 20,2021    

[![image](https://user-images.githubusercontent.com/87559347/126290074-ef69b8b9-7bcf-4e2d-b4a8-21c4283bcfc1.png)](https://youtu.be/e3mvBPzMrbs)

# Inside the src folder are:  
* vga_test.v -> Uses the vga_core module to adjust the visible screen position.   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[0] is for selecting vertical or horizontal mode adjustment.  
		 	&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[2:1] is for moving the screen up/down(if vertical mode) or left/right(if horizontal mode)  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution with a variable border size(but the total sum of border/blanking
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; time is preserved).   
* vga_test.ucf -> Constraint file for top_module.v   

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.

# TASS:
**13.7.3 Visible screen adjustment circuit** 

Due to the internal timing error of a monitor, the visible portion of the screen may not   
always be centered. We can adjust the location of the visible portion by slightly modifying   
the widths surrounding black border areas. In a horizontal scan line, there are 64 pixels   
for the right and left border regions. To move the visible portion horizontally, we can add   
a certain number of pixels to one border region and subtract the same number from the   
opposite border region. We can adjust the visible portion vertically in a similar fashion.   
Design a screen adjustment circuit as follows:   

1. Expand the VGA synchronization circuit to include this feature. Use a switch to 
select the vertical or horizontal mode, and use two pushbuttons to move the visible 
screen to IeftJup and rightldown. 

2. Modify the testing circuit in Section 13.2.5 to incorporate the new synchronization 
circuit. 

3. Synthesize and verify operation of the circuit. 
