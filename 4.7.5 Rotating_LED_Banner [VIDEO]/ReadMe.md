Created by: Angelo Jacobo  
Date: March 7,2021  

[![](https://user-images.githubusercontent.com/87559347/126058938-c0774499-ca61-495f-80a4-334ff8c6d97f.png)](https://youtu.be/SsllM09WXK8)


# Inside the src folder are:  
rotating_LED.v -> Module for rotating LED banner. Edit "W" with the number of desired letters,  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; then edit the "words" register with the desired letters,  
rotating_LED_TEST.v -> Module that combines the rotating_LED module and Led_mux module.  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;"en" for play/pause  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;"dir" for moving left/right  
Led_mux.v -> Module for seven-segment time-multiplexing circuit.  
rotating_LED_TEST.ucf -> Constraint file for rotating_LED_TEST.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  

# TASK:   
**4.7.5 Rotating LED banner circuit**  

The prototyping board has a four-digit seven-segment LED display, and thus only four  
symbols can be displayed at a time. We can show more information if the data is rotated and moved continuously.

For example, assume that the message is 10 digits (i.e.,"0123456789"). The display can show the message as:  
"0123", "1234", "2345", . . . , 6789", "7890, . . . , "0123". The circuit should have an  
input, en, which enables or pauses the rotation, and an input, dir,  
which specifies the direction (i.e., rotate left or right).  

Design the circuit and verify its operation on the prototyping board. Make sure that the
rotation rate is slow enough for visual inspection.
