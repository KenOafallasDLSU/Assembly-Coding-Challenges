; Kenneth Neil B. Oafallas
; DNA Reverse Complement

global _main
extern _printf, _scanf, _system, _gets, _getchar

section .data
strInput times 18 db 0
strReverse times 18 db 0
strChar times 3 db 0

promptDNA db "DNA String: ",0
promptAgain db "Do you want to try again [y/n]? ",0

formScan db "%s",0
formRevComp db "Reverse complement: %s",13,10,0
formRevYes db "Reverse palindrome? Yes",13,10,0
formRevNo db "Reverse palindrome? No",13,10,0

errNull db "Error: Null input",13,10,0
errMax db "Error: Beyond maximum length",13,10,0
errInvalid db "Error: Invalid input",13,10,0
errNoTerm db "Error: Invalid or no terminator",13,10,0
errTry db "Please try again.",13,10,0

clrscr db "cls",0

section .text
_main:
    PUSH clrscr
    CALL _system
    ADD ESP, 4
    
PromptDNA:
    LEA ESI,[strInput]
    LEA EDI,[strReverse]
    
    PUSH promptDNA
    CALL _printf
    ADD ESP, 4
    
    PUSH strInput
    ;PUSH formScan
    ;CALL _scanf
    ;ADD ESP, 8
    CALL _gets
    ADD ESP, 4

XOR ECX, ECX ;set count to 0
XOR EBX, EBX ;set secondary count to 0    
CheckValidInput:
    MOV AL, [ESI + ECX]
    CMP AL, 0
    JNE NotNull
        CMP ECX, 0
        JE ErrorNull
        JMP ErrorNoTerm
    NotNull:
    CMP AL, "."
    JNE NotEmpty
        CMP ECX, 0
        JE ErrorNull
        JMP GetReverse
    
    NotEmpty:
    CMP ECX, 0xF
    JGE ErrorMax
    
    CMP AL, "A"
    JE GoodInput
    CMP AL, "C"
    JE GoodInput
    CMP AL, "G"
    JE GoodInput
    CMP AL, "T"
    JE GoodInput
    JMP ErrorInvalid
    
    GoodInput:    
    INC ECX
    JMP CheckValidInput

    ErrorNull:
        PUSH errNull
        CALL _printf
        ADD ESP, 4
        JMP Error
    ErrorMax:
        PUSH errMax
        CALL _printf
        ADD ESP, 4
        JMP Error
    ErrorInvalid:
        PUSH errInvalid
        CALL _printf
        ADD ESP, 4
        JMP Error
    ErrorNoTerm:
        PUSH errNoTerm
        CALL _printf
        ADD ESP, 4
    Error:
        PUSH errTry
        CALL _printf
        ADD ESP, 4
        JMP PromptDNA
      
GetReverse:
    JECXZ PrintRevComp
    MOV AL, [ESI + EBX]
    MOV [EDI + ECX - 1], AL
    INC EBX
    LOOP GetReverse
    MOV [EDI + EBX], byte 0 ;prev string might be longer
GetComplement:
    MOV AL, [EDI + ECX]
    CMP AL, 0
    JE PrintRevComp
    CMP AL, "A"
    JNE CtoG
    MOV [EDI + ECX], byte "T"
    JMP NextComp
    CtoG:
    CMP AL, "C"
    JNE GtoC
    MOV [EDI + ECX], byte "G"
    JMP NextComp
    GtoC:
    CMP AL, "G"
    JNE TtoA
    MOV [EDI + ECX], byte "C"
    JMP NextComp
    TtoA:
    MOV [EDI + ECX], byte "A"
    
    NextComp:
    INC ECX
    JMP GetComplement   

PrintRevComp:    
    PUSH strReverse
    PUSH formRevComp
    CALL _printf
    ADD ESP, 8
CheckEqual:
    MOV AL, [ESI]
    MOV AH, [EDI]
    CMP AL, "."
    JE PrintYes
    CMP AL, AH
    JNE PrintNo
    INC ESI
    INC EDI
    JMP CheckEqual
    
PrintYes:
    PUSH formRevYes
    CALL _printf
    ADD ESP, 4
    JMP PromptAgain
PrintNo:
    PUSH formRevNo
    CALL _printf
    ADD ESP, 4
    
PromptAgain:
    LEA ESI,[strChar]
    PUSH promptAgain
    CALL _printf
    ADD ESP, 4
    
    PUSH strChar
    PUSH formScan
    CALL _scanf
    ADD ESP, 8
    ;CALL _gets
    ;ADD ESP, 4
    CALL _getchar
    
    MOV AL, [ESI]
    CMP AL, "y"
    JE PromptDNA
    
    xor eax, eax
    ret