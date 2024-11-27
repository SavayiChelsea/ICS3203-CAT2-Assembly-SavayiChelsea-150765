# ICS3203-CAT2-Assembly-SavayiChelsea-150765

## Overview TASK 1
This program prompts the user to input a number and classifies it as "POSITIVE," "NEGATIVE," or "ZERO." It demonstrates the use of control flow and conditional logic in assembly language using conditional and unconditional jumps.

## Compiling and Running the Code
1. Ensure you have an assembler (e.g., NASM) and linker installed.
2. Compile the program using the following command:
   ```bash
   nasm -f elf64 code_4.asm -o code_4.o
   ```
3. Link the object file to create an executable:
   ```bash
   ld code_4.o -o code_4
   ```
4. Run the executable:
   ```bash
   ./code_4
   ```

## Insights and Challenges
### Insights:
- **Conditional Jumps**: Instructions like `JE` (jump if equal) and `JL` (jump if less) were used to classify the number efficiently. These instructions improve program readability and ensure logical branching.
- **Unconditional Jumps**: The `JMP` instruction allowed seamless flow transitions, bypassing unnecessary checks after a condition was met.
- **Assembly Language**: Working with assembly enhanced my understanding of low-level operations, especially regarding data movement between memory and registers.

### Challenges:
- **Register Management**: Ensuring proper usage and preservation of registers during branching required careful planning.
- **Debugging**: Identifying logical errors in jump conditions and flow control in assembly was more challenging compared to high-level programming.
- **Logic Flow**: Designing the branching logic to ensure the program handled all inputs accurately took several iterations to perfect.

## Program Flow Summary
1. **Input Handling**: The program waits for the user to input a number.
2. **Logic Implementation**:
   - Compares the input to `0` using the `CMP` instruction.
   - Jumps to:
     - The "ZERO" label if the input is `0`.
     - The "POSITIVE" label if the input is greater than `0`.
     - The "NEGATIVE" label if the input is less than `0`.
3. **Output**: Displays the appropriate classification based on the input.
4. **Exit**: The program terminates cleanly after displaying the result.

## TASK 2: Array Manipulation with Looping and Reversal

### Overview
This program accepts an array of integers (five single digits, 0-9) from the user, reverses the array in place, and outputs the reversed array. It demonstrates the use of loops for input handling and array reversal without additional memory allocation.

---

### Assembly Code

#### Sections
1. **`.data` Section**:
   - Defines static data like strings for prompts and messages.
   - `newline` is used for formatting outputs.
   - The `invalid_input_msg` helps handle invalid inputs.

2. **`.bss` Section**:
   - Reserves uninitialized memory for the array and input buffer.

3. **`.text` Section**:
   - Contains the program logic:
     - Input handling loop.
     - Array reversal logic using two pointers.
     - Final output loop.

#### Compilation and Execution
1. **Compile the program**:
   ```bash
   nasm -f elf64 array_reverse.asm -o array_reverse.o
   ```
2. **Link the object file**:
   ```bash
   ld array_reverse.o -o array_reverse
   ```
3. **Run the program**:
   ```bash
   ./array_reverse
   ```

### Insights and Challenges
#### Insights:
- **Input Validation**: The program ensures the input is a valid digit (0-9) before storing it in the array, enhancing robustness.
- **Memory Management**: Reversing the array in place required careful use of memory pointers without exceeding bounds.
- **Looping Logic**: The use of loops for input collection, reversal, and output simplifies the flow and ensures no unnecessary operations.

#### Challenges:
1. **Memory Handling**: 
   - Accessing array elements via indices required careful calculation to avoid out-of-bounds errors.
   - The lack of automatic bounds checking in assembly makes managing array size manually essential.
2. **Reversal Logic**: 
   - Swapping elements in place without auxiliary memory required precise use of registers (`r12` and `r13`) to hold the indices for swapping.
3. **Error Handling**: 
   - Managing invalid inputs and redirecting to the input loop added complexity but ensured proper functionality.

---

### Program Flow
#### Input Handling:
1. Prompts the user to enter a single digit.
2. Validates that the input is a digit between 0-9.
3. Stores valid input in the array at the current index.
4. Repeats until 5 digits are entered.

#### Array Reversal:
1. Two indices (`r12` for the left and `r13` for the right) are initialized to the start and end of the array, respectively.
2. Swaps the values at the left and right indices.
3. Increments the left index and decrements the right index.
4. Continues until the left index meets or exceeds the right index.

#### Output:
1. Loops through the array after reversal.
2. Prints each character followed by a newline.

---

