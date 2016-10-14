%include    'along32.inc'                        ; include along32 library

section .data
    aeq: dd "input int a >$ ", 0h                ; input prompt for a variable
    beq: dd "input int b >$ ", 0h                ; input prompt for b variable
    msg1: dd "(a*b) - ( (a+b) / (a-b) ) = ", 0h  ; final answer message
    linefeed:  db 10, 0h                         ; linefeed for putting at the end of strings
    diverror: dw "error, division by zero", 0h   ; division by zero error message

    segment .bss                                 ; all variables to be used in computation

    a: resd 1
    b: resd 1
    z: resd 1
    x: resd 1
    y: resd 1
    d: resd 1
    f: resd 1

section .text

global main

main:
    mov edx, aeq                                 ; put the message into the edx register to be printed by WriteString
    call WriteString                             ; call WriteString from the along32 library

    call ReadInt                                 ; call ReadInt from the along32 library
    mov [a], eax                                 ; store the read integer in a

    mov edx, beq                                 ; put the message into the edx register to be printed by WriteString
    call WriteString                             ; call WriteString from the along32 library

    call ReadInt                                 ; call ReadInt from the along32 library
    mov [b], eax                                 ; store the read integer in b

    mov eax, [a]                                 ; move value of a into eax register
    mov ebx, [b]                                 ; move value of b into ebx register
    sub eax, ebx                                 ; subtract b from a
    jz zeroError                                 ; if the difference is zero then jump to zeroError
    mov [z], eax                                 ; store the difference in z

    mov eax, [a]                                 ; move the value of a into the eax register
    mul ebx                                      ; multiply eax by ebx
    mov [x], eax                                 ; store the product into x

    mov eax, [a]                                 ; move the value of a into the eax register
    add eax, ebx                                 ; add eax and ebx
    mov [y], eax                                 ; store the sum in y

    mov eax, [y]                                 ; move the value of y into the eax register
    mov ebx, [z]                                 ; move the value of z into the ebx register
    div ebx                                      ; divide eax by ebx
    mov [d], eax                                 ; store the quotient in d (disregarding the remainder)

    mov eax, [x]                                 ; move the value of x into the eax register
    mov ebx, [d]                                 ; move the value of d into the ebx register
    sub eax, ebx                                 ; subtract ebx from eax
    mov [f], eax                                 ; store the difference in f

    mov edx, msg1                                ; put the message into the edx register to be printed by WriteString
    call WriteString                             ; call WriteString from the along32 library
    mov eax, [f]                                 ; put the integer into the eax register to be printed by WriteInt
    call WriteInt                                ; call WriteInt from the along32 library
    call printLF                                 ; print a linefeed character

    call quit                                    ; exit the program

zeroError:                                       ; displays a divide by zero error message
    mov edx, diverror                            ; put the message into the edx register to be printed by WriteString
    call WriteString                             ; call WriteString from the along32 library
    call printLF                                 ; print a linefeed character
    call quit                                    ; exit the program
    ret

printLF:                                         ; prints a linefeed character
    mov edx, linefeed                            ; put the characters into the edx register to be printed by WriteString
    call WriteString                             ; call WriteString from the along32 library
    ret             

quit:             
    mov ebx, 0                                   ; return 0 status on exit - 'No Errors'
    mov eax, 1                                   ; invoke SYS_EXIT (kernel opcode 1)
    int 80h                                      ; request an interrupt on libc using INT 80h.
    ret
