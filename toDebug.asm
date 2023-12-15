.MODEL SMALL
.286
.STACK 64
.DATA

;Keyboard

KeyList db 128 dup(0)

FoundSpeedUp  db  0
FoundSpeedUp2  db  0

FoundSpeedDown  db  0
FoundSpeedDown2  db  0

GhostOn1  db  0
GhostOn2  db  0

OutTrack  db  0
OutTrackRow dw 0
OutTrackCol dw 0

direction1 db 'k'
direction2 db 'k'

MovingSQR DB 0
powercnt  DB 1       ;number of powerups on screen

;POWER UPS INVENTORY FOR PLAYER 1
SpeedUpsCnt    db      0     
SpeedDownsCnt   db      0

;POWER UPS INVENTORY FOR PLAYER 2
SpeedUpsCnt2    db      0
SpeedDownCnt2   db      0

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

duration equ 5

TIME_AUX DB 0

PreX    DW  0
PreY    DW  0

squareX DW 0
squareY DW 0

PreX2   DW  0
PreY2   DW  50

squareX2 DW 0
squareY2 DW 50

speed1 DW 3
speed2 DW 3

player1Keys DW 0
player2Keys DW 0

;Parameters
squareLength EQU 20
powerlength  EQU    5
fircolor    EQU  5
seccolor    EQU 7
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

;VIDEO MODE
VIDEO_MODE    EQU 4F02h                          
VIDEO_MODE_BX EQU 0101h       

;COLOR PARAMETERS
SpeedUpColor EQU 2   
SpeedDownColor EQU 1   
ObstacleColor EQU  8  
CreateObstaclColor EQU 6 
AvoidObstaclColor EQU 4

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

    ; call drawPath

;THE ACTUAL GAME
    CALL setBackgroundColor
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
    CALL CheckOutOfRange 

    ; CALL VALIDATE2
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
    ;GET THE BORDERS OF THE SQUARE
    MOV CX,squareX
    MOV BX,CX
    ADD BX,squareLength

    MOV DX,squareY
    MOV DI,DX
    ADD DI,squareLength

    ;CHECK THE THE NEW POSITION 

    OUTLOP:
    MOV CX,squareX
    INLOP:
        MOV AH,0DH 
        INT 10H

        CMP AL,color
        JE LABEL1  

        ;SKIP OWN COLOR TO SKIP
        CMP AL,fircolor
        JE LABEL1

        ;CHECK FOR OPSTACLES
        CMP AL,ObstacleColor
        JNZ SUU

        CMP GhostOn1,1
        JNE NORMAL1
        CALL AvoidObstacle
        JMP SUU

        NORMAL1:
        PUSH DX
        mov dx,PreX
        mov squareX,dx
        mov dx,PreY
        mov squareY,dx
        POP DX

        SUU:
        ; CMP AL,seccolor
        ; JNZ SU
        ; PUSH DX
        ; mov dx,PreX
        ; mov squareX,dx
        ; mov dx,PreY
        ; mov squareY,dx
        ; POP DX

        SU:
        
        CMP AL,SpeedUpColor
        JNZ CheckAgain
        mov FoundSpeedUp,1
        call ClearPwr

        CheckAgain:
        CMP AL,SpeedDownColor
        JNZ CheckAgain2  
        MOV FoundSpeedDown,1
        call ClearPwr
        CheckAgain2:

        CMP AL,CreateObstaclColor
        JNE CheckAgain3
        CALL PlaceObstacle
        CALL ClearPwr
        
        CheckAgain3:
        CMP AL,AvoidObstaclColor
        JNE CheckAgain4
        MOV GhostOn1,1
        CALL ClearPwr

        CheckAgain4:
        
        CheckAgain5:


        LABEL1:
        ADD CX,1
        CMP CX,BX
        JNZ INLOP  
    ADD DX,1
    CMP DX,DI
    JNZ OUTLOP

    CMP FoundSpeedUp,1
    JNE SDown

    inc SpeedUpsCnt
    mov FoundSpeedUp,0

    SDown:
    CMP FoundSpeedDown,1
    JNE nopower
    INC SpeedDownsCnt
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

        CMP AL,ObstacleColor
        JNE CHCHCH
        CMP GhostOn2,1
        JNE NORMAL
        CALL AvoidObstacle
        JMP CHCHCH
        NORMAL:
        PUSH DX
        mov dx,PreX2
        mov squareX2,dx
        mov dx,PreY2
        mov squareY2,dx
        POP DX

        CHCHCH:
        ; cmp al,fircolor
        ; JNE CHCH  
        ; PUSH DX
        ; mov dx,PreX2
        ; mov squareX2,dx
        ; mov dx,PreY2
        ; mov squareY2,dx
        ; POP DX


        CHCH:
        CMP AL,SpeedUpColor
        JNZ CheckAgainn
        mov FoundSpeedUP2,1
        call ClearPwr

        CheckAgainn:
        CMP AL,SpeedDownColor
        JNZ CheckAgainn2  
        MOV FoundSpeedDown2,1
        call ClearPwr

        CheckAgainn2:
        CMP AL,AvoidObstaclColor
        JNE CheckAgainn3
        MOV GhostOn2,1
        CALL ClearPwr


        CheckAgainn3:
        CMP AL,CreateObstaclColor
        JNE LABEL11
        CALL PlaceObstacle
        call ClearPwr   


        LABEL11:
        ADD CX,1
        CMP CX,BX
        JNZ INLOPP 
    ADD DX,1
    CMP DX,DI
    JNZ OUTLOPP

    CMP FoundSpeedUp2,1
    JNE SDownn

    inc SpeedUpsCnt2
    mov FoundSpeedUp2,0

    SDownn:
    CMP FoundSpeedDown2,1
    JNE nopowerr
    INC SpeedDownCnt2
    MOV FoundSpeedDown2,0

    nopowerr:
    RET
    VALIDATE4 ENDP

