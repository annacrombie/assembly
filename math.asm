 ;%include "along32.inc"

SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1


section .data
	a dw 100 ; value for a
	b dw 200 ; value for b
	msg db "A*B-(A+B)/(A-B): "
   	len equ $ - msg
	segment .bss
	x resb 1
	y resb 1
	z resb 1
section .text

global main

main:
	mov eax, '5'
	sub eax, '0'
	mov ebx, '6'
	sub ebx, '0'
	add eax, ebx
	mov [x], eax

	mov ecx, msg
	mov edx, len
	mov ebx, 1
	mov eax, 4
	int 0x80

	mov ecx, x
	mov edx, 1
	mov ebx, 1
	mov eax, 4
	int 0x80

	mov eax,1	;system call number (sys_exit)
   	int 0x80