### Challenges with Memory Handling
1. **Index Management**: Careful tracking of left and right indices during reversal was necessary to avoid overwriting memory or accessing out-of-bounds elements.
2. **Register Usage**: 
   - Efficiently using `r12` and `r13` as array indices to avoid modifying data unintentionally.
   - Temporary registers (`al` and `bl`) were used for swapping elements without corrupting memory.
3. **Debugging**:
   - Mistakes in swap logic or pointer arithmetic led to undefined behavior, requiring step-by-step debugging to resolve.

---

### Execution Example
#### Input:
```
Enter a single digit (0-9): 2
Enter a single digit (0-9): 4
Enter a single digit (0-9): 6
Enter a single digit (0-9): 8
Enter a single digit (0-9): 9
```

#### Output:
```
9
8
6
4
2
```

## TASK 3: Factorial Calculation Program

## Program Overview
This program calculates the factorial of a number input by the user (from 0 to 12). The program is modular, with the factorial calculation performed by a dedicated subroutine. The program uses registers to manage values and the stack to preserve important data, ensuring a clean, reusable, and efficient approach.

---

## Program Functionality

### 1. **Input Prompt and Validation**:
   - The program first prompts the user to enter a number between 0 and 12.
   - It checks if the entered number is within the valid range. If the number is invalid, an error message is displayed, and the program exits.

### 2. **Factorial Calculation**:
   - A subroutine is called to compute the factorial of the input number.
   - The factorial is computed iteratively by multiplying the input number by each of its decrements until reaching 1.
   - The result is stored in the `RBX` register and is then moved back to `RAX` for display.

### 3. **Result Conversion and Display**:
   - After the factorial is calculated, it is converted into an ASCII string format using an `itoa` subroutine.
   - The result is displayed to the user, followed by a newline.

### 4. **Modular Approach**:
   - The factorial calculation is separated into its own subroutine, which is called from the main program flow. This modular approach makes the program easier to manage, debug, and extend.
   - The program demonstrates proper stack usage, ensuring that registers are preserved and restored correctly.

---

## Program Components

### 1. **Factorial Calculation Subroutine**:
   - **Function**: Computes the factorial of the number using a loop.
   - **Registers**:
     - `RAX`: Holds the input number and is decremented during the loop.
     - `RBX`: Stores the result of the factorial calculation.
     - `RSP`: The stack pointer is used to save the original input before the calculation begins and restored afterward.
   - The subroutine multiplies `RAX` by the current result stored in `RBX` until `RAX` becomes 0.

### 2. **Input Conversion (ASCII to Integer)**:
   - **Function**: Converts the user input (ASCII characters) into an integer value.
   - **Registers**:
     - `RAX`: Holds the final integer result after conversion.
     - `RCX`: Used as a multiplier for place values (10^n).
     - `RDX`: Temporarily stores each character’s ASCII value during processing.
   - The program processes each character in the input buffer and converts it to its integer equivalent, multiplying the result by 10 each time a new digit is encountered.

### 3. **Integer to ASCII Conversion (itoa)**:
   - **Function**: Converts the factorial result from an integer to ASCII characters for display.
   - **Registers**:
     - `RAX`: Holds the integer to be converted.
     - `RCX`: Counter for the number of digits.
     - `RDX`: Temporarily stores the remainder (digit) during division.
   - The subroutine divides the number by 10, converts the remainder to a character, and stores the result in reverse order before popping the digits onto the result buffer.

---

## Stack and Register Management

### 1. **Preserving Registers**:
   - The program preserves the input number before calling the factorial subroutine by saving the value onto the stack (`PUSH rax`).
   - After the subroutine executes, the stack is cleaned up (`ADD rsp, 8`), restoring the register to its original state.

### 2. **Using the Stack**:
   - The stack is used to store intermediate data, such as the input value and digits during conversion.
   - This ensures that the main program flow and subroutines can operate independently, without the risk of corrupting data in registers.

### 3. **Modular Code Design**:
   - Each subroutine is designed to handle one specific task (factorial calculation, input conversion, result conversion).
   - This modular design improves code readability, maintainability, and reusability.

---

## Program Flow

1. The program begins by displaying a prompt asking the user to enter a number between 0 and 12.
2. The program reads the user input and converts it from ASCII to an integer.
3. It validates the input to ensure it's within the allowed range (0-12).
4. The factorial calculation is performed in the `factorial` subroutine.
5. The result is converted back into ASCII format using the `itoa` subroutine.
6. The result is displayed on the screen, followed by a newline.
7. If the input is invalid, an error message is displayed and the program exits.

---

## Example Output

```
Enter a number (0-12): 5
Factorial is: 120
```

