Created by: Angelo Jacobo   
Date: April 28,2021  

# Inside the src folder are:  
* kb_test.v -> Combines kb, ascii, and uart modules. The received packets from ps2-keyboard is transmitted to pc via UART.  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;The transmitted data is already converted to ASCII.  
* kb.v -> The makecode is extracted and the breakcode(starting with 8'hf0) is removed. The makecodes are stored to the fifo.
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Typematic condition(long press) is allowed.  
* ascii.v -> Converts makecode to ascii to be displayed to the pc terminal via uart.  
* uart.v > UART circuit  
* kb_test.ucf -> Constraint file for kb_test module  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  



# TASK:
**9.6.1 Alternative keyboard interface I**

The interface circuit in Section 9.4 returns the make code of the last released key and  
thus ignores the typematic condition. An alternative approach is to consider the typematic  
condition. The keyboard interface circuit should return a key's make code repeatedly when  
it is held down and ignore the final break code. For simplicity, we assume that the extended   
keys are not used. Design the new interface circuit, resynthesize the verification circuit,  
and verify operation of the new interface circuit  
