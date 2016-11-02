%include 'along32.inc'    ; include along32

section .data
    prompt:  dd "> ", 0
    ini_msg: dd "enter N integers to be sorted", 0
    noData: dd "error, no data entered", 0
    tooMuch: dd "error, too much data entered", 0

section .text

global main

main:
	xor esi, esi             ; ensure that esi is zero

readLoop:
	mov edx, prompt          ; move the prompt string into edx
	call WriteString         ; write the prompt string
	call ReadInt             ; read in a 32 bit integer

	jz beforeSort            ; if the integer is zero, jump out of the read loop
	push eax                 ; if the integer is not zero, store the integer on the stack
	inc esi                  ; increment esi
	jmp readLoop             ; keep looping

beforeSort:
	cmp esi, 0
	je noDataError

	sub esi, 2               ; subtract 2 from the counter to prevent basically an index out of range error

whileSort:
	xor edx, edx             ; zero the edx register
	xor edi, edi             ; zero the edi register

	forAllInStack:                   ; for i=0; do
		mov ebx, [esp+4*edi]     ; store the first value in ebx
		mov eax, [esp+4+4*edi]   ; store the second vavlue in eax

		cmp ebx, eax     ; compare ebx and eax
		jle endIf        ; keep them in order if ebx is less than or equal to eax (they are already sorted)
		jmp ifSwap       ; swap them otherwise

		ifSwap:
			mov [esp+4+4*edi], ebx
			mov [esp+4*edi], eax
			inc edx
		endIf:

		inc edi
		cmp edi, esi
		jle forAllInStack

	cmp edx, 0                ; compare edx with zero (to see if it was incremented during the for loop e.g. a sort operation happened)
	jne whileSort             ; if it is not zero, then recheck the stack

	add esi, 2           ; correct the counter so that the correct number of elements will be printed
printStack:
	pop eax
	call WriteInt
	call Crlf
	sub esi, 1
	jnz printStack

	call quit


quit:
    mov ebx, 0               ; return 0 status on exit - 'No Errors'
    mov eax, 1               ; invoke SYS_EXIT (kernel opcode 1)
    int 80h                  ; request an interrupt on libc using INT 80h.
    ret

noDataError:
	mov edx, noData
	call WriteString
	call Crlf
	call quit

tooMuchError:
	mov edx, tooMuch
	call WriteString
	call Crlf
	call quit

