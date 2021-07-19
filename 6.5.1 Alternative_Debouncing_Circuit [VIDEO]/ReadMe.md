Created by: Angelo Jacobo  
Date: March 18,2021  

[![](https://user-images.githubusercontent.com/87559347/126088428-bb46ac5e-3cb7-46e5-af15-07fd6caccc48.png )](https://youtu.be/F9giVyWyruE )

# Inside the src folder are:  
* debounce.v -> A debouncing module that asserts on the first rising edge of the button then stay there for 100ms before  
 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;deasserting instantly on the falling edge. It will then wait for another 100ms before asserting on the next rising edge.  
* debounce_TB.v -> A simple testbench to ensure the operation of the debounce module.   
* debouncing_TEST.v -> Module that combines debounce and Led_mux modules. Every press of the "sw" will increment the counter by 1.  
 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;which will then be displayed on the seven-segments.   
* Led_mux.v -> Module for seven-segment time-multiplexing circuit.   
* debouncing_TEST.ucf -> Constraint file for debouncing_TEST.v   

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.

![UML_chart](https://user-images.githubusercontent.com/87559347/126088550-1017673d-1081-4b59-b477-11082e92336b.jpg)


# TASK:
**6.5.1 Alternative debouncing circuit**  
Consider the alternative debouncing circuit in Experiment 5.5.2. Redesign the circuit using  
the RT methodology:  

1. Derive the ASMD chart for the circuit.

2. Derive the HDL code based on the ASMD chart.

3. Replace the debouncing circuit in Section 6.2.5 with the alternative design and verify
its operation. 