AvoidObstacle proc
    PUSH DX
    CMP MovingSQR,2
    JNE TRYFIR
    cmp direction2,'D'
    JNE tri1
    ADD DX,powerlength
    MOV squareX2,DX
    tri1:
    CMP direction2,'U'
    JNE TRI2
    SUB DX,squareLength
    SUB DX,powerlength
    SUB DX,powerlength
    mov squareX2,dx
    TRI2:
    CMP direction2,'L'
    JNE TRI3
    SUB DX,squareLength
    SUB DX,powerlength
    mov squareY2,dx
    TRI3:
    CMP direction2,'R'
    JNE TRI4
    ADD DX,powerlength
    MOV squareY2,DX
    TRI4:
    JMP TRI44
    TRYFIR:
    cmp direction1,'D'
    JNE tri11
    ADD DX,powerlength
    MOV squareX,DX
    tri11:
    CMP direction1,'U'
    JNE TRI22
    SUB DX,squareLength
    SUB DX,powerlength
    SUB DX,powerlength
    mov squareX,dx
    TRI22:
    CMP direction1,'L'
    JNE TRI33
    SUB DX,squareLength
    SUB DX,powerlength
    mov squareY,dx
    TRI33:
    CMP direction1,'R'
    JNE TRI44
    ADD DX,powerlength
    MOV squareY,DX
    TRI44:
    POP DX
    ret
AvoidObstacle endp

PlaceObstacle PROC
    PUSHA

    CMP MovingSQR,1
    JNE trySEC
    
    cmp direction1,'D'
    JNE try1
    sub dx,squareLength
    sub dx,powerlength
    DEC DX
    
    try1:
    CMP direction1,'L'
    JNE try2
    ADD CX,squareLength
    ADD CX,powerlength
    ADD CX,powerlength
    
    try2:
    CMP direction1,'R'
    JNE try3
    SUB CX,squareLength
    SUB CX,powerlength
    DEC CX

    try3:
    CMP direction1,'U'
    JNE trySEC
    ADD DX,squareLength
    ADD DX,powerlength
    ADD DX,powerlength
    JMP DRAW

    trySEC:
    cmp direction2,'D'
    JNE try11
    sub dx,squareLength
    sub dx,powerlength
    DEC DX
    
    try11:
    CMP direction2,'L'
    JNE try22
    ADD CX,squareLength
    ADD CX,powerlength
    ADD CX,powerlength
    
    try22:
    CMP direction2,'R'
    JNE try33
    SUB CX,squareLength
    SUB CX,powerlength
    DEC CX
    
    try33:
    CMP direction2,'U'
    JNE DRAW
    ADD DX,squareLength
    ADD DX,powerlength
    ADD DX,powerlength
    

  
    DRAW:
    MOV AL,ObstacleColor
    CALL DrawOnePower

    POPA
    RET
PlaceObstacle ENDP

ClearPwr    proc
    PUSHA
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

    POPA

ret
ClearPwr endp


