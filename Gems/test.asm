.MODEL SMALL
.STACK 64
.DATA

;Keyboard

KeyList db 128 dup(0)

FoundSpeedUp  db  0
FoundSpeedUp2  db  0

FoundSpeedDown  db  0
FoundSpeedDown2  db  0


OutTrack  db  0
OutTrackRow     dw  0
OutTrackCol    dw  0



PATH_LENGTH DB ?


PATH_EX_LENGTH DB 7 
PATH_EX DB 0,1,2,7,12,11,16
VAL     DB      1

MovingSQR   DB      0
powercnt    db      1       ;number of powerups on screen
SpeedUp    db      0      ;first player powerups
SpeedDown   db      0
SpeedUp2    db      0
SpeedDown2   db      0

UseSpeedUp      DB      0
UseSpeedDown    DB      0
UseSpeedUp2     DB      0
UseSpeedDown2    DB      0


powerrow    dw      50
powercol    dw      50

starttimeUP1   db      0
starttimeDOWN1   db      0

starttimeUP2   db      0
starttimeDOWN2   db      0


endtime     db      0
counterup1     db      0
counterup2     db      0
counterdown1     db      0
counterdown2     db      0

duration    equ     5


TIME_AUX DB 0

PreX    DW  0
PreY    DW  0

squareX DW 0
squareY DW 0

PreX2   DW  0
PreY2   DW  30

squareX2 DW 0
squareY2 DW 30

speed1 DW 3
speed2 DW 3

player1Keys DW 0
player2Keys DW 0


;Parameters
squareLength EQU 20
powerlength  EQU    5
fircolor    EQU  06H
seccolor    EQU 0ah
powercolor  EQU  01h
upSpeed EQU 3
downSpeed EQU 1

;Player1Keys
W EQU 11h
s EQU 1Fh
d EQU 20h
a EQU 1Eh
q EQU 10H
e EQU 12h
;-----------

;Player2Keys
upArrow     EQU     48H 
downArrow   EQU     50h
rightArrow  EQU     4DH
leftArrow   EQU     4BH
p           EQU     19H
o           EQU     18H
;-----------

VIDEO_MODE    EQU 4F02h                          
VIDEO_MODE_BX EQU 0101h       


;grid

x DW 0 
y DW 0

color db 0eh

SCREEN_WIDTH EQU 640
SCREEN_HEIGHT EQU 480

GRID_WIDTH EQU 5
GRID_HEIGHT EQU 5

START_COLUMN DW ?

CELL_W EQU SCREEN_WIDTH/GRID_WIDTH
CELL_H EQU SCREEN_HEIGHT/GRID_HEIGHT

PREV_SQUARE_1 db squareLength * squareLength dup(?)
PREV_SQUARE_2 db squareLength * squareLength dup(?)


.CODE

include pagesPrc/path.inc

drawSquare proc
    PUSH DI BX CX

    mov ax , x;
    mov bx,CELL_W
    mov dx,0
    mul bx
    mov cx,ax

    mov [START_COLUMN],CX

    mov ax, y;
    mov bx,CELL_H
    mov dx,0
    mul bx
    mov dx,ax

    MOV BX,CX
    ADD BX,CELL_W

    MOV DI,DX
    ADD DI,CELL_H

    MOV AX,DS
    MOV ES,AX

    MOV AH,0CH    
    DRAW_PIXELS:
        MOV AL,color
        INT 10H
        INC CX
        CMP CX,BX
        JNE DRAW_PIXELS

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE DRAW_PIXELS

    POP CX BX DI
    
    RET
drawSquare endp

MAIN    PROC    FAR
    MOV AX,@DATA
    MOV DS,AX

    MOV AH,0
    INT 16H

; CONFIGURING THE KEYBOARD

    MOV  AX, 3509h    ; DOS.GetInterruptVector
    INT  21h          ; -> ES:BX
    PUSH ES BX        

    mov  dx, offset Int09
    PUSH DS
    MOV AX,CS
    MOV DS,AX
    mov  ax, 2509h         ; DOS.SetInterruptVector
    int  21h
    POP DS


