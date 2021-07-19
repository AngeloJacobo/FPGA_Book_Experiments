Created by: Angelo Jacobo   
Date: April 19,2021  

# Inside the src folder are:  
* top_module.v -> Combines uart_rx, uart_tx, fifo, baud_generator, debounce_explicit, LED_mux, bin2bcd, and  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;autobaud_plus_autoparity modules. Detects the baudrate(standard or custom) and parity   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; type(none,even,or odd) of the receiving data bytes. The ASCII input must be "x" followed  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; by "p" when in detection mode.  
* uart_test.v -> Simple fpga test for the top module. Pressing the btn2 will add 1 to the received value(which is an ASCII)  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;The ASCII input must be "x" followed then transmit it back to terminal.  
* autobaud_plus_autoparity.v -> FSM logic for baud-rate and parity detection   
* uart_rx.v -> Uart receiver   
* uart.tx -> Uart transmitter  
* fifo.v -> Used by uart_rx to store the received value. Also used by uart_tx to store the values that is about to be transmitted  
* baud_generator.v -> A free-running counter that ticks every 1/16th of the baudrate  
* debounce_explicit.v -> Debounce circuit  
* bin2bcd.v -> Converts the binary value of detected baud-rate to bcd value to be displayed on the seven-segment LEDs.  
* LED_mux.v -> Time-multiplexing module for the seven-segments  
* uart_test.ucf -> Constraint file for uart_test  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.

# UML Chart:  
![UML_chart](https://user-images.githubusercontent.com/87559347/126113633-b21d0aa0-42c5-4ecd-9d58-4f99eb6277bf.jpg)  



# TASKS(This experiment is the combination of the following experiments):  
**8.7.2 UART with an automatic baud rate detection circuit**

The most commonly used number of data bits of a serial connection is eight, which   
corresponds to a byte. When a regular ASCII code is used in communication (as we type  
in   the HyperTerrninal window), only seven LSBs are used and the MSB is 0. If the UART is     
configured as 8 data bits, 1 stop bit, and no parity bit, the received word is in the form   
of 0-dddd-dddO-I, in which d is a data bit and can be 0 or 1. Assume that there is sufficient     
time between the first word and subsequent transmissions. We can determine the baud rate    
by measuring the time interval between the first 0 and last 0. Based on this observation,  
we can derive a UART with an automatic baud rate detection circuit. In this scheme, the   
transmitting system first sends an ASCII code for rate detection and then resumes normal   
operation afterward. The receiving subsystem uses the first word to determine a baud rate   
and then uses this rate for the baud rate generator for the remaining transmission.   
Assume that the UART configuration is 8 data bits, 1 stop bit, and no parity bit, and the   
baud rate can be 4800,9600, or 19,200 baud. The revised UART receiver should have two   
operation modes. It is initially in the "detection mode" and waits for the first word. After   
the word is received and the baud rate is determined, the receiver enters "normal mode"   
and the UART operates in a regular fashion. Derive the UART as follows:   

1. Draw the ASMD chart for the automatic baud rate detector circuit. 

2. Derive the Verilog code for the ASMD chart. Use three LEDs on the S3 board to 
indicate the baud rate of the incoming signal. 

3. Modify the UART to include three different baud rates: 4800, 9600, and 19,200. 
This can be achieved by using a register for the divisor of the baud rate generator and 
loading the value according to the desired baud rate. 

4. Create a top-level FSMD to keep track of the mode and to control and coordinate 
operation of the baud rate detection circuit and the regular UART receiver. Use a 
pushbutton switch on the S3 board to force the UART into the detection mode. 

5. Revise the top-level UART code and the verification circuit. Synthesize the verification circuit. 

6. Create different configurations in HyperTerrninal and verify operation of the UART


**8.7.3 UART with an automatic baud rate and parity detection circuit**

In addition to the baud rate, we assume that the parity scheme also needs to be determined 
automatically, which can be no parity, even parity, or odd parity. Expand the previous 
automatic baud rate detection circuit to detect the parity configuration and repeat Experiment 8.7.2. 
