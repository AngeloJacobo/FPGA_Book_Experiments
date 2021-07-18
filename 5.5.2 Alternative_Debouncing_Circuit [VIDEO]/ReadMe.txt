Created by: Angelo Jacobo     
Date: March 11,2021   

# Inside the src folder are:   
* early_debounce.v -> A debouncing module that asserts for the first rising edge of the button then stay there 
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;for 20ms before deasserting instantly on the falling edge. It will then wait for another 20ms before asserting on the next rising edge
* debouncing_button_TB.v -> A simple testbench to ensure the operation of the debouncing module
* debouncing_TEST.v -> Module that combines early_debounce and Led_mux. Every press of the "sw" will increment the counter by 1 which will then be displayed on the seven-segments.
* Led_mux.v -> Module for seven-segment time-multiplexing circuit.
* debouncing_TEST.ucf -> Constraint file for debouncing_TEST.v

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.


# TASK:  
**5.5.2 Alternative debouncing circuit**

One problem with the debouncing design in Section 5.3.2 is the delayed response of the
onset of a switch transition. An alternative is to react to the first edge in the transition and
then wait for a small amount of time (at least 20 ms) to have the input signal settled. The
output timing diagram is shown at the bottom of Figure 5.8. When the input changes from 0 to 1,
the FSM responds immediately. The FSM then ignores the input for about 20 ms to
avoid glitches. After this amount of time, the FSM starts to check the input for the falling
edge. Follow the design procedure in Section 5.3.2 to design the alternative circuit.
1. Derive the state diagram and ASM chart for the circuit.
2. Derive the HDL code.
3. Derive the HDL code based on the state diagram and ASM chart.
4. Derive a testbench and use simulation to verify operation of the code.
5. Replace the debouncing circuit in Section 5.3.3 with the alternative design and verify
its operation. 

