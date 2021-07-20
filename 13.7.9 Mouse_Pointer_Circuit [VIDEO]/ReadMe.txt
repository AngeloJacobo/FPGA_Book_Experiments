Created by: Angelo Jacobo 
Date: June 20,2021

Inside the src folder are:
vga_mouse.v -> Combines the vga_core and mouse modules. A 16x16 box acts as the mouse pointer and follows
			the mouse movement. Left/right click changes the color of the mouse pointer.
mouse.v -> ps/2 mouse module
vga_core.v -> VGA controller for a 640x480 @60Hz resolution.
dcm_25MHz.xco -> 25MHz Clock used for the 640x480 @60Hz resolution.
vga_mouse.ucf -> Constraint file for vga_mouse.v

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.


TASKS:
13.7.9 Mouse pointer circuit 

The mouse interface is discussed in Section 10.5. The mouse pointer circuit uses a mouse 
to control the movement of a small 16-by- 16 square on the screen. It functions as follows: 
> The square moves according to the movement of the mouse. 
> The pointer wraps around when it reaches a border. 
> The pointer changes color when the left button of the mouse is pressed. It circulates 
	through the eight colors defined in Table 13.1. 
Synthesize and verify operation of the circuit.

