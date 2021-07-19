Created by: Angelo Jacobo
Date: March 27,2021

Inside the src folder are:
fifo.v -> FiFo buffer from 7.7.3 task
fifo_test_vector.v -> Module where all test inputs will come from.
fifo_monitor.v -> Monitors the input and resulting output. Outputs "ERROR" when the real output and the desired output is not equal
fifo_TB.v -> See"fifo_TB_RESULT.txt" for the result of this testbench

Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.
Note: The first block of errors are due to uninitialize fifo module. The second and third block of errors are just due to the
		asynchronous read operation during empty or full state and can be ignored.

TASK:
7.7.7 Testbench for FIFO buffer

Follow the example in Section 7.5.10 to design a compressive testbench to verify operation
of the FIFO buffer discussed in Section 4.5.3. The test vector generator module should
generate various combinations of write and read operations and introduce the full and
empty conditions. The monitor module should continuously watch data written into and
retrieved from the buffer and check the correctness of the operations. 
