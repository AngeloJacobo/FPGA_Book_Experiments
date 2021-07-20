Created by: Angelo Jacobo
Date: June 13,2021

Inside the src folder are:
fifo.v -> FiFo buffer BUT WITH BLOCK RAM
fifo_test_vector.v -> Module where all test inputs will come from.
fifo_monitor.v -> Monitors the input and resulting output. Outputs "ERROR" when the real output and the desired output is not equal
fifo_TB.v -> See"fifo_TB_RESULT.txt" for the result of this testbench

Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.
Note: Notice that the result is exactly the same results as 7.7.7 Testbench_For_FiFo_Buffer.
		The first block of errors are due to uninitialize fifo module. The second and third block of errors are just due to the
		asynchronous read operation during empty or full state and can be ignored.

TASK:
12.6.1 Block-RAM-based FIFO 

In Section 4.5.3, we design a FIFO buffer that uses a register file for storage. To increase its 
capacity, we can replace the register file with a block RAM-based dual-port RAM module. 
Derive the HDL code for the new design. Synthesize the verification circuit with the new FIFO buffer 
and verify its operation. Note that due to the synchronous read, the behavior of the new FIFO 
is not completely identical to that of the original FIFO
