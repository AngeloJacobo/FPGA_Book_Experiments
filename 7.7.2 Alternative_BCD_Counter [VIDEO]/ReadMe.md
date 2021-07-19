Created by: Angelo Jacobo   
Date: March 27,2021 

[![]( https://user-images.githubusercontent.com/87559347/126104959-c2c789e6-0437-4e5a-bcc4-cbd48e2b8043.png)](https://youtu.be/SdC0M2zq55g )

# Inside the src folder are: 
* alt_bcd_counter.v -> BCD_counter but with less variables by combining the blocking and non-blocking assignments in 1 always-block.  
* main_controller.v -> Combines the alt_bcd_counter and LED_mux modules. A 3-digit stopwatch(counts from 00.0 to 99.9 seconds) with pause/play.  
* LED_mux.v -> time multiplexing module for the seven-segment LEDs.  
* main_controller.ucf -> Constraint file for main_controller.v  


Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  



# TASK:
**7.7.2 Alternative coding style for BCD counter**

Rewrite the BCD counter in Listing 4.18 using the coding style discussed in Section 7.2.
Resynthesize the circuit and verify its operation.
