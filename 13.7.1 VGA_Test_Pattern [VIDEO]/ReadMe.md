Created by: Angelo Jacobo   
Date: June 20,2021  

# Inside the src folder are:
* top_module.v -> Combines the vga_core , vga_test_pattern, and 25MHz clk DCM modules. Alternates between horizontal 
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;and vertical test pattern depending if "key" is pressed or not.
* vga_test_pattern.v -> Generates the test patterns which can be either horizontal or vertical strips of 8 colors.	
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.
* dcm_25MHz.xco -> Clock used is 25MHz for a 640x480 @60Hz resolution.
* top_module.ucf -> Constraint file for top_module.v

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.

# TASKS:
**13.7.1 VGA test pattern generator** 

A VGA test pattern generator produces two simple patterns to verify operation of a VGA   
monitor. The first pattern divides the screen evenly into eight vertical stripes, each displaying a unique color.  
The second pattern is similar but the screen is divided into eight horizontal stripes. A 1-bit switch is used   
to select the pattern.Design a pixel-generating circuit for this pattern generator and then combine it with the   
synchronization circuit in a top-level module. Synthesize and verify operation ofthe circuit.   
