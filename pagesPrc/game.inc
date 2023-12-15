MainLoop PROC

    CHECK_TIME:
    Mov AH, 2CH
    INT 21H

    CMP DL, TIME_AUX
    JE CHECK_TIME

    ;If it is different, draw and move
    MOV TIME_AUX, DL

    ; call setBackgroundColor

    call moveSquares
    CALL VALIDATE
    CALL VALIDATE2

    CALL ClearSqr

    CALL PowerUps
    CALL CheckEndPower

   
    ;CALL VALIDATE3
    CALL DrawPowers
    CALL drawSquares
    JMP CHECK_TIME
    
MainLoop ENDP

VALL PROC
    MOV CX,squareX
    MOV BX,CX
    ADD BX,squareLength

    MOV DX,squareY
    MOV DI,DX
    ADD DI,squareLength

    OUTLOP:
    MOV CX,squareX
    INLOP:
        MOV AH,0DH 
        INT 10H
        CMP AL,42H
        JNZ CHECKCOLOR
        INC CX
        CMP CX,BX
        JNZ INLOP  
    INC DX
    CMP DX,DI
    JNZ OUTLOP
    RET
VALL ENDP

CHECKCOLOR PROC
    MOV VAL,0
    MOV CX,500
    MOV DX,500
    RET
CHECKCOLOR ENDP


PowerUps PROC

    CMP powercnt,0
    jz ENDPOWER

    MOV SI, powerrow
    MOV DX,squareX2
    MOV CX,squareY2
    MOV DI,DX  
    ADD DI,squareLength
    MOV BX,CX  
    ADD BX,squareLength

    ;check if player one passed through powerup
    CMP SI,DX
    JC P2

    CMP SI,DI
    JNC P2

    MOV SI, powercol

    CMP SI,CX
    JC P2

    CMP SI,BX
    JNC P2

    INC secpower
    DEC powercnt
    JMP ENDPOWER

    P2:
    MOV SI, powerrow

    MOV DX,squareX
    MOV CX,squareY
    MOV DI,DX  
    ADD DI,squareLength
    MOV BX,CX  
    ADD BX,squareLength

    ;check if player one passed through powerup
    CMP SI,DX
    JC ENDPOWER

    CMP SI,DI
    JNC ENDPOWER

    MOV SI, powercol

    CMP SI,CX
    JC ENDPOWER

    CMP SI,BX
    JNC ENDPOWER

    INC firpower
    DEC powercnt
    
    ENDPOWER:    
    RET
PowerUps ENDP

CheckEndPower PROC

    MOV AH,2CH  
    INT 21H  

    CMP USEPWR,1
    JNE CHECKSEC

    cmp dh,starttime
    jz CHECKSEC

    mov starttime,dh


    inc counter
    cmp counter,duration
    JNZ CHECKSEC

    mov counter,0
    MOV speed1,2
    INC powercnt
    DEC USEPWR

    CALL RANDPOS

    CHECKSEC:
    CMP USEPWR2,1
    JNE ENDD

    cmp dh,starttime
    jz ENDD
    mov starttime,dh

    
    inc counter
    cmp counter,duration
    JNZ ENDD

    MOV speed2,2
    INC powercnt
    DEC USEPWR2

    
    CALL RANDPOS


    ENDD:
    RET
CheckEndPower ENDP

drawSquares PROC 
    ;Draw square1
    mov cx, squareY         ;Column
    mov dx, squareX         ;Row
    mov al,fircolor             ;Pixel color
    mov ah,0ch              ;Draw Pixel Command
    _Horizontalx: 
    int 10h
    INC CX
    MOV BX, CX
    SUB BX, squareY
    CMP BX, squareLength
    JNZ _Horizontalx

    MOV CX, squareY
    INC DX
    MOV BX, DX
    SUB BX, squareX
    CMP BX, squareLength
    JNZ _Horizontalx

    ;Draw square2
    mov cx, squareY2        ;Column
    mov dx, squareX2        ;Row
    mov al,seccolor            ;Pixel color
    mov ah,0ch              ;Draw Pixel Command
    Horizontal2: int 10h
    INC CX
    MOV BX, CX
    SUB BX, squareY2
    CMP BX, squareLength
    JNZ Horizontal2

    MOV CX, squareY2
    INC DX
    MOV BX, DX
    SUB BX, squareX2
    CMP BX, squareLength
    JNZ Horizontal2
    RET
