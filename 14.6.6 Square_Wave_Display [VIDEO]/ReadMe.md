Created by: Angelo Jacobo   
Date: July 1,2021  

[![image](https://user-images.githubusercontent.com/87559347/126293508-aa4c0b18-b897-402c-bbc9-174756d9799a.png)](https://youtu.be/PkNyh-GzMQg)

# Inside the src folder are:  
* squarewave_disp.v -> Combines the vga_core and full_screen_gen. Generates square wave patterns on screen.  
			 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[0] to move cursor to right,  
			 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[1] to move cursor down,  
			 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[2] to change waveform pattern(4 different patterns)		
* full_screen_gen.v ->  Main logic for displaying different square wave patterns on screen  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.  
* squarewave_disp.ucf -> Constraint file for squarewave_disp.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  


# TASK:  
**14.6.6 Square-wave display**   

We can draw a square wave by using the four simple tile patterns shown in Figure 14.7(a).   
Follow the procedure of a full-screen text display in Section 14.3 to design a full-screen   
wave editor:   

1. Let the tile size be 8 columns by 64 rows. Create a pattern ROM for the four patterns. 

2. Calculate the number of tiles on a 640-by-480 resolution screen and derive the proper 
configuration for the tile memory. 

3. Use three pushbuttons for control and a 2-bit switch to enter the pattern. 

4. Derive the HDL description and then synthesize and verify operation of the circuit. 
