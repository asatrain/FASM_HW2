; Asatryan Emin Variant 4

format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        intFormat db '%d', 0
        space db ' ', 0
        newLine db '', 10, 0
        enterNText db 'Enter N: ', 0
        AElementText db 'A[%d] = ', 0
        printArrayBText db 'Array B: ', 0
        BElementText db 'B[%d] = ', 0
        incorrectNText db 'Incorrect N', 0

        N dd ?
        A dd ?
        B dd ?
        i dd ?
        heapSize dd ?

        NULL = 0

section '.code' code readable executable

start:
        call readArrayA
        call createAndFillArrayB
        call writeArrayB

finish:
        call [getch]
        push NULL
        call [ExitProcess]

proc readArrayA

readN:
        invoke printf, enterNText
        add esp, 4
        invoke scanf, intFormat, N
        add esp, 4 * 2
        mov eax, [N]
        cmp eax, 0
        jg createArrayA

        invoke printf, incorrectNText
        add esp, 4
        jmp finish

createArrayA:
        call [GetProcessHeap]
        mov [A], eax
        mov eax, [N]
        imul eax, 4
        mov [heapSize], eax
        invoke HeapAlloc, [A], 0, [heapSize]
        mov [A], eax

        mov [i], 0
        mov ebx, [A]

readArrayALoop:
        mov eax, [i]
        cmp eax, [N]
        jge readArrayALoopEnd

        invoke printf, AElementText, [i]
        add esp, 4 * 2
        invoke scanf, intFormat, ebx
        add esp, 4 * 2
        inc [i]
        add ebx, 4
        jmp readArrayALoop

readArrayALoopEnd:
        ret
endp

proc createAndFillArrayB

createArrayB:
        call [GetProcessHeap]
        mov [B], eax
        invoke HeapAlloc, [B], 0, [heapSize]
        mov [B], eax

        mov [i], -1
        mov ebx, [B]
        add ebx, -4
        mov edx, [A]
        add edx, -4

fillArrayBLoop:
        inc [i]
        add ebx, 4
        add edx, 4

        mov eax, [i]
        cmp eax, [N]
        jge fillArrayBLoopEnd

        mov eax, [edx]
        cmp eax, 0
        jg elenemtAIsGteater
        jl elenemtAIsLess

        mov eax, 0
        mov [ebx], eax
        jmp fillArrayBLoop

elenemtAIsGteater:
        mov eax, 1
        mov [ebx], eax
        jmp fillArrayBLoop

elenemtAIsLess:
        mov eax, -1
        mov [ebx], eax
        jmp fillArrayBLoop

fillArrayBLoopEnd:
        ret

endp

proc writeArrayB
        invoke printf, printArrayBText
        invoke printf, newLine
        add esp, 4 * 2

        mov [i], 0
        mov ebx, [B]

writeArrayBLoop:
        mov eax, [i]
        cmp eax, [N]
        jge writeArrayBLoopEnd

        invoke printf, BElementText, [i]
        invoke printf, intFormat, [ebx]
        invoke printf, space
        invoke printf, newLine
        add esp, 4 * 6

        inc [i]
        add ebx, 4
        jmp writeArrayBLoop

writeArrayBLoopEnd:
        ret

endp

section '.idata' import data readable

library kernel, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'

import kernel,\
       ExitProcess, 'ExitProcess',\
       HeapAlloc, 'HeapAlloc',\
       GetProcessHeap, 'GetProcessHeap'

import msvcrt,\
       printf, 'printf',\
       scanf, 'scanf',\
       getch, '_getch'