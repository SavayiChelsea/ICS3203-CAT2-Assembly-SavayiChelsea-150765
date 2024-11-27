section .data
    prompt          db 'Enter a number (0-12): ', 0  ; Prompt the user to input a number between 0 and 12
    result_msg      db 'Factorial is: ', 0            ; Message to indicate the result
    newline         db 10, 0                           ; Newline character for formatting output
    input_buffer    db 10 dup(0)                       ; Reserve 10 bytes for the input buffer
    result_buffer   db 20 dup(0)                       ; Reserve 20 bytes for the result output buffer

section .bss
    ; No uninitialized data is needed for this program

section .text
global _start

_start:
    ; Display the input prompt to the user
    mov     rax, 1                  ; sys_write system call number
    mov     rdi, 1                  ; File descriptor 1 for stdout
    mov     rsi, prompt             ; Address of the prompt string
    mov     rdx, 22                 ; Length of the prompt string
    syscall

    ; Read user input from stdin
    mov     rax, 0                  ; sys_read system call number
    mov     rdi, 0                  ; File descriptor 0 for stdin
    mov     rsi, input_buffer       ; Address of the input buffer
    mov     rdx, 10                 ; Maximum size of input (10 bytes)
    syscall

    ; Convert the input string to an integer (atoi)
    mov     rsi, input_buffer       ; Address of the input buffer
    call    atoi                    ; Convert input to integer, result in RAX

    ; Validate if the input is between 0 and 12
    cmp     rax, 12                 ; Check if input > 12
    ja      invalid_input           ; If input is greater than 12, go to invalid_input
    cmp     rax, 0                  ; Check if input < 0
    jl      invalid_input           ; If input is less than 0, go to invalid_input

    ; Compute the factorial of the input number
    push    rax                     ; Push the input number onto the stack
    call    factorial               ; Call factorial subroutine, result in RAX
    add     rsp, 8                  ; Clean up the stack (remove input number)

    ; Convert the factorial result to a string (itoa)
    mov     rsi, result_buffer      ; Address of the result buffer
    call    itoa                    ; Convert the result to ASCII string

    ; Display the result message
    mov     rax, 1                  ; sys_write system call number
    mov     rdi, 1                  ; File descriptor 1 for stdout
    mov     rsi, result_msg         ; Address of the result message
    mov     rdx, 14                 ; Length of the result message
    syscall

    ; Display the computed factorial result
    mov     rax, 1                  ; sys_write system call number
    mov     rdi, 1                  ; File descriptor 1 for stdout
    mov     rsi, result_buffer      ; Address of the result buffer
    mov     rdx, 20                 ; Maximum length for the result output
    syscall

    ; Print a newline character after the result
    mov     rax, 1                  ; sys_write system call number
    mov     rdi, 1                  ; File descriptor 1 for stdout
    mov     rsi, newline            ; Address of newline character
    mov     rdx, 1                  ; Length of newline character
    syscall

    ; Exit the program successfully
    mov     rax, 60                 ; sys_exit system call number
    xor     rdi, rdi                ; Exit status code 0 (success)
    syscall

invalid_input:
    ; Print error message for invalid input
    mov     rax, 1                  ; sys_write system call number
    mov     rdi, 1                  ; File descriptor 1 for stdout
    mov     rsi, newline            ; Address of the error message
    mov     rdx, 22                 ; Length of the error message
    syscall

    ; Exit the program with status 0 (success) after invalid input
    mov     rax, 60                 ; sys_exit system call number
    xor     rdi, rdi                ; Exit status code 0
    syscall

; Subroutine: Factorial Calculation (factorial)
factorial:
    mov     rbx, 1                  ; Initialize result in RBX to 1
    cmp     rax, 0                  ; Check if input is 0
    je      factorial_end           ; If input is 0, return 1 (factorial of 0)
factorial_loop:
    imul    rbx, rax                ; Multiply RBX by RAX (RBX = RBX * RAX)
    dec     rax                     ; Decrement RAX (move to next number)
    jnz     factorial_loop          ; Continue looping if RAX is not zero
factorial_end:
    mov     rax, rbx                ; Return the factorial result in RAX
    ret

; Subroutine: ASCII to Integer Conversion (atoi)
atoi:
    xor     rax, rax                ; Clear RAX to prepare for the result
    xor     rcx, rcx                ; Clear RCX (multiplier for base 10)
    mov     rcx, 10                 ; Set base to 10 for decimal conversion

atoi_loop:
    movzx   rdx, byte [rsi]         ; Load next character from input buffer
    cmp     rdx, 10                 ; Check for newline character (ASCII 10)
    je      atoi_done               ; If newline, end the loop
    sub     rdx, '0'                ; Convert ASCII character to digit (e.g., '5' -> 5)
    imul    rax, rcx                ; Multiply current result by 10
    add     rax, rdx                ; Add the digit to the result
    inc     rsi                     ; Move to the next character
    jmp     atoi_loop               ; Continue loop

atoi_done:
    ret

; Subroutine: Integer to ASCII Conversion (itoa)
itoa:
    xor     rcx, rcx                ; Clear RCX, which will count the number of digits
itoa_loop:
    xor     rdx, rdx                ; Clear RDX for division remainder
    mov     rbx, 10                 ; Set divisor to 10 for base 10 conversion
    div     rbx                     ; Divide RAX by 10, quotient in RAX, remainder in RDX
    add     dl, '0'                 ; Convert remainder (digit) to ASCII
    push    rdx                     ; Push digit onto the stack
    inc     rcx                     ; Increment digit counter
    test    rax, rax                ; Check if RAX is zero (end of number)
    jnz     itoa_loop               ; Repeat loop if RAX is not zero

itoa_pop:
    pop     rdx                     ; Pop digit from stack
    mov     [rsi], dl               ; Store digit in result buffer
    inc     rsi                     ; Move to the next position in buffer
    loop    itoa_pop                ; Loop until all digits are popped

    mov     byte [rsi], 0           ; Null-terminate the string
    ret
