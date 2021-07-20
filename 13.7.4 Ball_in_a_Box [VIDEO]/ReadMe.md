Created by: Angelo Jacobo   
Date: June 20,2021  

# Inside the src folder are:
* top_module.v -> Combines the vga_core and ball_in_a_box modules. Ball bounces inside a 256x256 box  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[1] is for changing  ball speed, key[0] for changing location of ball(randomly)  
* * ball_in_a_box.v -> Logic for self-bouncing ball. Ball bounces inside a 256x256 box.  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.  
* top_module.ucf -> Constraint file for top_module.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  

# TASK:
**13.7.4 Ball-in-a-box circuit**
 
The ball-in-a-box circuit displays a bouncing ball inside a square box. The square box   
is centered on the screen and its size is 256-by-256 pixels. The ball is an 8-by-8 round   
ball. When the ball hits the wall, the ball bounces back and the wall flashes (i.e., changes   
color briefly). The ball can travel at four different speeds, which are selected by two slide  
switches, and its direction changes randomly when a pushbutton switch is pressed. Derive   
the HDL code and then synthesize and verify operation of the circuit.  
  
