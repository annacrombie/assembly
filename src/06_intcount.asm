; Stone Tickle
; November 4, 2016
;

%include 'along32.inc'

section .data
    prompt:  dd "> ",                                                      0
    ini_msg: dd "enter N integers to be sorted, terminated by two zeroes", 0
    positive:  dd "positive numbers: ",                                    0
    negative: dd "negative numbers: ",                                     0
    zero:    dd "zeroes: "

section .text

global main

main:
    mov edx, ini_msg               ; move the message string into edx
    call WriteString               ; write the message string
    call Crlf                      ; print a newline
    mov edx, prompt                ; move the prompt string into edx
    xor ebx, ebx
    xor ecx, ecx
    xor esi, esi

readLoop:
    call WriteString               ; write the prompt string
    call ReadInt                   ; read in a 32 bit integer
    compare:
        cmp eax, 0
        jl countNegative
        jg countPositive

    call WriteString
    call ReadInt
    jnz compare

    mov edx, positive
    call WriteString
    mov eax, ebx
    call WriteInt
    call Crlf

    mov edx, negative
    call WriteString
    mov eax, ecx
    call WriteInt
    call Crlf

    mov edx, zero
    call WriteString
    mov eax, esi
    call WriteInt
    call Crlf

    call quit                      ; quit the program

quit:
    mov ebx, 0
    mov eax, 1
    int 80h
    ret

countPositive:
    inc ebx
    jmp readLoop

countNegative:
    inc ecx
    jmp readLoop

countZero:
    inc esi
    jmp readLoop
