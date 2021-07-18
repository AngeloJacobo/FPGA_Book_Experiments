Created by: Angelo Jacobo  
Date: March 11,2021  

# Inside the src folder are:  
* parking_lot_counter.v -> Checks whether a vehicle has entered or exited based on some predefined patterns  
* parking_lot_counter_TB.v -> A simple testbench to ensure the operation of the parking_lot_counter  
* parking_lot_counter_TEST.v -> Module that combines: parking_lot_counter, debouncing_button, and Led_mux.  
* debouncing_button.v -> I use a debouncing button for smoother button-reaction.  
* Led_mux.v -> Module for seven-segment time-multiplexing circuit.  
* parking_lot_counter_TEST.ucf -> Constraint file for parking_lot_counter_TEST.v  

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.  


# TASK:  
**5.5.3 Parking lot occupancy counter**  

Consider a parking lot with a single entry and exit gate. Two pairs of photo sensors are used  
to monitor the activity of cars, as shown in Figure 5.1 1. When an object is between the  
photo transmitter and the photo receiver, the light is blocked and the corresponding output  
is asserted to 1. By monitoring the events of two sensors, we can determine whether a car is  
entering or exiting or a pedestrian is passing through. For example, the following sequence  
indicates that a car enters the lot:  

Initially, both sensors are unblocked (i.e., the a and b signals are "00").  
Sensor a is blocked (i.e., the a and b signals are " 10").  
Both sensors are blocked (i.e., the a and b signals are "1 1 ").  
Sensor a is unblocked (i.e., the a and b signals are "01 ").  
Both sensors becomes unblocked (i.e., the a and b signals are "00").  

Design a parking lot occupancy counter as follows:  

1. Design an FSM with two input signals, a and b, and two output signals, enter and
exit. The enter and exit signals assert one clock cycle when a car enters and one
clock cycle when a car exits the lot, respectively.  

2. Derive the HDL code for the FSM.  

3. Design a counter with two control signals, inc and dec, which increment and decrement the counter when asserted. Derive the HDL code. 

4. Combine the counter and the FSM and LED multiplexing circuit. Use two debounced
pushbuttons to mimic operation of the two sensor outputs. Verify operation of the
occupancy counter. 
