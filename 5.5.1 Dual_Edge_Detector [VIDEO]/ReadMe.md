Created by: Angelo Jacobo  
Date: March 11,2021   

# Inside the src folder are:  
* dual_edge_detector_MEALY.v -> Dual edge detector(ticks for one clock cycle for every rising and falling edge) using Mealy FSM.  
* dual_edge_detector_MOORE.v -> Dual edge detector(ticks for one clock cycle for every rising and falling edge) using Moore FSM.  
* dual_edge_detector_simpler.v -> Dual edge detector(ticks for one clock cycle for every rising and falling edge) using simple logic and does not need FSM.  
dual_edge_detector_simpler_TEST.v -> Module that combines: dual_edge_detector_simpler, debouncing_button, and Led_mux.  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Every press of the "sw" will increment the counter by 2(since its a dual edge detector) 
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;which will then be displayed on the seven-segments.
* debouncing_button.v -> I use a debouncing button for smoother button-reaction
* Led_mux.v -> Module for seven-segment time-multiplexing circuit.
* dual_edge_detector_simpler_TEST.ucf -> Constraint file for dual_edge_detector_simpler_TEST.v

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.


# TASK:
**5.5.1 Dual-edge detector**

A dual-edge detector is similar to a rising-edge detector except that the output is asserted  
for one clock cycle when the input changes from 0 to 1 (i.e., rising edge) and 1 to 0 (i.e.,  
falling edge).  

1. Design a circuit based on the Moore machine and draw the state diagram and ASM
chart.

2. Derive the HDL code based on the state diagram of the ASM chart.

3. Derive a testbench and use simulation to verify operation of the code.

4. Replace the rising detectors in Section 5.3.3 with dual-edge detectors and verify their
operations.

5. Repeat steps 1 to 4 for a Mealy machine-based design
