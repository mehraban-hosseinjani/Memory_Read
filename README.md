# Memory Read FSM
This module implements a Finite State Machine (FSM) for managing memory read operations. The FSM transitions through five key states to complete the task of fetching, decoding, and reading data from memory.

**FSM States**
1.**FETCH (S0)**: Fetch the instruction from memory.
2.**DECODE (S1)**: Decode the fetched instruction.
3.**MEM_ADR (S2)**: Calculate the effective memory address.
4.**MEM_READ (S3)**: Read data from the memory.
5.**MEM_WB (S4)**: Write the data to the target register.

**Inputs and Outputs**
.**Inputs:**
.**clk**: Clock signal to synchronize FSM transitions.
.**reset**: Resets the FSM to the initial FETCH state.
.**Op**: Specifies the operation type (e.g., memory read).
.**Func**: Identifies specific instructions like LDR.

.**Outputs:**
.**AdrSrc**, **ALUSrcA**, **ALUSrcB**: Control signals for address selection and ALU inputs.
.**ALUOp**: Defines the type of ALU operation.
.**ResultSrc**: Controls the source of the result written to registers.
.**IRWrite**, **NextPC**, **RegWrite**: Control signals for updating instruction registers, program counter (PC), and general-purpose registers.
.**MemRead**: Activates memory read operations.

**Simulation Results
**
The following figures demonstrate the simulation results of the FSM in operation.
Log of Simulation Results
The table below displays the state (State) and signal values (AdrSrc, ALUSrcA, MemRead, etc.) over time.
![Screenshot 2024-12-04 160408](https://github.com/user-attachments/assets/3039ae00-ea46-4b25-ba3d-6b3299659bbd)
Each state transition can be clearly observed, showing the correct signal activations for the FETCH, DECODE, MEM_ADR, MEM_READ, and MEM_WB states.


**Waveform of FSM Signals
**The waveform illustrates the timing and behavior of the FSM signals during the simulation. Each state transition and corresponding signal adjustment is visible, synchronized with the clock signal (clk).
![Screenshot 2024-12-04 161023](https://github.com/user-attachments/assets/b7560287-46d5-4a73-8018-3801cb0dbbe6)

Highlights:

.The FSM transitions sequentially through all states.
.Signals like MemRead and RegWrite are asserted at the appropriate states (MEM_READ and MEM_WB, respectively).


**The Memory Read FSM is functioning as expected, with accurate state transitions and correct activation of control signals at each stage. The simulation results confirm that the module successfully performs the memory read operation.

If you would like further elaboration on any state or signal behavior, or suggestions for enhancements, feel free to ask!**
