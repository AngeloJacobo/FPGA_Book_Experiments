Created by: Angelo Jacobo 
Date: April 21,2021

Inside the src folder are:
uart_plus_stopwatch.v -> Combines the Enhanced_Stopwatch(from experiment 4.7.6), uart,, and LED-mux modules.
				Input of "c" or "C" for clear
				Input of "g" or "G" for go
				Input of "p" or "P" for pause
				Input of "u" or "U" to reverse counting
				Input of "r" or "R" to transmit current time to terminal
Enhanced_Stopwatch.v -> Stopwatch with enable and can count up and down.
autobaud_plus_autoparity.v -> FSM logic for baud-rate and parity detection
LED_mux.v -> Time-multiplexing module for the seven-segments
uart_plus_stopwatch.ucf -> Constraint file for ehn_stopwatch_TEST.v



Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.



TASKS:
8.7.4 UART-controlled stopwatch

Consider the enhanced stopwatch in Experiment 4.7.6. Operation of the stopwatch is controlled by three switches on the S3 board.
With the UART, we can use PC's HyperTerrninal to send commands to and retrieve time from the stopwatch: 
>When a c or C (for "clear") ASCII code is received, the stopwatch aborts current
	counting, is cleared to zero, and sets the counting direction to "up."
>When a g or G (for "go") ASCII code is received, the stopwatch starts to count.
>When a p or P (for "pause") ASCII code is received, counting pauses.
>When a u or U (for "up-down") ASCII code is received, the stopwatch reverses the
	direction of counting.
>When a r or R (for "receive") ASCII code is received, the stopwatch transmits the
	current time to the PC. The time should be displayed as " DD . D ", where D is a decimal
	digit.
All other codes will be ignored.
Design the new stopwatch, synthesize the circuit, connect it to a PC, and use HyperTerminal
to verify its operation.