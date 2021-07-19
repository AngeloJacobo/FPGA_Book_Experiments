Created by: Angelo Jacobo   
Date: May 10,2021  

# Inside the src folder are:  
* kb_control_circuit.v -> Uses the ps2_tx module to communicate with a ps/2 keyboard.   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Press key0 to turn-on the num-lock led  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Press key1 to turn-on the scroll lock led  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Press key2 to turn-on the caps-lock led  
* ps2_tx.v -> Transmit module for interfacing with ps/2 devices(we use aps/2 keyboard on this experiment)  
* kb_control_circuit.ucf -> Constraint file for kb_control_circuit.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  



# TASK:
**10.7.1 Keyboard control circuit**

A host can issue a command to set certain parameters for a PS2 keyboard as well. For  
example, we can control the three LEDs of the keyboard by sending ED OX. The X is a  
hexadecimal number with a format of "Osnc", where s, n, and c are I-bit values that control  
the Scroll, Num, and Caps Lock LEDs, respectively. Use a 3-bit switch to control the three  
keyboard LEDs.  
