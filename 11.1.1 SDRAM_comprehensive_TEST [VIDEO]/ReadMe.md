Created by: Angelo Jacobo   
Date: June 8,2021  

# Inside the src folder are:  
* sdram_test.v -> Comprehensive testing circuit for SDRAM.   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key<0>: Writes data to all 2^24 addresses of SDRAM  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key<1> Reads the data of 2^24 addresses of SDRAM and checks if an   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;error occured(unmatched read data to the written data)  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;key<2> Injects wrong data to SDARM using UART interface  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;First digit of Seven-segment LED is the error read. Second digit is the  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;number of already injected errors(via UART) 		  
* sdram_controller.v -> Interface module between FPGA and SDRAM. SDRAM used is "winbond-W9825G6KH". Current settings are:  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Burst: 1  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Address Mode: Sequential  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Autoprecharge is enabled after every read/write.  
* UART.v -> Interface from PC -> FPGA -> SDRAM and vice-versa.  
* LED_mux.v -> Seve-segment LED time-mulitiplexing module. Displays read-error and injected error.  
* sdram_test.ucf -> Constraint file for sdram_test.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  


# NOTE: 
Chapter 11 of this book is only about SRAM(Static RAM) controller. But my board only has an SDRAM(Synchronous Dynamic RAM) so that is what
I instead did here. Beware that SDRAM controller **IS A COMPLETELY DIFFERENT LEVEL** compared to making an SRAM controller.    

I added a lot of comments on my code (especially the the sdram_controller.v) so try to understand the whole logic first before trying to make your own SDRAM controller.   
