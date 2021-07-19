Created by: Angelo Jacobo
Date: March 27,2021

Inside the src folder are:
universal_binary_counter.v -> Counter with pause, count-up/down, syn_clr, and load operation.
test_vector.v -> Module where all test inputs will come from.
monitor.v -> Monitors the input and resulting output. Outputs "ERROR" when the real output and the desired output is not equal
universal_binary_counter_TB.v -> See" universal_binary_counter_TB_RESULT.txt" for the result of this testbench

Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.
Note: The first error is not counted as real error since the main module is not yet initialize

TASK:
7.7.6 Enhanced binary counter monitor

The monitor module in Section 7.5.10 is intended to monitor a synchronous system and
only checks the activities at the rising edges of the clock signal. The asynchronous reset
operation is reported as an error. Modify the monitor circuit to take the asynchronous
operation into consideration. Recreate the testbench and perform simulation to verify its
operation 