;SETTIGN THE VIDEO MODE
    MOV    AX,VIDEO_MODE
    MOV    BX,VIDEO_MODE_BX
    INT    10h                     ; Set video mode

    call drawPath

;THE ACTUAL GAME

    CALL DrawPowers

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
    CALL VALIDATE3
    CALL VALIDATE4


    CALL ClearSqr

    ; CALL PowerUps
    CALL CheckEndPower

    CALL drawSquares
    JMP CHECK_TIME
    
    pop  dx ds             ; (1)
    mov  ax, 2509h         ; DOS.SetInterruptVector
    int  21h

    mov  ax, 4C00h         ; DOS.Terminate
    int  21h
    RET
MAIN ENDP 


VALIDATE3 PROC
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
        CMP AL,color
        JE LABEL1  
        CMP AL,fircolor
        JE LABEL1
        CMP AL,04H
        JNZ CheckAgain
        mov FoundSpeedUp,1
        call ClearPwr

        CheckAgain:
        CMP AL,01H
        JNZ CheckAgain2  
        MOV FoundSpeedDown,1
        call ClearPwr
        CheckAgain2:
        
        ; CMP AL,0
        ; JNE CheckAgain2
        ; mov OutTrack,1
        ; cmp al,seccolor
        ; JNE CheckAgain3
        ; mov OutTrack,1

        ; CheckAgain3:

        LABEL1:
        ADD CX,1
        CMP CX,BX
        JNZ INLOP  
    ADD DX,1
    CMP DX,DI
    JNZ OUTLOP

    CMP FoundSpeedUp,1
    JNE SDown

    inc SpeedUp
    mov FoundSpeedUp,0

    ; outoftrack:
    ; cmp OutTrack,1
    ; JNE SDown
    ; mov dx,PreX
    ; mov squareX,dx
    ; mov dx,PreY
    ; mov squareY,dx
    ; mov OutTrack,0

    SDown:
    CMP FoundSpeedDown,1
    JNE nopower
    INC SpeedDown
    MOV FoundSpeedDown,0

    nopower:
    RET
    VALIDATE3 ENDP

VALIDATE4 PROC
    MOV CX,squareX2
    MOV BX,CX
    ADD BX,squareLength

    MOV DX,squareY2
    MOV DI,DX
    ADD DI,squareLength

    OUTLOPP:
    MOV CX,squareX2
    INLOPP:
        MOV AH,0DH 
        INT 10H
        CMP AL,color
        JE LABEL11  
        CMP AL,seccolor
        JE LABEL11
        CMP AL,04H
        JNZ CheckAgainn
        mov FoundSpeedUP2,1
        call ClearPwr

        CheckAgainn:
        CMP AL,01H
        JNZ CheckAgainn2  
        MOV FoundSpeedDown2,1
        call ClearPwr
        CheckAgainn2:
        
        ; CMP AL,0
        ; JNE CheckAgain2
        ; mov OutTrack,1
        ; cmp al,seccolor
        ; JNE CheckAgain3
        ; mov OutTrack,1

        ; CheckAgain3:

        LABEL11:
        ADD CX,1
        CMP CX,BX
        JNZ INLOPP 
    ADD DX,1
    CMP DX,DI
    JNZ OUTLOPP

    CMP FoundSpeedUp2,1
    JNE SDownn

    inc SpeedUp2
    mov FoundSpeedUp2,0

    ; outoftrack:
    ; cmp OutTrack,1
    ; JNE SDown
    ; mov dx,PreX
    ; mov squareX,dx
    ; mov dx,PreY
    ; mov squareY,dx
    ; mov OutTrack,0

    SDownn:
    CMP FoundSpeedDown2,1
    JNE nopowerr
    INC SpeedDown2
    MOV FoundSpeedDown2,0

    nopowerr:
    RET
    VALIDATE4 ENDP
; chngloc proc

