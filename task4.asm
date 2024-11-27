global _start

section .data
    sensor_value    dd 0        ; Variable to hold sensor input value
    motor_status    db 0        ; Motor status: 0 = OFF, 1 = ON
    alarm_status    db 0        ; Alarm status: 0 = OFF, 1 = ON

    HIGH_LEVEL      equ 80      ; Threshold for high sensor level
    MODERATE_LEVEL  equ 50      ; Threshold for moderate sensor level

    prompt          db 'Enter sensor value: ', 0
    input_buffer    db 10 dup(0) ; Input buffer to store user input
    motor_msg       db 'Motor Status: ', 0
    alarm_msg       db 'Alarm Status: ', 0
    on_msg          db 'ON', 10, 0   ; Message for ON status
    off_msg         db 'OFF', 10, 0  ; Message for OFF status

section .bss
    ; No uninitialized data in this program

section .text
_start:
    ; Print prompt message to request sensor value input
    mov     rax, 1                  ; sys_write system call
    mov     rdi, 1                  ; File descriptor for stdout
    mov     rsi, prompt             ; Message to be printed
    mov     rdx, 20                 ; Length of the message
    syscall

    ; Read user input from stdin
    mov     rax, 0                  ; sys_read system call
    mov     rdi, 0                  ; File descriptor for stdin
    mov     rsi, input_buffer       ; Buffer to store input
    mov     rdx, 10                 ; Maximum number of bytes to read
    syscall

    ; Convert ASCII input to integer value
    mov     rsi, input_buffer       ; Pass the input buffer for conversion
    call    atoi                    ; The result will be in RAX

    ; Store the sensor value in memory
    mov     [sensor_value], eax

    ; Retrieve the sensor value
    mov     eax, [sensor_value]

    ; Compare the sensor value against predefined thresholds
    cmp     eax, HIGH_LEVEL
    jg      high_level              ; Jump to high level section if greater

    cmp     eax, MODERATE_LEVEL
    jg      moderate_level          ; Jump to moderate level section if greater

low_level:
    ; Low level: Turn motor ON, Turn alarm OFF
    mov     byte [motor_status], 1  ; Set motor status to ON
    mov     byte [alarm_status], 0  ; Set alarm status to OFF
    jmp     display_status          ; Jump to display the status

moderate_level:
    ; Moderate level: Turn motor OFF, Turn alarm OFF
    mov     byte [motor_status], 0  ; Set motor status to OFF
    mov     byte [alarm_status], 0  ; Set alarm status to OFF
    jmp     display_status          ; Jump to display the status

high_level:
    ; High level: Turn motor ON, Turn alarm ON
    mov     byte [motor_status], 1  ; Set motor status to ON
    mov     byte [alarm_status], 1  ; Set alarm status to ON

display_status:
    ; Display motor status message
    mov     eax, 4                  ; sys_write system call
    mov     ebx, 1                  ; File descriptor for stdout
    mov     ecx, motor_msg          ; Motor status message
    mov     edx, 14                 ; Length of the message
    int     0x80

    ; Check motor status and display ON/OFF message
    mov     al, [motor_status]
    cmp     al, 1                   ; Compare motor status (ON/OFF)
    je      motor_on                ; Jump to motor_on if ON
    jmp     motor_off               ; Jump to motor_off if OFF

motor_on:
    ; Output motor ON status
    mov     eax, 4                  ; sys_write system call
    mov     ebx, 1                  ; File descriptor for stdout
    mov     ecx, on_msg             ; Message for ON status
    mov     edx, 3                  ; Length of the ON message
    int     0x80
    jmp     display_alarm           ; Jump to display alarm status

motor_off:
    ; Output motor OFF status
    mov     eax, 4                  ; sys_write system call
    mov     ebx, 1                  ; File descriptor for stdout
    mov     ecx, off_msg            ; Message for OFF status
    mov     edx, 4                  ; Length of the OFF message
    int     0x80

display_alarm:
    ; Display alarm status message
    mov     eax, 4                  ; sys_write system call
    mov     ebx, 1                  ; File descriptor for stdout
    mov     ecx, alarm_msg          ; Alarm status message
    mov     edx, 13                 ; Length of the message
    int     0x80

    ; Check alarm status and display ON/OFF message
    mov     al, [alarm_status]
    cmp     al, 1                   ; Compare alarm status (ON/OFF)
    je      alarm_on                ; Jump to alarm_on if ON
    jmp     alarm_off               ; Jump to alarm_off if OFF

alarm_on:
    ; Output alarm ON status
    mov     eax, 4                  ; sys_write system call
    mov     ebx, 1                  ; File descriptor for stdout
    mov     ecx, on_msg             ; Message for ON status
    mov     edx, 3                  ; Length of the ON message
    int     0x80
    jmp     exit_program            ; Jump to program exit

alarm_off:
    ; Output alarm OFF status
    mov     eax, 4                  ; sys_write system call
    mov     ebx, 1                  ; File descriptor for stdout
    mov     ecx, off_msg            ; Message for OFF status
    mov     edx, 4                  ; Length of the OFF message
    int     0x80

exit_program:
    ; Exit the program gracefully
    mov     eax, 1                  ; sys_exit system call
    xor     ebx, ebx                ; Return 0 status code
    int     0x80

; Subroutine: ASCII to Integer Conversion (atoi)
atoi:
    xor     rax, rax                ; Clear RAX (result register)
    xor     rcx, rcx                ; Clear RCX (multiplier register)
    mov     rcx, 10                 ; Set multiplier to 10

atoi_loop:
    movzx   rdx, byte [rsi]         ; Load next character from input buffer
    cmp     rdx, 10                 ; Check for newline character
    je      atoi_done               ; If newline, end conversion
    sub     rdx, '0'                ; Convert ASCII to digit (char '0' = 48)
    imul    rax, rcx                ; Multiply current result by 10
    add     rax, rdx                ; Add digit to result
    inc     rsi                     ; Move to the next character in buffer
    jmp     atoi_loop               ; Repeat loop

atoi_done:
    ret
