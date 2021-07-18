Created by: Angelo Jacobo  
Date: March 8,2021  

# Inside the src folder are:  
* Stack.v -> Last-in-First-out Buffer with parameterized W=width and B=bits.  
* Stack_TB.v -> See "Stack_TB_RESULT.txt" for the result of this testbench  

Note: This code is for simulation-purpose only and is not yet synthesized to any FPGA.

# TASK:
**4.7.7 Stack**

A stack is a last-in-first-out buffer in which the last stored data is retrieved first. Storing a
data word to a stack is known as apush operation, and retrieving a data word from a stack
is known as apop operation. The 110 signals of a stack are similar to those of a FIFO buffer
except that we generally use the push and pop signals in place of the wr and rd signals.
Design a stack using a register file.
