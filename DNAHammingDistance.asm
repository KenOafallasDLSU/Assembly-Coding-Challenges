; Kenneth Neil B. Oafallas 
; DNA Hamming Distance

%include "io.inc"

section .data
REFERENCE db "GATATATGCATATACTT",0
READSTR db "ATAT",0
;REFERENCE db "TTTTTTTTTTTTTT", 0
;READSTR db "TTTAAA", 0
;REFERENCE db "AAAAAGGGGGAAGGAAAGGA", 0
;READSTR db "AAAAAG", 0
;REFERENCE db "GOMIABGXMXASGOMI", 0
;READSTR db "SGOXX", 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    
    ;count run
    ;initialization
    LEA ESI, [REFERENCE]
    LEA EDI, [READSTR]
    
    XOR AL, AL      ;Found Counter
    
OuterStart:
    XOR AH, AH      ;Distance Counter
    XOR EDX, EDX    ;Place Counter
    
InnerStart:
    ;get query str char
    XOR EBX, EBX
    MOV BL, [EDI + EDX]
    CMP BL, 0
    JE IncFoundCount
    
    ;get ref char
    XOR EBX, EBX    ;char container
    MOV BL, [ESI + EDX]
    CMP BL, 0
    JE ExitOuter
    
    CMP BL, [EDI + EDX]; BL is ref char, Mem is query str char
    JNE IncHamDist     ;increase hamming distance when not same char
    JMP Continue
    
IncHamDist:
    INC AH
    CMP AH, 0x02
    JG ExitInner        ;if HD is greater than 2, fail and move to next pair
    JMP Continue
    
Continue:
    INC EDX
    JMP InnerStart

IncFoundCount:
    INC AL    
ExitInner:
    INC ESI
    JMP OuterStart
    
ExitOuter:
    PRINT_STRING "Count: "
    PRINT_DEC 1, AL    
    NEWLINE
    
    ;Positions Run
    ;reset registers
    LEA ESI, [REFERENCE]
    LEA EDI, [READSTR]
    
    XOR ECX, ECX        ;Position tracker for printing
    XOR AL, AL          ;Found Counter

    PRINT_STRING "Positions found: "
    
OuterStart2:
    XOR AH, AH          ;Distance Counter
    XOR EDX, EDX        ;Place Counter
    
InnerStart2:
    ;get query str char
    XOR EBX, EBX
    MOV BL, [EDI + EDX]
    CMP BL, 0
    JE IncFoundCount2
    
    ;get ref char
    XOR EBX, EBX
    MOV BL, [ESI + EDX]
    CMP BL, 0
    JE ExitOuter2
    
    CMP BL, [EDI + EDX]    ; BL is ref char, Mem is query str char
    JNE IncHamDist2         ;increase hamming distance when not same char
    JMP Continue2
    
IncHamDist2:
    INC AH
    CMP AH, 0x02
    JG ExitInner2
    JMP Continue2
    
Continue2:
    INC EDX
    JMP InnerStart2

IncFoundCount2:
    INC AL
    CMP AL, 0x01
    JE PrintPos
    PRINT_STRING ","
    PrintPos:
        PRINT_DEC 4, ECX
ExitInner2:
    INC ECX 
    INC ESI
    JMP OuterStart2
    
ExitOuter2:
    CMP AL, 0x00
    JNE Exit   
    PRINT_STRING "none"
Exit:    
    xor eax, eax
    ret