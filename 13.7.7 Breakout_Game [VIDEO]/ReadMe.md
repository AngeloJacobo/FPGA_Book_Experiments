Created by: Angelo Jacobo   
Date: June 20,2021   

[![image](https://user-images.githubusercontent.com/87559347/126279033-b8413d40-8cf2-43fd-ad00-3da44798f077.png)](https://youtu.be/qBkZ3yawzqo)

# Inside the src folder are:    
* top_pong_animated.v -> Combines the vga_core and pong_animated modules.  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;A classic pong game but with breakable "bricks" rather than wall.  
* pong_animated.v -> Pong game logic. Walls can be broken when the ball bounces from it.  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.  
* top_pong_animated.ucf -> Constraint file for top_module.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  


# TASKS:  
**13.7.7 Breakout game**  
 
The breakout game is somewhat like the pong game. In this game, the left wall is replaced   
by several layers of "bricks." When the ball hits a brick, the ball bounces back and the brick   
disappears. The basic screen is shown in Figure 13.11. As in the code of Listing 13.5, we   
assume that the game runs continuously. Derive the HDL code and then synthesize and    
verify operation of the circuit.    
