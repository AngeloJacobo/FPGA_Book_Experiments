Created by: Angelo Jacobo   
Date: June 20,2021  

# Inside the src folder are:
* top_module.v -> Combines the vga_core and two_balls_in_a_box modules. Ball bounces inside a 100x100 box.  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[1] is for changing  ball speed, key[0] for changing location of ball(randomly)  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;The balls follow the laws of physics when colliding.  
* two_balls_in_a_box.v -> Logic for two self-bouncing balls. The balls bounce inside a 100x100 box.  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.  
* top_module.ucf -> Constraint file for top_module.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  
Note: The box size is smaller so the chance of colliding the balls is higher.  

# TASK:
**13.7.5 Two-balls-in-a-box circuit** 

We can expand the circuit in Experiment 13.7.4 to include two balls inside the box. When   
two balls collide, the new directions of the two balls should follow the laws of physics.   
Derive the HDL code and then synthesize and verify operation of the circuit.   
