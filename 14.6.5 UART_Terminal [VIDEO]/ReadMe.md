Created by: Angelo Jacobo  
Date: June 30,2021  

# Inside the src folder are:  
* uart_terminal.v -> Combines the vga_core, full_screen_gen, and uart modules. The screen  
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;will echo the text on the pc serial terminal. The screen automatically "scroll-up"  
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;after reaching the last line.				  
* full_screen_gen.v ->  Main logic for displaying received characters from UART. The specifications are written on the TASK  
* uart.v -> Top module for ps2 keyboard , default baudrate is 4800 for 25MHz clock  
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.  
* uart_terminal.ucf -> Constraint file for uart_terminal.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  


# TASK:
**14.6.5 UART terminal** 

The UART terminal receives input from the UART port and displays the received characters   
on a monitor. When connected to the PC's serial port, it should echo the text on Window's   
HypterTerminal. The detailed specifications are:   

* A cursor is used to indicate the current location. 
* The screen starts a new line when a "carriage return" code (Od16) is received.
* A line wraps around (i.e., starts a new line) after 80 characters. 
* When the cursor reaches the bottom of the screen (i.e., the last line), the first line will 
	be discarded and all other lines move up (i.e., scroll up) one position.
	
Derive the HDL description and then synthesize and verify operation of the circuit.
