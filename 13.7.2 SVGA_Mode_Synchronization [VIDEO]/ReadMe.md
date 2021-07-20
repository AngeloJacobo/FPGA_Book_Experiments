Created by: Angelo Jacobo  
Date: June 20,2021  

# Inside the src folder are:    
* top_module.v -> Combines the vga_core_640x480 , vga_core_800x600 , grid_pixel, and 25MHz clk DCM modules.   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Alternates between VGA and SVGA mode when "key" is pressed. Generates 100x100 pixel  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;grid on screen.  
* grid_pixel.v -> Generates 100x100 grid pixel.	  
* vga_core_640x480.v -> VGA controller for a 640x480 @60Hz resolution.  
* vga_core_800x600.v -> VGA controller for a 800x600 @72Hz resolution.  
* top_module.ucf -> Constraint file for top_module.v   

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.

# TASKS:
**13.7.2 SVGA mode synchronization circuit** 

We wish to create a dual-mode synchronization circuit that can support both VGA and   
SVGA modes. The mode can be selected by a switch. Construct the circuit as follows:   

1. Modify the horizontal and vertical synchronization counters of Listing 13.1 to accommodate both modes. 

2. Design a pixel-generating circuit that draws a 100-pixel grid on the screen (i.e., draw 
	a vertical line every 100 pixels and draw a horizontal line every 100 pixels). 

3. Derive a top-level module. Synthesize and verify operation of the two modes.
