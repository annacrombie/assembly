%include    'along32.inc'

section .data
	prompt: dd "> "
	m1: dd "enter a 32-bit hex number"
section .text

global main

main:
	mov edx, m1
	call WriteString
	call Crlf
	mov edx, prompt
	call WriteString
	call ReadHex
	call WriteHex
	call Crlf
	call quit


quit:
    mov ebx, 0                      ; return 0 status on exit - 'No Errors'
    mov eax, 1                      ; invoke SYS_EXIT (kernel opcode 1)
    int 80h                         ; request an interrupt on libc using INT 80h.
    ret
