Created by: Angelo Jacobo   
Date: June 30,2021  

# Inside the src folder are:
* rotating_banner.v -> Combines the vga_core and rotating_banner_gen modules. The banner text is: "Hello FPGA World".  
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[1:0] for changing char size ,   
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key[3:2] for changing speed of rotation  
* rotating_banner_gen.v -> main logic for rotating banner with variable character size and rotation speed  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.   
* rotating_banner.ucf -> Constraint file for rotating_banner.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  


# TASK:  
**14.6.1 Rotating banner** 

A rotating banner on the monitor screen moves a line from right to left and then wraps   
around. It is similar to the Window's Marquee screen saver. Let the text on the banner   
be "Hello FPGA World." The banner should be displayed in four different font sizes and    
can travel at four different speeds. The font size and speed are controlled by four switches.   
Derive the HDL description and then synthesize and verify operation of the circuit.   