setBackgroundColor PROC NEAR
    mov cx, 0           ;Column
    mov dx, 0           ;Row
    mov al, 0        ;Pixel color
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
    mov al,0h             ;Pixel color
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
    mov al,0            ;Pixel color
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

moveSquares PROC

    MOV AX,speed1
    
    ;SAVE INITIAL POSITION
    MOV BX,squareX
    MOV PreX,BX
    
    MOV BX,squareY
    MOV PreY,BX

    ;PLAYER 1 CONTROLS

    checkUp:    
    ;if 'w' is pressed, move up
    CMP [KeyList + w], 1
    JNE checkDown
    SUB squareX,AX

    MOV MovingSQR,1
    MOV direction1,'U'

    checkDown:
    ;if 's' is pressed, move down
    CMP [KeyList + s], 1
    JNE checkRight
    ADD squareX,AX

    MOV MovingSQR,1
    MOV direction1,'D'

    checkRight:
    ;if 'd' is pressed, move right
    CMP [KeyList + d], 1
    JNE checkLeft
    ADD squareY,AX

    MOV MovingSQR,1
    MOV direction1,'R'

    ;if 'a' is pressed, move left
    checkLeft:
    CMP [KeyList + a], 1
    JNE CheckSpeedUp
    SUB squareY,AX

    MOV MovingSQR,1
    MOV direction1,'L'


    ;POWER UP
    CheckSpeedUp:
    CMP [KeyList+ q],1
    JNE CheckSpeedDown

    ;CHECK SPEED UP INVENTORY
    CMP SpeedUpsCnt,0
    JE CheckSpeedDown
    DEC SpeedUpsCnt

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

    CMP SpeedDownsCnt,0
    JE check_car2_movement
    MOV speed2,downSpeed
    DEC SpeedDownsCnt
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

    ;PLAYER 2 CONTROLS

    checkUp2:
    ;if 'upArrow' is pressed, move up
    CMP [KeyList + upArrow], 1
    JNE checkDown2
    SUB squareX2,AX
    MOV MovingSQR,2
    MOV direction2,'U'

    checkDown2:
    ;if 'downArrow' is pressed, move down
    CMP [KeyList + downArrow], 1
    JNE checkRight2
    ADD squareX2,AX
    MOV MovingSQR,2
    MOV direction2,'D'

    checkRight2:
    ;if 'rightArrow' is pressed, move right
    CMP [KeyList + rightArrow], 1
    JNE checkLeft2
    ADD squareY2,AX
    MOV MovingSQR,2
    MOV direction2,'R'

    checkLeft2:
    ;if 'leftArrow' is pressed, move left
    CMP [KeyList + leftArrow], 1
    JNE CheckSpeedUp2
    SUB squareY2,AX
    MOV MovingSQR,2
    MOV direction2,'L'

;POWER UPS 2
    CheckSpeedUp2:
    CMP [KeyList + p], 1
    JNE CheckSpeedDown2
    CMP SpeedUpsCnt2,0
    JE CheckSpeedDown2
    DEC SpeedUpsCnt2
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
    CMP SpeedDownCnt2,0
    JE Exit
    MOV speed1,downSpeed
    DEC SpeedDownCnt2
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


DrawOnePower PROC ;al => color  ;cx => row ;dx => column

    MOV DI,DX 
    ADD DI,powerlength
    
    MOV BX,CX
    ADD BX,powerlength

    MOV AH,0CH

    lloopp: 
        lloopp2:
            INT 10H
            INC DX
            CMP DX,DI
            JNZ lloopp2  
        MOV DX,DI
        SUB DX,powerlength
        INC CX
        CMP CX,BX
        JNZ lloopp 

    RET

DrawOnePower ENDP

DrawPowers   PROC
    ;draw power

    MOV DX,50
    MOV CX,50
    MOV AL,AvoidObstaclColor
    call DrawOnePower

    MOV DX,100
    MOV CX,100
    MOV AL,ObstacleColor
    call DrawOnePower
    
    MOV DX,150
    MOV CX,150
    MOV AL,SpeedDownColor
    call DrawOnePower


    MOV DX,200
    MOV CX,200
    MOV AL,CreateObstaclColor
    CALL DrawOnePower


    MOV DX,250
    MOV CX,250
    MOV AL,SpeedUpColor
    call DrawOnePower
ENDdraw:
    RET
DrawPowers ENDP

; CHECKING THE PLAYER IS IN THE THE SCREEN

CheckOutOfRange  PROC

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
CheckOutOfRange ENDP


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