Created by: Angelo Jacobo  
Date: March 8,2021  

[![](https://user-images.githubusercontent.com/87559347/126059676-085c641c-19ce-45cb-8101-d65b44adc691.png )](https://youtu.be/QK5GNwCojkQ)  

# Inside the src folder are:  
* Enhanced_Stopwatch.v -> Stopwatch with enable and can count up and down.  
* EnhancedStopwatch_TB.v -> Testbench that ticks every 50ns with a 100MHZ clock  
* ehn_stopwatch_TEST.v -> Module that combines the Enhanced_Stopwatch module and Led_mux module.    
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;"go" is for play/pause and "up" is for counting-up/counting-down  
* Led_mux.v -> Module for seven-segment time-multiplexing circuit.  
* ehn_stopwatch_TEST.ucf -> Constraint file for ehn_stopwatch_TEST.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  


# TASK:  
**4.7.6 Enhanced stopwatch**  

Modify the stopwatch with the following extensions:   

* Add an additional signal, up, to control the direction of counting. The stopwatch
counts up when the up signal is asserted and counts down otherwise.

* Add a minute digit to the display. The LED display format should be like M. SS . D,
where D represents 0.1 second and its range is between 0 and 9, SS represents seconds
and its range is between 00 and 59, and M represents minutes and its range is between 0
and 9.

Design the new stopwatch and verify its operation with a testing circuit. 