drawSquares ENDP

ClearSqr PROC
    mov cx, PreY         ;Column
    mov dx, PreX         ;Row
    mov al,color             ;Pixel color
    mov ah,0ch              ;Draw Pixel Command
    Horizontall: int 10h
    INC CX
    MOV BX, CX
    SUB BX, PreY
    CMP BX, squareLength
    JNZ Horizontall

    MOV CX, PreY
    INC DX
    MOV BX, DX
    SUB BX, PreX
    CMP BX, squareLength
    JNZ Horizontall

    ;Draw square2
    mov cx, PreY2        ;Column
    mov dx, PreX2        ;Row
    mov al,color            ;Pixel color
    mov ah,0ch              ;Draw Pixel Command
    Horizontal22: int 10h
    INC CX
    MOV BX, CX
    SUB BX, PreY2
    CMP BX, squareLength
    JNZ Horizontal22

    MOV CX, PreY2
    INC DX
    MOV BX, DX
    SUB BX, PreX2
    CMP BX, squareLength
    JNZ Horizontal22
    RET
ClearSqr ENDP

;Move Squares
moveSquares PROC

    MOV AX,speed1
    MOV BX,squareX
    MOV PreX,BX
    MOV BX,squareY
    MOV PreY,BX

    checkUp:    
    ;if 'w' is pressed, move up
    CMP [KeyList + w], 1
    JNE checkDown
    SUB squareX,AX
    MOV MovingSQR,1

    checkDown:
    ;if 's' is pressed, move down
    CMP [KeyList + s], 1
    JNE checkRight
    ADD squareX,AX
    MOV MovingSQR,1

    checkRight:
    ;if 'd' is pressed, move right
    CMP [KeyList + d], 1
    JNE checkLeft
    ADD squareY,AX
    MOV MovingSQR,1

    ;if 'a' is pressed, move left
    checkLeft:
    CMP [KeyList + a], 1
    JNE CheckPower
    SUB squareY,AX
    MOV MovingSQR,1


    CheckPower:
    CMP [KeyList+ q],1
    JNE check_car2_movement

    CMP firpower,0
    JE check_car2_movement
    DEC firpower

    INC USEPWR
    CALL SETTIMER
    ADD speed1,upSpeed

    check_car2_movement:
    MOV AX,speed2
    MOV BX,squareX2
    MOV PreX2,BX
    MOV BX,squareY2
    MOV PreY2,BX

    ;if 'upArrow' is pressed, move up
    CMP [KeyList + upArrow], 1
    JNE checkDown2
    SUB squareX2,AX
    MOV MovingSQR,2

    checkDown2:
    ;if 'downArrow' is pressed, move down
    CMP [KeyList + downArrow], 1
    JNE checkRight2
    ADD squareX2,AX
    MOV MovingSQR,2

    checkRight2:
    ;if 'rightArrow' is pressed, move right
    CMP [KeyList + rightArrow], 1
    JNE checkLeft2
    ADD squareY2,AX
    MOV MovingSQR,2

    checkLeft2:
    ;if 'leftArrow' is pressed, move left
    CMP [KeyList + leftArrow], 1
    JNE CheckPower2
    SUB squareY2,AX
    MOV MovingSQR,2

    CheckPower2:
    CMP [KeyList + p], 1
    JE bridge
    jmp ExitProc
    bridge:
    CMP secpower,0
    JE ExitProc
    DEC secpower
    INC USEPWR2
    CALL SETTIMER
    ADD speed2,3

    ExitProc:
    RET
moveSquares ENDP

