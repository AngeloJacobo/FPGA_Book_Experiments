Created by: Angelo Jacobo   
Date: March 6,2021  

# Inside the src folder are:  
heartbeat.v -> FreeRunning heartbeat on 6 seven-segment LEDs  
heartbeat_TB.v -> Testbench with a frequency of 10MHz -> 100ns per heartbeat pattern  
heartbeat_TEST.v -> Module that combines the heartbeat module and Led_mux module
Led_mux.v -> Module for seven-segment time-multiplexing circuit  
heartbeat_TEST.ucf -> Constraint file for heartbeat_TEST.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  

# TASK:  
**4.7.4 Heartbeat circuit**  

We want to create a "heartbeat" for the prototyping board. It repeats the simple pattern in  
the four-digit seven-segment display, as shown in Figure 4.13. Design the circuit and verify  
its operation on the prototyping board.   
