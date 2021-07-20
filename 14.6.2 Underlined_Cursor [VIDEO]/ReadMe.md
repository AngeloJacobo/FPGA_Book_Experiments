Created by: Angelo Jacobo   
Date: June 30,2021  

[![image](https://user-images.githubusercontent.com/87559347/126286106-b12303fb-2e91-47d5-a6c8-7cf85f7e7eeb.png)](https://youtu.be/AUJCHo4bU0w)

# Inside the src folder are:
* underlined_cursor.v -> Combines the vga_core, full_screen_gen, and uart modules. An underline serves  
 				&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; as the cursor to current position.    
				&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[0] to move cursor to right,    
				&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[1] to move cursor down,   
				&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[2] to write new ASCII character(from UART with 4800BaudRate) to current cursor  
* full_screen_gen.v -> Main logic for variable cursor positon with write capability at the current cursor.  
* uart.v -> Top module for UART-controller, default at 4800BaudRate for 25MHz clock.  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.  
* underlined_cursor.ucf -> Constraint file for underlined_cursor.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.   


# TASK:
**14.6.2 Underline for the cursor** 

The full-screen text display circuit in Section 14.3 uses reversed color to indicate the current   
cursor location. Modify the design to use an underline to indicate the cursor location. Derive   
the HDL description and then synthesize and verify operation of the circuit.  
