Created by: Angelo Jacobo   
Date: June 20,2021  
  
[![image](https://user-images.githubusercontent.com/87559347/126278436-cc77fe94-916d-4412-809a-82e6cbe3ef93.png)](https://youtu.be/O0mYg6A7lDU)

# Inside the src folder are:  
* top_module.v -> Combines the vga_core, pong_animated, and uart modules.    
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;player 1 paddle controller: keyboard "w" for up, "s" for down  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;player 2 paddle controller: key[0] for up, key[1] for down  
* pong_animated.v -> Pong game with 2 players. Player 1 uses FPGA board switch. Player 2 uses keyboard via UART  
* uart.v -> UART module for serial communication between FPGA and pc keyboard.  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution  
* top_module.ucf -> Constraint file for top_module.v   

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  

# TASK:  
**13.7.6 Two-player pong game**   

The two-player pong game replaces the left wall with another paddle, which is controlled by   
the second player. To better accommodate two players, we can use the keyboard as the input device.   
Derive the HDL code and then synthesize and verify operation of the circuit.  
