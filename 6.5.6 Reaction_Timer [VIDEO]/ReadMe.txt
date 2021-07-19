Created by: Angelo Jacobo 
Date: March 20,2021

Inside the src folder are:
reaction_timer.v -> Combines bin2bcd and LED_mux modules. "clr" forces it to go to initial state. When "start" is pressed, wait for the the LEDs to turn on
				(random-delay from 2s to 15s) then press "stop". Your reaction-time in seconds is displayed on the seven-segments.
bin2bcd.v -> The binary value of reaction-time is converted to bcd value to be used as input to the LED_mux module.
LED_mux.v -> Time-multiplexing module for the seven-segment-LEDs.
reaction_timer.ucf -> Constraint file for reaction_timer.v


Note: The constraint file is designed for Spartan 6 xc6slx9-2ftg256 FPGA (specifically the AX309 FPGA development board). Edit at your own risk.



TASK:
6.5.6 Reaction timer

Eye-hand coordination is the ability of the eyes and hands to work together to perform a
task. A reaction timer circuit measures how fast a human hand can respond after a person
sees a visual stimulus. This circuit operates as follows:

1. The circuit has three input pushbuttons, corresponding to the clear, start, and stop
	signals. It uses a single discrete LED as the visual stimulus and displays relevant
	information on the seven-segment LED display.
2. A user pushes the clear button to force the circuit to return to the initial state, in
	which the seven-segment LED shows a welcome message, "HI," and the stimulus
	LED is off.
3. When ready, the user pushes the start button to initiate the test. The seven-segment
	LED goes off.
4. After a random interval between 2 and 15 seconds, the stimulus LED goes on and
	the timer starts to count upward. The timer increases every millisecond and its value
	is displayed in the format of "0.000" second on the seven-segment LED.
5. After the stimulus LED goes on, the user should try to push the stop button as soon
	as possible. The timer pauses counting once the stop button is asserted. The seven- 
	segment LED shows the reaction time. It should be around 0.15 to 0.30 second for
most people.
6. If the stop button is not pushed, the timer stops after 1 second and displays "1.000".
7. If the stop button is pushed before the stimulus LED goes on, the circuit displays
	"9.999" on the seven-segment LED and stops.

Design the circuit as follows:
1. Derive the ASMD chart.
2. Derive the HDL code based on the ASMD chart.
3. Synthesize the circuit, program the FPGA, and verify its operation. 