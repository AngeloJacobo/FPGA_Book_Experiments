Created by: Angelo Jacobo  
Date: April 28,2021  

# Inside the src folder are:   
* kb_test.v -> Combines kb, ascii, and uart modules. The received packets from ps2-keyboard is transmitted to pc via UART.   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;The transmitted data is already converted to ASCII. Capital letters using shift key is allowed.  
* kb.v -> The makecode is extracted and the breakcode(starting with 8'hf0) is removed. The makecodes are stored to the fifo.  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Typematic condition(long press) is allowed. Pressing shift will assert the 9th bit to signify a capital letter.  
* ascii.v -> Converts makecode to ascii to be displayed to the pc terminal via uart.  
* uart.v -> UART circuit  
* kb_test.ucf -> Constraint file for kb_test module  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.



# TASK:  
**9.6.2 Alternative keyboard interface II**  

We can expand the interface circuit to distinguish whether the shift key is pressed so that  
both lower- and uppercase characters can be entered. The expanded circuit can be modified  
as follows:   

* The keycode output should be extended from 8 bits to 9 bits. The extra bit indicates   
whether the shift key is held down.   
* The FSM should add a special branch to process the make and break codes of the  
shift key and set the value of the corresponding bit accordingly.  
* The width of the FIFO buffer should be extended to 9 bits.   
* 
Design the expanded interface circuit, modify the key2ascii circuit to handle both lower and  
uppercase characters, resynthesize the verification circuit, and verify operation of the  
expanded interface circuit.  
