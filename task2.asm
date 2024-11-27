section .data
    prompt db "Enter a single digit (0-9): ", 0       ; Message asking the user for input
    prompt_len equ $ - prompt                          ; Length of the prompt string
    newline db 10                                     ; Newline character for formatting output
    invalid_input_msg db "Invalid input! Please enter a digit (0-9).", 0  ; Error message for invalid input
    invalid_input_len equ $ - invalid_input_msg       ; Length of the invalid input message

section .bss
    array resb 5    ; Reserve 5 bytes to store 5 digits
    input resb 2    ; Reserve 2 bytes for user input (1 digit + newline)

section .text
    global _start

_start:
    ; Initialize index for storing digits in the array (r12 will be used as a counter)
    xor r12, r12    ; Clear r12 (set it to 0) to serve as the array index (0 to 4)

input_loop:
    ; Print the prompt message to the user
    mov rax, 1      ; sys_write system call (1 = write to stdout)
    mov rdi, 1      ; File descriptor for stdout (1 = standard output)
    mov rsi, prompt ; Address of the prompt string
    mov rdx, prompt_len  ; Length of the prompt message
    syscall         ; Call the system to print the prompt

    ; Read the user's input
    mov rax, 0      ; sys_read system call (0 = read from stdin)
    mov rdi, 0      ; File descriptor for stdin (0 = standard input)
    mov rsi, input  ; Address of the input buffer
    mov rdx, 2      ; Read 2 bytes (1 for the character and 1 for the newline)
    syscall         ; Call the system to read input

    ; Check if the input is a valid digit (0-9)
    mov al, [input]      ; Load the input character into the al register
    cmp al, '0'          ; Compare the input with ASCII value of '0'
    jl invalid_input     ; If input < '0', jump to invalid input handling
    cmp al, '9'          ; Compare the input with ASCII value of '9'
    jg invalid_input     ; If input > '9', jump to invalid input handling

    ; Store the valid input character in the array at the current index
    mov [array + r12], al    ; Store the digit at position r12 in the array
    inc r12                  ; Increment the index (r12) to point to the next position

    ; Check if we have collected 5 digits
    cmp r12, 5
    jl input_loop          ; If less than 5 digits, continue the input loop

    ; Reverse the array in place using two pointers (left and right)
    mov r12, 0      ; Set left index (r12) to 0
    mov r13, 4      ; Set right index (r13) to 4 (last element of the array)

reverse_loop:
    ; Exit the loop if left index (r12) >= right index (r13)
    cmp r12, r13
    jge print_array  ; If the indices have crossed, go to the print array step

    ; Swap elements at r12 (left) and r13 (right)
    mov al, [array + r12]    ; Load the left element into al register
    mov bl, [array + r13]    ; Load the right element into bl register

    ; Store swapped elements back into the array
    mov [array + r12], bl    ; Store the right element (bl) at the left index (r12)
    mov [array + r13], al    ; Store the left element (al) at the right index (r13)

    ; Move indices towards each other (increment left index, decrement right index)
    inc r12                  ; Move the left index (r12) to the right
    dec r13                  ; Move the right index (r13) to the left

    ; Repeat the loop until the indices meet or cross
    jmp reverse_loop         ; Continue the reversal process

print_array:
    ; Print the reversed array of digits
    mov r12, 0              ; Reset the index to 0 for printing

print_loop:
    ; Load the character from the array at the current index (r12)
    mov al, [array + r12]
    mov [input], al         ; Store it in the input buffer for printing

    ; Print the character (1 byte at a time)
    mov rax, 1              ; sys_write system call (1 = write to stdout)
    mov rdi, 1              ; File descriptor for stdout
    mov rsi, input          ; Address of the input buffer
    mov rdx, 1              ; Print 1 byte (1 character)
    syscall                 ; Call the system to print the character

    ; Print a newline after each character
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Increment the index and check if all 5 characters have been printed
    inc r12
    cmp r12, 5
    jl print_loop           ; Continue printing if there are more characters

exit:
    ; Exit the program successfully
    mov rax, 60            ; sys_exit system call (60 = exit)
    xor rdi, rdi           ; Exit status 0 (successful)
    syscall                 ; Call the system to exit the program

invalid_input:
    ; Print error message for invalid input
    mov rax, 1             ; sys_write system call (1 = write to stdout)
    mov rdi, 1             ; File descriptor for stdout
    mov rsi, invalid_input_msg
    mov rdx, invalid_input_len
    syscall

    ; Restart the input loop after printing the error message
    jmp input_loop
