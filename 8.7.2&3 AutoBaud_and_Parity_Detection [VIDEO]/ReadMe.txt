Created by: Angelo Jacobo 
Date: April 19,2021

Inside the src folder are:
top_module.v -> Combines uart_rx, uart_tx, fifo, baud_generator, debounce_explicit, LED_mux, bin2bcd, and autobaud_plus_autoparity modules. 
				Detects the baudrate(standard or custom) and parity type(none,even,or odd) of the receiving data bytes.
				The ASCII input must be "x" followed by "p" when in detection mode.
uart_test.v -> Simple fpga test for the top module. Pressing the btn2 will add 1 to the received value(which is an ASCII) then transmit it back to terminal.
autobaud_plus_autoparity.v -> FSM logic for baud-rate and parity detection
uart_rx.v -> Uart receiver
uart.tx -> Uart transmitter
fifo.v -> Used by uart_rx to store the received value. Also used by uart_tx to store the values that is about to be transmitted
baud_generator.v -> A free-running counter that ticks every 1/16th of the baudrate
debounce_explicit.v -> Debounce circuit
bin2bcd.v -> Converts the binary value of detected baud-rate to bcd value to be displayed on the seven-segment LEDs.
LED_mux.v -> Time-multiplexing module for the seven-segments
uart_test.ucf -> Constraint file for uart_test



Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.



TASKS:
8.7.2 UART with an automatic baud rate detection circuit
8.7.3 UART with an automatic baud rate and parity detection circuit 