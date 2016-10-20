%include    'along32.inc'

section .data
	prompt: dd "> ", 0
	m1: dd "enter a 32-bit hex number", 0
	lsb_msg: dd "least significant bit positioned at ", 0
	msb_msg: dd "most significant bit positioned at ", 0
	bts_msg: dd " bits set", 0
segment .bss
	msb: resd 1
	lsb: resd 1

section .text

global main

main:
	mov edx, m1		; move the message string into edx
	call WriteString	; write the message string
	call Crlf		; print a newline
	mov edx, prompt		; move the prompt string into edx
	call WriteString	; write the prompt string

	call ReadHex		; read a 32-bit hexadecimal number into eax


	mov ebx, 31		; ebx is the current bit index counter, it starts at 31 because we are looping from left to right
	mov edx, 0		; edx is the significant bit counter, it starts at 0

	jmp bitLoop		; jump to the bitLoop

significantBitFound:
	inc edx			; increment edx (significant bit counter)

	mov [lsb], ebx		; set least significant bit location to the current bit index

        cmp byte [msb], 0	; check if most significant bit is already set
        jne bitLoopLower	; if it is, jump back to the bitloop

	mov [msb], ebx		; set most significant bit to the current bit index

	jmp bitLoopLower	; return to the bitloop

bitLoop:
	xor ecx, ecx		; clear ecx
	shl eax, 1		; shift eax left by one
	adc ecx, 0		; add the carry value (whatever was removed from eax) to 0 and store it in ecx
	jnz significantBitFound	; if the carry value + 0 is not zero (it is 1), jump to the significan bit found portion

bitLoopLower:
	sub ebx, 1		; subtract one from ebx
	jnz bitLoop		; if ebx is not zero, loop

	; print out the determined bit positions

	push edx

	mov edx, msb_msg
	call WriteString
	mov eax, [msb]
	call WriteInt
	call Crlf

	mov edx, lsb_msg
	call WriteString
	mov eax, [lsb]
        call WriteInt
        call Crlf

	pop edx

	mov eax, edx
	call WriteInt
	mov edx, bts_msg
	call WriteString
	call Crlf

	call quit

quit:
    mov ebx, 0                      ; return 0 status on exit - 'No Errors'
    mov eax, 1                      ; invoke SYS_EXIT (kernel opcode 1)
    int 80h                         ; request an interrupt on libc using INT 80h.
    ret
