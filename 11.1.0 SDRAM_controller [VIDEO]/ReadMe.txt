Created by: Angelo Jacobo 
Date: June 7,2021

Inside the src folder are:
top_module.v -> Uses the sdram_controller, uart, and 100MHz DCM core. Transmit and receive data from SDRAM
			via UART. Press "key" to alternate between transmitting(PC->UART->SDRAM) and receiving(SDRAM->UART->PC).
			First three ASCII received/transmittted is the SDRAM address(24-bits) then the next two consecutive ASCII
			are then the data(16-bits).		
sdram_controller.v -> Interface module between FPGA and SDRAM. SDRAM used is "winbond-W9825G6KH". Current settings are:
				Burst: 1
				Address Mode: Sequential
				Autoprecharge is enabled after every read/write.
UART.v -> Interface from PC -> FPGA -> SDRAM and vice-versa.
dcm_100MHz.xco -> Clock used is 100MHz for finer control sequence to SDRAM.
top_module.ucf -> Constraint file for top_module.v

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.

NOTE: Chapter 11 of this book is only about SRAM(Static RAM) controller. But my board only have an SDRAM(Synchronous Dynamic RAM) so that 
	is what I instead did here. Beware that SDRAM controller IS A COMPLETELY DIFFERENT LEVEL compared to making an SRAM controller. 
	I added a lot of comments on my code (especially the the sdram_controller.v) so try to understand the whole logic first before 
	trying to make your own controller. 