%include    'along32.inc'

section .data
	msg1: dd "input newline delimited integers", 0h
	msg2: dd "when done input 0 to compute average", 0h
	msg3: dd "int #", 0h
	msg4: dd " > ", 0h
	msg5: dd "average of ", 0h
	msg6: dd " integers, with a sum value of ", 0h
	msg7: dd ": ", 0h
	msg8: dd "error, no input supplied", 0h
	lnfd: db 10, 0h

section .text

global main

main:
	mov edx, msg1                   ; put msg1 into edx for printing
	call WriteString                ; print the message
	call printLF                    ; print a newline

	mov edx, msg2                   ; put msg2 into edx for printing
	call WriteString                ; print the message
	call printLF                    ; print a newline

	mov ecx, 0                      ; set ecx to 0 (counter)
	mov ebx, 0                      ; set ebx to 0 (sum)

sumLoop:
	mov edx, msg3                   ; put msg3 into edx for printing
	call WriteString                ; print the message

	mov eax, ecx                    ; move ecx into eax for printing
	call WriteInt                   ; print the integer

	mov edx, msg4                   ; put msg4 into edx for printing
	call WriteString                ; print the message

	call ReadInt                    ; read an integer from standard in
	add ebx, eax                    ; add that integer to ebx
	cmp eax, 0                      ; compare the read integer to 0
	je average                      ; if they are equal, jump to average label

	add ecx, 1                      ; if they are not equal, add 1 to the counter (ecx)
	jmp sumLoop                     ; jump back to the beginning of this loop

average:
	cmp ecx, 0                      ; compare the counter to zero to see if an average can be calculated
	jz noinputerror                 ; if the counter is zero, jump to an error

	mov edx, msg5                   ; put msg5 into edx for printing
	call WriteString                ; write string

	mov eax, ecx                    ; move ecx (counter) to eax for writing
	call WriteInt                   ; write eax

	mov edx, msg6                   ; put msg6 into edx for printing
	call WriteString                ; write string

	mov eax, ebx                    ; move ebx (sum) into eax
	call WriteInt                   ; write eax

	mov edx, msg7                   ; put msg7 into edx for printing
	call WriteString                ; write string

	xor edx, edx                    ; clear the bits of edx

	mov ebx, ecx                    ; mov ecx (counter) into ebx  (now eax contains the sum and ebx contains the counter)
	div ebx                         ; divide eax by ebx
	call printLF                    ; print a new line
	call WriteInt                   ; write the int stored in eax (from division)
	call printLF                    ; print a new line
	call quit                       ; quit the program

noinputerror:
	mov edx, msg8                   ; put msg8 into edx for printing
	call WriteString                ; write string
	call printLF                    ; print a new line
	call quit                       ; quit the program
	ret

printLF:                            ; prints a linefeed character
    push edx
    mov edx, lnfd                   ; put the characters into the edx register to be printed by WriteString
    call WriteString                ; call WriteString from the along32 library
    pop edx
    ret

quit:
    mov ebx, 0                      ; return 0 status on exit - 'No Errors'
    mov eax, 1                      ; invoke SYS_EXIT (kernel opcode 1)
    int 80h                         ; request an interrupt on libc using INT 80h.
    ret