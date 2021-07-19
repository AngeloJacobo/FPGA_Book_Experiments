Created by: Angelo Jacobo 
Date: April 19,2021

Inside the src folder are:
top_module.v -> Combines uart_rx, uart_tx, fifo, baud_generator, debounce_explicit, and LED_mux. Lets you choose 
			the baudrate, number of databits, stopbits, and type of parity. btn0 is for choosing and btn1 is the enter key.   
uart_test.v -> Simple fpga test for the top module. Pressing the btn2 will add 1 to the received value(which is an ASCII) then transmit it back to terminal.
uart_rx.v -> Uart receiver
uart.tx -> Uart transmitter
fifo.v -> Used by uart_rx to store the received value. Also used by uart_tx to store the values that is about to be transmitted
baud_generator.v -> A free-running counter that ticks every 1/16th of the baudrate
debounce_explicit.v -> Debounce circuit
LED_mux.v -> Time-multiplexing module for the seven-segments
uart_test.ucf -> Constraint file for uart_test


Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.



TASK:
8.7.1 Full-featured UART

The alternative to the customized UART is to include all features in design and to dynamically configure the UART as needed. 
Consider a full-featured UART that uses additional input signals to specify the baud rate, type of parity bit, 
and the numbers of data bits and stop bits. The UART also includes an error signal. In addition to the I10 signals of the
uart-top design in Listing 8.4, the following signals are required:

>bd-rate: 2-bit input signal specifying the baud rate, which can be 1200,2400,4800,
or 9600 baud

>dnum: I-bit input signal specifying the number of data bits, which can be 7 or 8

>snum: 1 -bit input signal specifying the number of stop bits, which can be 1 or 2

>par: 2-bit input signal specifying the desired parity scheme, which can be no parity, even parity, or odd parity

>err: 3-bit output signal in which the bits indicate the existence of the parity error, frame error, and data overrun error

Derive this circuit as follows:
1. Modify the ASMD chart in Figure 8.3 to accommodate the required extensions.
2. Revise the UART receiver code according to the ASMD chart.
3. Revise the UART transmitter code to accommodate the required extensions. 
4. Revise the top-level UART code and the verification circuit. Use the onboard switches
for the additional input signals and three LEDs for the error signals. Synthesize the
verification circuit.
5. Create different configurations in HyperTerminal and verify operation of the UART
circuit. 