Created by: Angelo Jacobo   
Date: July 1,2021  

[![image](https://user-images.githubusercontent.com/87559347/126294967-419dbd4b-6dbb-43f6-8c0b-eebbcc762a1e.png)](https://youtu.be/YhWUV0hEanc)


# Inside the src folder are:   
* logic_analyzer.v -> Combines the vga_core and full_screen_gen. Displays the waveforms from 4-inputs.    
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Sampling rate is 200kHz (max input frequency:100kHz  , min input frequency:10kHz)   
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;The 4 square wave test-signals will come from the fpga itself.	   
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;The trigger will come from "key" pushbutton.   
* full_screen_gen.v ->  Main logic for displaying different square wave patterns based on the received test-signals.   
* vga_core.v -> VGA controller for a 640x480 @60Hz resolution.  
* logic_analyzer.ucf -> Constraint file for squarewave_disp.v   

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  


# TASK:
**14.6.7 Simple four-trace logic analyzer** 

A logic analyzer displays the waveforms of a collection of digital signals. We want to   
design a simple logic analyzer that captures the waveforms of four input signals in "free-running" mode.   
Instead of using a trigger pattern, data capture is initiated with activation of   
a pushbutton switch. For simplicity, we assume that the frequencies of the input waveform   
are between 10 kHz and 100 kHz. The circuit can be designed as follows:   

1. Use a sampling tick to sample the four input signals. Make sure to select a proper rate 
	so that the desired input frequency range can be displayed properly on the screen. 
	
2. For a point in the sampled signal, its value can be encoded as a tile pattern by including 
	the value of the previous point. For example, if the sampled sequence of one signal is 
	"00001 1 1 1000", the tile patterns become "00 00 00 01 1 l 11 1 l 10 00 OO", as shown 
	in Figure 14.7(b). 
	
3. Follow the procedure of the preceding square-wave experiment to design the tile 
	memory and video interface to display the four waveforms being stored .
	
4. Derive the HDL description and then synthesize the circuit. 
