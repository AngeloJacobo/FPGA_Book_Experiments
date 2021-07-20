Created by: Angelo Jacobo   
Date: June 30,2021   

# Inside the src folder are:    
* keyboard_text_ps2.v -> Combines the vga_core, full_screen_gen, and kb modules. Uses ps2 keyboard    
			  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;to display ASCII characters on screen.   
			  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Use the arrow keys of the ps2 keyboard to move the cursor.	  			
* full_screen_gen.v ->  Main logic for variable cursor position with write capability at the current cursor.  
* kb.v -> Top module for ps2 keyboard  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.  
* keyboard_text_ps2.ucf -> Constraint file for dual_mode_disp.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.


# TASK:
**14.6.4 Keyboard text entry** 

Instead of switches and buttons, it is more natural to use a keyboard to enter text. We can   
use the four arrow keys to move the cursor and use the regular keys to enter the characters.   
Use the keyboard interface discussed in Section 9.4 to design the new circuit. Derive the   
HDL description and then synthesize and verify operation of the circuit.  