VALIDATE    PROC
    MOV DX,squareX
    MOV CX,squareY
    CALL VALIDROW
    CALL VALIDCOL
    MOV squareX,DX
    MOV squareY,CX

    MOV DX,squareX2
    MOV CX,squareY2
    CALL VALIDROW
    CALL VALIDCOL
    MOV squareX2,DX
    MOV squareY2,CX

    RET
VALIDATE ENDP

VALIDATE2 PROC
    MOV DX,squareX
    MOV CX,squareX2
    
    CMP DX,CX
    JNC BIGGER
    MOV DI,CX
    SUB DI,DX

    CMP DI,squareLength
    JZ SKIP
    JNC SKIP

    MOV AX,squareLength
    SUB AX,DI
    MOV DI,AX
    
    CMP MovingSQR,1
    JNZ SEC
    SUB DX,DI 
    JMP NX
    SEC:
    ADD CX,DI
    NX:

    JMP NEXT
BIGGER:
    MOV DI,DX
    SUB DI,CX

    CMP DI,squareLength
    JZ SKIP
    JNC SKIP
    MOV AX,squareLength
    SUB AX,DI
    MOV DI,AX
    CMP MovingSQR,1
    JNZ SEC2
    ADD DX,DI 
    JMP NX2
    SEC2:
    SUB CX,DI
    NX2:
NEXT:

    MOV BX,squareY
    MOV AX,squareY2

    CMP BX,AX
    JNC BIGGER2
    MOV DI,AX
    SUB DI,BX

    JMP NEXT2
BIGGER2:
    MOV DI,BX
    SUB DI,AX
NEXT2:
    
    CMP DI,squareLength
    JZ SKIP
    JNC SKIP

    MOV squareX,DX
    MOV squareX2,CX

SKIP:
    RET
VALIDATE2 ENDP

sleepSomeTime proc 
    push cx dx
    mov cx, 0
    mov dx, 20000  ; 20ms
    mov ah, 86h
    int 15h  ; param is cx:dx (in microseconds)
    pop dx cx
    ret
sleepSomeTime endp

RANDPOS PROC
    CMP DH,30
    JNC OTHER
    MOV BL,6
    MOV AL,DH
    MUL BL 
    MOV powerrow,AX
    MOV AL,DL
    MUL BL 
    MOV powercol,AX
    JMP DONE
    OTHER:
    MOV BL,3
    MOV AL,DH
    MUL BL 
    MOV powerrow,AX
    MOV AL,DL
    MUL BL 
    MOV powercol,AX
    DONE:
    RET
RANDPOS ENDP

SETTIMER  PROC
    PUSH CX
    PUSH DX
    MOV AH,2CH
    INT 21H
    MOV starttime,DH
    MOV endtime,DH
    ADD endtime,5
    CMP endtime,60
    JNC FIX
    JMP FIN
FIX:
    SUB endtime,60
FIN:
    POP DX
    POP CX
    RET
SETTIMER ENDP

DrawPowers   PROC
    ;draw power
    CMP powercnt,0
    JZ ENDdraw
    MOV DX,powerrow
    MOV CX,powercol
    MOV AL,powercolor
    
    MOV DI,DX 
    ADD DI,4
    
    MOV BX,CX
    ADD BX,4
    
    MOV AH,0CH
    
LOPSEC: 
    LOPSEC2:
        INT 10H
        INC DX
        CMP DX,DI
        JNZ LOPSEC2  
    MOV DX,DI
    SUB DX,4
    INC CX
    CMP CX,BX
    JNZ LOPSEC 

ENDdraw:
    RET
DrawPowers ENDP

VALIDROW PROC
    CMP DX,1
    JNL N1
    MOV DX,0
    N1:
    CMP DX,SCREEN_HEIGHT - squareLength
    JNA N2
    MOV DX,SCREEN_HEIGHT - squareLength
    N2:
    
    RET
VALIDROW ENDP

VALIDCOL PROC
    CMP CX,1
    JNL N11
    MOV CX,0
    N11:
    CMP CX,SCREEN_WIDTH - squareLength
    JNA N22
    MOV CX,SCREEN_WIDTH - squareLength
    N22:
    RET
VALIDCOL ENDP