---

## Conclusion

This program demonstrates the following:
- **Modular programming** by using subroutines to handle different tasks.
- **Efficient use of registers** and the **stack** for value preservation and register management.
- **ASCII and integer conversions** to handle user input and display results.

The use of subroutines not only makes the program more organized but also ensures that each part of the program has a single responsibility, promoting reusability and clarity.

---

## Key Instructions for Running

1. **Assembling the Program**:
   To assemble and run the program, use the following commands:
   ```
   nasm -f elf64 factorial.asm
   ld -o factorial factorial.o
   ./factorial
   ```

2. **Input**:
   - Enter a number between 0 and 12 when prompted.

3. **Output**:
   - The program will display the factorial of the entered number, or an error message if the input is invalid.

---

## Task 4: Sensor Control Simulation Program

The **Sensor Control Simulation** program simulates a simple control system for a water level sensor. The program reads the water level sensor value, determines the status of the motor and alarm, and then outputs the current states of these devices. The simulation checks if the water level is low, moderate, or high and performs different actions based on the sensor reading:

- **Low Water Level**: Turns the motor ON and keeps the alarm OFF.
- **Moderate Water Level**: Turns the motor OFF and keeps the alarm OFF.
- **High Water Level**: Turns the motor ON and triggers the alarm ON.

This program provides a simulated interface where the user inputs the sensor value, and the program reacts by controlling the motor and alarm statuses.

## Features

- Simulates a water level sensor input.
- Controls motor and alarm based on sensor input.
- Outputs the motor and alarm statuses.
- Handles three different water levels:
  - Low (Motor ON, Alarm OFF)
  - Moderate (Motor OFF, Alarm OFF)
  - High (Motor ON, Alarm ON)

## Program Flow

1. The program prompts the user for a sensor value input (water level).
2. It processes the sensor value and determines the corresponding action:
   - If the sensor value exceeds **80**, the water level is considered high.
   - If the sensor value exceeds **50**, but is less than or equal to 80, the water level is moderate.
   - If the sensor value is less than or equal to **50**, the water level is low.
3. The program updates the motor and alarm status based on the water level.
4. Finally, the program displays the current statuses of the motor and alarm.

## Installation and Requirements

To run this program, you need an assembly environment that supports x86-64 architecture.

1. **Assembler**: Use `nasm` to assemble the code.
2. **Linker**: Use `ld` to link the object files and create the executable.

### Installation Steps

1. Clone or download the repository containing the source code.
2. Open a terminal and navigate to the folder where the code is stored.
3. Assemble the code using `nasm`:
   ```bash
   nasm -f elf64 -o sensor_control.o sensor_control.asm
   ```
4. Link the object file to create the executable:
   ```bash
   ld -o sensor_control sensor_control.o
   ```
5. Run the executable:
   ```bash
   ./sensor_control
   ```

### Input

The program will prompt the user to **enter a sensor value** (an integer). The valid sensor values range from 0 to 100 (but any integer can be entered).

### Output

The program will display:
1. The current **motor status** (ON/OFF).
2. The current **alarm status** (ON/OFF).

## Code Explanation

### Key Sections of the Code

1. **Data Section**:
   - **sensor_value**: Stores the input value representing the water level sensor.
   - **motor_status**: Stores the status of the motor (0 = OFF, 1 = ON).
   - **alarm_status**: Stores the status of the alarm (0 = OFF, 1 = ON).
   - **HIGH_LEVEL** and **MODERATE_LEVEL**: Define the threshold values for high and moderate water levels.

2. **Text Section**:
   - The program starts by printing a prompt for the user to enter the sensor value.
   - After receiving input, the value is compared against the predefined threshold values (`HIGH_LEVEL`, `MODERATE_LEVEL`) to determine the action to take (motor and alarm status).
   - The results are displayed to the user.

3. **Subroutines**:
   - **atoi**: Converts ASCII input to an integer.
   - **itoa**: Converts the integer result to an ASCII string for displaying.

### Key Logic

- **Low Water Level**: Motor ON, Alarm OFF.
- **Moderate Water Level**: Motor OFF, Alarm OFF.
- **High Water Level**: Motor ON, Alarm ON.

## Example

### Sample Run:

```
Enter sensor value: 85
Motor Status: ON
Alarm Status: ON
```

In this example, the sensor value was 85, which is above the high-level threshold of 80, so both the motor and alarm were activated.

### Another Sample Run:

```
Enter sensor value: 45
Motor Status: ON
Alarm Status: OFF
```

In this case, the sensor value is 45, which is considered a low water level. Hence, the motor is ON, and the alarm is OFF.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
