 
global _start

section .data
    prompt          db 'Enter a number: ', 0
    positive_msg    db 'The number is POSITIVE', 10, 0
    negative_msg    db 'The number is NEGATIVE', 10, 0
    zero_msg        db 'The number is ZERO', 10, 0
    input_buffer    db 10 dup(0)

section .bss
    ; Uninitialized data section (not used in this program)

section .text
_start:
    ; Print the prompt
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; stdout
    mov     ecx, prompt
    mov     edx, 15             ; Length of the prompt (without null terminator)
    int     0x80

    ; Read user input
    mov     eax, 3              ; sys_read
    mov     ebx, 0              ; stdin
    mov     ecx, input_buffer
    mov     edx, 10             ; Max number of bytes to read
    int     0x80

    ; Convert input string to integer
    mov     esi, input_buffer
    call    atoi                ; Result in EAX

    ; Compare EAX to zero
    cmp     eax, 0
    je      output_zero         ; Jump if equal to zero
    jl      output_negative     ; Jump if less than zero
    ; If greater than zero, fall through to positive case

output_positive:
    ; Output "POSITIVE" message
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; stdout
    mov     ecx, positive_msg
    mov     edx, 23             ; Length of the message
    int     0x80
    jmp     exit_program        ; Exit after displaying message

output_negative:
    ; Output "NEGATIVE" message
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; stdout
    mov     ecx, negative_msg
    mov     edx, 23
    int     0x80
    jmp     exit_program        ; Exit after displaying message

output_zero:
    ; Output "ZERO" message
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; stdout
    mov     ecx, zero_msg
    mov     edx, 19
    int     0x80

exit_program:
    ; Exit the program
    mov     eax, 1              ; sys_exit
    xor     ebx, ebx
    int     0x80

; Subroutine: ASCII to Integer Conversion (atoi)
atoi:
    ; Convert the ASCII string at ESI to an integer in EAX
    xor     eax, eax            ; Clear EAX (result)
    xor     ebx, ebx            ; Clear EBX (sign flag)
    ; ECX is used as a temporary register for the digit value

atoi_loop:
    lodsb                       ; Load byte at [ESI] into AL and increment ESI
    cmp     al, 0x0A            ; Check for newline (Enter key)
    je      atoi_done           ; Exit loop if newline is found
    cmp     al, 0x00            ; Check for null terminator
    je      atoi_done           ; Exit loop if null terminator is found
    cmp     al, '-'             ; Check for a minus sign
    jne     atoi_digit_check    ; If not '-', check for digit
    inc     ebx                 ; Mark as negative if '-' is found
    jmp     atoi_loop           ; Continue loop

atoi_digit_check:
    cmp     al, '0'             ; Check if character is less than '0'
    jl      atoi_done           ; If less, exit
    cmp     al, '9'             ; Check if character is greater than '9'
    jg      atoi_done           ; If greater, exit
    sub     al, '0'             ; Convert ASCII to numeric value
    imul    eax, 10             ; Multiply current result by 10
    movzx   ecx, al             ; Move digit value into ECX (zero-extend)
    add     eax, ecx            ; Add digit value to EAX
    jmp     atoi_loop           ; Continue loop

atoi_done:
    test    ebx, ebx            ; Check if the number is negative
    jz      atoi_end            ; If not negative, skip negation
    neg     eax                 ; Negate the result if negative

atoi_end:
    ret