; mov cx,OutTrackCol
; mov dx,OutTrackRow

; sub dx,speed1
; MOV AH,0DH 
; INT 10H
; cmp al,0
; JE below
; mov squareX,dx
; sub squareX,squareLength
; mov squareY,cx
; jmp finish
; below:
; add dx,speed1
; add dx,speed1
; MOV AH,0DH 
; INT 10H
; cmp al,0
; JE left
; mov squareX,dx
; mov squareY,cx
; jmp finish
; left:
; mov dx,OutTrackRow
; sub cx,speed1
; MOV AH,0DH 
; INT 10H
; cmp al,0
; JE right
; mov squareX,dx
; mov squareY,cx
; sub squareY,squareLength
; jmp finish
; right:
; add cx,speed1
; add cx,speed1
; MOV AH,0DH 
; INT 10H
; cmp al,0
; JE finish
; mov squareX,dx
; mov squareY,cx

; finish:
; ret
; chngloc endp


ClearPwr    proc
PUSH dx
PUSH CX
PUSH Ax
PUSH DI      
    MOV AL,color
    
    MOV DI,DX 
    ADD DI,powerlength
    sub dx,powerlength
    
    MOV BX,CX
    ADD BX,powerlength
    sub cx,powerlength
    
    MOV AH,0CH
    
LOPSECc: 
    LOPSECc2:
        INT 10H
        INC DX
        CMP DX,DI
        JNZ LOPSECc2  
    MOV DX,DI
    SUB DX,powerlength
    sub dx,powerlength
    INC CX
    CMP CX,BX
    JNZ LOPSECc 
    POP DI
    POP AX
    POP CX
    POP DX

ret
ClearPwr endp


setBackgroundColor PROC NEAR
    mov cx, 0           ;Column
    mov dx, 0           ;Row
    mov al, 42H        ;Pixel color
    mov ah, 0ch         ;Draw Pixel Command
Horizon: int 10h
    INC CX
    CMP CX, SCREEN_WIDTH
    JNZ Horizon

    MOV CX, 0
    INC DX
    CMP DX, SCREEN_HEIGHT
    JNZ Horizon
    RET
setBackgroundColor ENDP

PowerUps PROC
    ;check if there is power to claim
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

    INC SpeedUp2
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

    INC SpeedUp
    DEC powercnt
    
    ENDPOWER:

    
    RET
PowerUps ENDP



