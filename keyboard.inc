ConfigKeyboard PROC
    MOV  AX, 3509h    ; DOS.GetInterruptVector
    INT  21h          ; -> ES:BX
    MOV INT09_ES, ES
    MOV INT09_BX, BX      

    mov  dx, offset Int09
    PUSH DS
    MOV AX,CS
    MOV DS,AX
    mov  ax, 2509h         ; DOS.SetInterruptVector
    int  21h
    POP DS

    RET
ConfigKeyboard ENDP

ResetKeyboard PROC
    push ds 
    push dx
    mov dx,INT09_BX
    MOV DS,INT09_ES

    mov  ax, 2509h         ; DOS.SetInterruptVector
    int  21h

    pop DX
    pop ds

    RET
ResetKeyboard ENDP


Int09 PROC

    push ax bx
    in   al, 60h
    mov  ah, 0
    mov  bx, ax
    and  bx, 127           ; 7-bit scancode goes to BX
    shl  ax, 1             ; 1-bit press/release goes to AH
    xor  ah, 1             ; -> AH=1 Press, AH=0 Release
    mov  [KeyList+bx], ah
    mov  al, 20h           ; The non specific EOI (End Of Interrupt)
    out  20h, al
    pop  bx ax
    iret

Int09 ENDP