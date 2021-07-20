Created by: Angelo Jacobo     
Date: July 2,2021  

[![image](https://user-images.githubusercontent.com/87559347/126297274-5b054028-bd84-47dc-8d8f-e11e90c026ab.png)](https://youtu.be/Rzg7Fj_cMj0)

# Inside the src folder are:  
* pong_top.v -> Combines the vga_core, pong_animated, and pong_text modules.A classic 2-player pong game.     
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[1:0] for player 1,  
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[3:2] for player 2  
* pong_animated.v -> Control module for any graphs/symbols that will be displayed on the game.  
* pong_text.v -> Control module for any texts that will be displayed on the game.  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution  
* pong_top.ucf -> Constraint file for pong_top.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.

# TASK:  
**14.6.8 Complete two-player pong game** 

The free-running two-player pong game is described in Experiment 13.7.6. Follow the   
procedure of the pong game in Section 14.4 to derive the complete system. This should   
include the design of a new text display subsystem and the design of a top-level FSM  
controller. Derive the HDL description and then synthesize and verify operation of the   
circuit.  
