Created by: Angelo Jacobo 
Date: March 18,2021

Inside the src folder are:
main_controller.v -> Module that combines bcd_counter,bcd2bin, fibonacci, bin2bcd, debounce_explicit, and LED-mux module. 
				"sw1" increments value of i, "sw2" switches display from value of i to the value of i-th fibonacci.
debounce_explicit.v -> debounce module for "sw1" and "sw2"
bcd_counter.v -> counts in bcd format and is used as the "i" value for the fibonacci. 
bcd2bin.v -> converts bcd output from bcd_counter to binary format
fibonacci.v -> input is the "i" from bcd2bin. The output is the i-th value of fibonacci
bin2bcd.v -> converts binary output from fibonacci to bcd format
LED_mux.v -> time multiplexing module for  seven segment. Input comes from the output of bin2bcd.
main_controller.ucf -> Constraint file for main_controller.v


Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.



TASK:
6.5.3 Fibonacci circuit with BCD 110: design approach 1

To make the Fibonacci circuit more user friendly, we can modify the circuit to use the BCD
format for the input and output. Assume that the input is an 8-bit signal in BCD format
(i.e., two BCD digits) and the output is displayed as four BCD digits on the seven-segment
LED display. Furthermore, the LED will display "9999" if the resulting Fibonacci number
is larger than 9999 (i.e., overflow). The operation can be done in three steps: convert input
to the binary format, compute the Fibonacci number, and convert the result back to BCD
format.

The first design approach is to follow the procedure outlined in Section 6.3.5. We
first construct three smaller subsystems, which are the BCD-to-binary conversion circuit,
Fibonacci circuit, and binary-to-BCD conversion circuit, and then use a master FSM to
control the overall operation. Design the circuit as follows:

1. Implement the BCD-to-binary conversion circuit in Experiment 6.5.2.
2. Modify the Fibonacci number circuit in Section 6.3.1 to include an output signal to
indicate the overflow condition.
3. Derive the top-level block diagram and the master control FSM state diagram.
4. Derive the HDL code.
5. Derive a testbench and use simulation to verify operation of the code.
6. Synthesize the circuit, program the FPGA, and verify its operation. 