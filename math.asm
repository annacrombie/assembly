%include        'functions.asm'

section .data
	a: dd 8
	b: dd 4
	aeq: dd "a = ", 0h
	beq: dd "b = ", 0h
	msg1: dd "(a*b) - ( (a+b) / (a-b) ) = ", 0h
	diverror: dw "error, division by zero"
	segment .bss
	z: resd 1
	x: resd 1
	y: resd 1
	d: resd 1
	f: resd 1


section .text
global main

main:
	mov eax, [a]
	mov ebx, [b]
	sub eax, ebx
	jz zeroError
	mov [z], eax

	mov eax, [a]
	mul ebx
	mov [x], eax

	mov eax, [a]
	add eax, ebx
	mov [y], eax

	mov eax, [y]
	mov ebx, [z]
	div ebx
	mov [d], eax

	mov eax, [x]
	mov ebx, [d]
	sub eax, ebx
	mov [f], eax

	mov eax, aeq
	call sprint
	mov eax, [a]
	call iprintLF

	mov eax, beq
	call sprint
	mov eax, [b]
	call iprintLF

	mov eax, msg1
	call sprint
	mov eax, [f]
	call iprintLF
	call quit

zeroError:
	mov eax, diverror
	call sprintLF
	call quit
