Created by: Angelo Jacobo   
Date: July 3,2021  

# Inside the src folder are:  
* breakout_top.v -> Combines the vga_core, pong_animated, and pong_text modules. A classic pong game  
		     &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;but with breakable "bricks" rather than a fix wall.  
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[1:0] for moving the paddle  
* pong_animated.v -> Control module for any graphs/symbols that will be displayed on the game.  
* pong_text.v -> Control module for any texts that will be displayed on the game.  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution  
* pong_top.ucf -> Constraint file for pong_top.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  

# TASK:
**14.6.9 Complete breakout game** 

The free-running breakout game is described in Experiment 13.7.7. Follow the procedure   
of the pong game in Section 14.4 to derive the complete system. This should include the    
design of a new text display subsystem and the design of a top-level FSM controller. Derive   
the HDL description and then synthesize and verify operation of the circuit  
