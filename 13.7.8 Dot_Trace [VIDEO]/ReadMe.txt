Created by: Angelo Jacobo 
Date: June 20,2021

Inside the src folder are:
top_bitmap_gen.v -> Combines the vga_core and bitmap_gen modules.
				key[3] to change ball location(randomly)
				key[2:0] to change trace color
bitmap_gen.v -> A RAM is recording the traces of a bouncing ball inside a 256x256 box and pass it to VGA.
vga_core.v -> VGA controller for a 640x480 @60Hz resolution.
dcm_25MHz.xco -> 25MHz Clock used for the 640x480 @60Hz resolution.
top_bitmap_gen.ucf -> Constraint file for top_bitmap_gen.v

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.
Note: Since my board don't have an SRAM. I used instead a single-port block RAM as a replacement for the SRAM.


TASKS:
13.7.8 Full-screen dot trace 
We can implement the full-screen dot trace circuit of Section 13.5 using the external SRAM 
chip as follows: 

1. Modify the SRAM controller in Chapter 1 1 to configure the SRAM chip 
2. Follow the discussion in Section 13.5.2 to incorporate the new memory module in 
the circuit. Note that accessing the external memory requires two clock cycles. 
3. Synthesize and verify operation of the circuit. 

