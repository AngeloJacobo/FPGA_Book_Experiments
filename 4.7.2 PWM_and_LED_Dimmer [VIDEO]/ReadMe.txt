Created by: Angelo Jacobo
Date: March 5,2021

Inside the src folder are:
led_dimmer.v -> 4-bit resolution PWM controlled by "w"
led_dimmer_TB.v -> See the wave for the increasing duty cycle 
led_dimmer_TEST.v -> Module that combines led_dimmer and Led_mux. External button increments "w" by one which 
				increases the brightness of the seven-segment. The value of "w" is displayed on the seven-segments.
Led_mux.v -> Module for seven-segment time-multiplexing circuit.
led_dimmer_TEST.ucf -> Constraint file for led_dimmer_TEST.v

Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.


TASK:
4.7.2 PWM and LED dimmer

The duty cycle of a square wave is defined as the percentage of the on interval (i.e., logic 1)
in a period. A PWM (pulse width modulation) circuit can generate an output with variable
duty cycles. For a PWM with 4-bit resolution, a 4-bit control signal, w, specifies the duty
cycle. The w signal is interpreted as an unsigned integer and the duty cycle is w/16.

1. Design a PWM circuit with 4-bit resolution and verify its operation using a logic
analyzer or oscilloscope.
2. Modify the LED time-multiplexing circuit to include the PWM circuit for the an
signal. The PWM circuit specifies the percentage of time that the LED display is
on. We can control the perceived brightness by changing the duty cycle. Verify the
circuit's operation by observing 1 bit of an on a logic analyzer or oscilloscope.
3. Replace the LED time-multiplexing circuit of Listing 4.19 with the new design and
use the lower 4 bits of the 8-bit switch to control the duty cycle. Verify operation of
the circuit. It may be necessary to go to a dark area to see the effect of dimming. 