CheckEndPower PROC

    MOV AH,2CH  
    INT 21H  

    CMP UseSpeedUp,1
    JNE CHECKSEC

    cmp dh,starttimeUP1
    jz CHECKSEC

    mov starttimeUP1,dh


    inc counterup1
    cmp counterup1,duration
    JNZ CHECKSEC

    mov counterup1,0
    MOV speed1,3
    INC powercnt
    DEC UseSpeedUp

    CALL RANDPOS

    CHECKSEC:
    CMP UseSpeedUp2,1
    JNE CHECKSDOWN

    cmp dh,starttimeUP2
    jz ENDD
    mov starttimeUP2,dh

    
    inc counterup2
    cmp counterup2,duration
    JNZ CHECKSDOWN
    MOV counterup2,0
    MOV speed2,3
    INC powercnt
    DEC UseSpeedUp2
    CALL RANDPOS

    CHECKSDOWN:
    CMP UseSpeedDown,1
    JNE CHECKSDOWN2

    CMP DH,starttimeDOWN1
    JZ ENDD
    MOV starttimeDOWN1,DH
    INC counterdown1
    CMP counterdown1,duration
    JNZ ENDD
    MOV counterdown1,0
    MOV speed2,3
    DEC UseSpeedDown

    CHECKSDOWN2:
    CMP UseSpeedDown2,1
    JNE ENDD

    CMP DH,starttimeDOWN2
    JZ ENDD
    MOV starttimeDOWN2,DH
    INC counterdown2
    CMP counterdown2,duration
    JNZ ENDD
    MOV counterdown2,0
    MOV speed1,3
    DEC UseSpeedDown2

    ENDD:
    RET
    CheckEndPower ENDP

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
    ;Draw Squre

    drawSquares PROC NEAR
        ;Draw square1
        mov cx, squareY         ;Column
        mov dx, squareX         ;Row
        mov al,fircolor             ;Pixel color
        mov ah,0ch              ;Draw Pixel Command
        Horizontal: int 10h
        INC CX
        MOV BX, CX
        SUB BX, squareY
        CMP BX, squareLength
        JNZ Horizontal

        MOV CX, squareY
        INC DX
        MOV BX, DX
        SUB BX, squareX
        CMP BX, squareLength
        JNZ Horizontal

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
        JNE CheckSpeedUp
        SUB squareY,AX
        MOV MovingSQR,1


        CheckSpeedUp:
        CMP [KeyList+ q],1
        JNE CheckSpeedDown

        CMP SpeedUp,0
        JE CheckSpeedDown
        DEC SpeedUp

        INC UseSpeedUp
        PUSH CX
        PUSH DX
        MOV AH,2CH
        INT 21H
        MOV starttimeUP1,DH
        POP DX
        POP CX
        ADD speed1,upSpeed

        CheckSpeedDown:
        CMP [KeyList + e], 1
        JNE check_car2_movement

        CMP SpeedDown,0
        JE check_car2_movement
        MOV speed2,downSpeed
        DEC SpeedDown
        INC UseSpeedDown
        PUSH CX
        PUSH DX
        MOV AH,2CH
        INT 21H
        MOV starttimeDOWN1,DH
        POP DX
        POP CX

        

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
        JNE CheckSpeedUp2
        SUB squareY2,AX
        MOV MovingSQR,2


        CheckSpeedUp2:
        CMP [KeyList + p], 1
        JNE CheckSpeedDown2
        CMP SpeedUp2,0
        JE CheckSpeedDown2
        DEC SpeedUp2
        INC UseSpeedUp2
        PUSH CX
        PUSH DX
        MOV AH,2CH
        INT 21H
        MOV starttimeUP2,DH
        POP DX
        POP CX
        ADD speed2,upSpeed

        CheckSpeedDown2:
        CMP [KeyList+o],1
        JNE Exit
        CMP SpeedDown2,0
        JE Exit
        MOV speed1,downSpeed
        DEC SpeedDown2
        INC UseSpeedDown2
        PUSH CX
        PUSH DX
        MOV AH,2CH
        INT 21H
        MOV starttimeDOWN2,DH
        POP DX
        POP CX
        

        Exit:
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

; SETTIMER  PROC
;     PUSH CX
;     PUSH DX
;     MOV AH,2CH
;     INT 21H
;     MOV starttime,DH
;     POP DX
;     POP CX
;     RET
; SETTIMER ENDP

DrawPowers   PROC
    ;draw power
    CMP powercnt,0
    JZ ENDdraw
    MOV DX,powerrow
    MOV CX,powercol
    MOV AL,powercolor
    
    MOV DI,DX 
    ADD DI,powerlength
    
    MOV BX,CX
    ADD BX,powerlength
    
    MOV AH,0CH
    
LOPSEC: 
    LOPSEC2:
        INT 10H
        INC DX
        CMP DX,DI
        JNZ LOPSEC2  
    MOV DX,DI
    SUB DX,powerlength
    INC CX
    CMP CX,BX
    JNZ LOPSEC 

    MOV DX,100
    MOV CX,100
    MOV AL,04
    
    MOV DI,DX 
    ADD DI,powerlength
    
    MOV BX,CX
    ADD BX,powerlength
    
    MOV AH,0CH
    
LOPSECCC: 
    LOPSECCC2:
        INT 10H
        INC DX
        CMP DX,DI
        JNZ LOPSECCC2  
    MOV DX,DI
    SUB DX,powerlength
    INC CX
    CMP CX,BX
    JNZ LOPSECCC 

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


END MAIN