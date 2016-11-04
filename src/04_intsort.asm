; Stone Tickle
; November 1, 2016
;
; this utility reads in N integers and then prints them sorted using a standard bubble sort method
; comment out lines 48 and 49 for full program funcionality (see revision 4)
;
; Revisions:
; 1 - Nov. 1: * began writing program
; 2 - Nov. 2: * changed push commands to mov commands with effective addresses, the program is functional
;             * organized comments and cleaned up code
; 3 - Nov. 3: * finalized all code except for error when too much data is entered
; 4 - Nov. 4: * added overflow trigger to comply with assignment.  there is now an error when too much data is entered

%include 'along32.inc'

section .data
    prompt:  dd "> ",                                                  0
    comma:   dd ", ",                                                  0
    ini_msg: dd "enter N integers to be sorted, terminated by a zero", 0
    noData:  dd "error, no data entered",                              0
    tooMuch: dd "error, too much data entered",                        0

    overflow_trigger dd 10         ; this is the number of integers that can be entered before an overflow error occurs

section .text

global main

main:
    mov edx, ini_msg               ; move the message string into edx
    call WriteString               ; write the message string
    call Crlf                      ; print a newline

readLoop:
    mov edx, prompt                ; move the prompt string into edx
    call WriteString               ; write the prompt string
    call ReadInt                   ; read in a 32 bit integer

    jz beforeSort                  ; if the integer is zero, jump out of the read loop
    push eax                       ; if the integer is not zero, store the integer on the stack
    inc esi                        ; increment esi
    jmp readLoop                   ; keep looping

beforeSort:
    cmp esi, 0                     ; check if the counter (esi) was not incremented (e.g. no data was entered other than zero)
    je noDataError                 ; if it was not, then print an error

    cmp esi, [overflow_trigger]    ; check if the counter (esi) was incremented above the overflow_trigger
    jge tooMuchError               ; if it was, then print an error

    sub esi, 2                     ; subtract 2 from the counter to prevent basically an index out of range error

whileSort:                         ; psudeocode ->  (while edx === 0:)
    xor edx, edx                   ; zero the edx register
    xor edi, edi                   ; zero the edi register

    forAllInStack:                 ; psudeocode -> (for i in stack:) (i is edi)
        mov ebx, [esp+4*edi]       ; store the first value in ebx    | the values are retrieved using effective addresses that
        mov eax, [esp+4+4*edi]     ; store the second vavlue in eax  | point to different elements on the stack.  since we are
                                   ;                                 | working with 32 bit numbers, each number is 4 bytes apart
                                   ;                                 | so we refrence the first number by [esp+4*i] and the second
                                   ;                                 | by [esp+4+4*i] (i in this case is edi)

        cmp ebx, eax               ; compare ebx and eax
        jle endIf                  ; keep them in order if ebx is less than or equal to eax (they are already sorted)
        jmp ifSwap                 ; swap them otherwise

        ifSwap:
            mov [esp+4+4*edi], ebx ; move the first bit into the second location
            mov [esp+4*edi],   eax ; move the second bit into the first location
            inc edx                ; increment edx, showing that a sort operation happened
        endIf:

        inc edi                    ; increment edi (i++ in psuedo code)
        cmp edi, esi               ; see if (edi <= esi)
        jle forAllInStack          ; if (edi <= esi) then keep looping

    cmp edx, 0                     ; compare edx with zero (to see if it was incremented during the for loop e.g. a sort operation happened)
    jne whileSort                  ; if it is not zero, then recheck the stack

    add esi, 1                     ; re-adjust the counter so that the correct number of elements will be printed
    mov edx, comma                 ; place the comma message into edx for writing

printStack:
    pop eax                        ; pop eax off the stack
    call WriteInt                  ; write it to stdout
    call WriteString               ; write the comma
    sub esi, 1                     ; subtract 1 from esi
    jnz printStack                 ; keep looping if esi isn't 0

    pop eax                        ; pop the last element off
    call WriteInt                  ; and print it without a trailing comma!

    call Crlf                      ; print a newline
    call quit                      ; quit the program

quit:
    mov ebx, 0                     ; return 0 status on exit - 'No Errors'
    mov eax, 1                     ; invoke SYS_EXIT (kernel opcode 1)
    int 80h                        ; request an interrupt on libc using INT 80h.
    ret

noDataError:                       ; display an error and quit
    mov edx, noData
    call WriteString
    call Crlf                     
    call quit

tooMuchError:                      ; display an error and quit
    mov edx, tooMuch
    call WriteString
    call Crlf
    call quit
