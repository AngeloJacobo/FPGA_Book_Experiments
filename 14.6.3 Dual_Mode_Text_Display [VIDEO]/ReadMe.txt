Created by: Angelo Jacobo 
Date: June 30,2021

Inside the src folder are:
dual_mode_disp.v -> Combines the vga_core, mode_vertical, mode_horizontal, and uart modules. Turn the monitor
			 by 90 degrees when at Vertical mode. Horizontal mode the default monitor display.			 
				key[0] to move cursor to right, 
				key[1] to move cursor down, 
				key[2] to write new ASCII character(from UART with 4800BaudRate) to current cursor
				key[3] to change display mode(vertical or horizontal)
mode_vertical.v -> Display is tilted by 90 degrees.
mode_horizontal.v -> Display angle is at default 0 degrees.
uart.v -> Top module for UART-controller, default at 4800BaudRate for 25MHz clock.
vga_core.v -> VGA controller for a 640x480 @60Hz resolution.
dcm_25MHz.xco -> 25MHz Clock used for the 640x480 @60Hz resolution.
dual_mode_disp.ucf -> Constraint file for dual_mode_disp.v

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.


TASK:
14.6.3 Dual-mode text display 

It is sometimes better for text to be displayed on a "vertical" screen. This can be done by 
turning the monitor 90 degrees and resting it on its side. Design this circuit as follows: 
1. Modify the full-screen text display circuit in Section 14.3 for a vertical screen. 
2. Merge the normal and vertical designs to create a "dual-mode" text display. Use a 
switch to select the desired mode. 
3. Derive the HDL description and then synthesize and verify operation of the circuit.