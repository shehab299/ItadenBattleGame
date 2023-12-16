;AUTHOR : SHEHAB KHALED

;---------------------------------------
.MODEL SMALL
.STACK 32
.286
;---------------------------------------
.DATA



; PATH



; END PATH


KeyList db 128 dup(0)

;ADDRESS VECTOR FOR INTERRUPTS
INT09_BX DW ?
INT09_ES DW ?



AUX_IMAGE_WIDTH dw ?
AUX_IMAGE_HEIGHT dw ? 
START_ROW dw ?


include const.inc

include cars/const.inc
include cars/redSp.inc
include cars/yellowSp.inc
include pagesImg/img.inc


player1_up  db verti_size dup(?)
player1_down db verti_size dup(?)
player1_left  db horiz_size dup(?)
player1_right  db horiz_size dup(?)
player1_up_left db diag_size dup(?)
player1_up_right db diag_size dup(?)
player1_down_left db diag_size dup(?)
player1_down_right db diag_size dup(?)

player2_up  db verti_size dup(?)
player2_down db verti_size dup(?)
player2_left  db horiz_size dup(?)
player2_right  db horiz_size dup(?)
player2_up_left db diag_size dup(?)
player2_up_right db diag_size dup(?)
player2_down_left db diag_size dup(?)
player2_down_right db diag_size dup(?)
file_handle DW ?

SUB_WIDTH DW ?
SUB_HEIGHT DW ? 
 

include gridta.inc

;CAR SHOW

MovingSQR DB 0
TIME_AUX DB 0

X_POS DW 200
Y_POS DW 200

Pre_X DW ?
Pre_Y DW ?

speed1_X DW 5
speed1_Y DW 5

speed2 DW 2

;CAR DIRECTIONS
DIRS DB 4

PrevState db 0
CurrentState db 0

Up_and equ 1
Down_and equ 16
Left_and equ 64
Right_and equ 4
Up_Left_and equ 128
Up_Right_and equ 2
Down_Right_and equ 8
Down_Left_and equ 32

START_COLUMN DW ?
IN_PATH DB 0
;VALIDATIONS

AUX_X DW ?
AUX_Y DW ?
AUX_DIR db 4




;---------------------------------------
.code

include files.inc
include pagesPrc/UI.inc
include pagesPrc/keyboard.inc
include grid.inc


loadRedCar PROC
    ;1
    MOV DX, offset upFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET
loadRedCar ENDP

loadYellowCar PROC
    ;1
    MOV DX, offset upFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadYellowCar ENDP


MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX

    CALL ConfigKeyboard

    MOV AX,VIDEO_MODE
    MOV BX,VIDEO_MODE_BX
    INT 10H

    ;LOADING THE CARS AND THE PATHS
    call loadRedCar
    call Generate

    call drawPath
    MOV AH,0DH
    MOV BH,0
    MOV CX,0
    MOV DX,0
    INT 10H

    ;INITALIZING POSITIONS
    MOV Y_POS,50
    MOV X_POS,50
    ADD X_POS,CELL_W * 3
    ADD Y_POS,CELL_H/2

    MOV AUX_Y,0
    MOV AUX_X,0
    ADD AUX_X,CELL_W * 3
    ADD AUX_Y,CELL_H/2



    ;MAIN LOOP
    CHECK_TIME:
    Mov AH, 2CH
    INT 21H

    CMP DL, TIME_AUX
    JE CHECK_TIME

    ;If it is different, draw and move
    MOV TIME_AUX, DL

    call drawPath
    call moveSquares


    MOV AL,DIRS
    MOV AH,0
    MOV CX,Y_POS
    MOV DX,X_POS
    CALL drawFirstCar
    JMP CHECK_TIME

ENDCHK:

    CALL ResetKeyboard

    MOV AH,4CH
    INT 21H
MAIN ENDP

; THE POSITION WILL BE CALCULATED FROM THE CENTER OF THE IMAGE
drawFirstCar PROC  ;CX => ROW / DX => COLUMN /AX => DIR 

    UP_DIR:
        CMP AX,Up_and
        JNE UP_RIGHT_DIR
        MOV SI,OFFSET player1_up
        MOV [AUX_IMAGE_HEIGHT], verti_height
        MOV [SUB_HEIGHT], verti_height/2
        MOV [AUX_IMAGE_WIDTH], verti_width
        MOV [SUB_WIDTH], verti_width/2
        JMP DRAW

    UP_RIGHT_DIR:
        CMP AX,Up_Right_and
        JNE RIGHT_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2        
        MOV SI,OFFSET player1_up_right
        JMP DRAW
    
    RIGHT_DIR:
        CMP AX,Right_and
        JNE DOWN_RIGHT_DIR
        MOV [AUX_IMAGE_HEIGHT], horiz_height
        MOV [SUB_HEIGHT], horiz_height/2
        MOV [AUX_IMAGE_WIDTH], horiz_width
        MOV [SUB_WIDTH], horiz_width/2
        MOV SI,OFFSET player1_right
        JMP DRAW

    DOWN_RIGHT_DIR:
        CMP AX,Down_Right_and
        JNE DOWN_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2    
        MOV SI,OFFSET player1_down_right
        JMP DRAW

    DOWN_DIR:
        CMP AX,Down_and
        JNE DOWN_LEFT_DIR
        MOV SI,OFFSET player1_down
        MOV [AUX_IMAGE_HEIGHT], verti_height
        MOV [SUB_HEIGHT], verti_height/2
        MOV [AUX_IMAGE_WIDTH], verti_width
        MOV [SUB_WIDTH], verti_width/2    
        JMP DRAW

    DOWN_LEFT_DIR:
        CMP AX,Down_Left_and
        JNE LEFT_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2    
        MOV SI,OFFSET player1_down_left
        JMP DRAW

    LEFT_DIR:
        CMP AX,Left_and
        JNE UP_LEFT_DIR
        MOV [AUX_IMAGE_HEIGHT], horiz_height
        MOV [SUB_HEIGHT], horiz_height/2
        MOV [AUX_IMAGE_WIDTH], horiz_width
        MOV [SUB_WIDTH], horiz_width/2
        MOV SI,OFFSET player1_left
        JMP DRAW

    UP_LEFT_DIR:
        CMP AX,Up_Left_and
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2     
        MOV SI,OFFSET player1_up_left
        JMP DRAW    

    ;CALC FIRST PIXEL FROM CENTER OF GRAVITY
    DRAW:
        SUB CX,SUB_WIDTH
        SUB DX,SUB_HEIGHT
        MOV [START_ROW], CX
        MOV [START_COLUMN], DX

        CALL drawImage

    RET

drawFirstCar ENDP
    ;Move Squares
moveSquares PROC

    PUSH BX DX

    MOV BX,speed1_X
    MOV DX,speed1_Y

    MOV AL,CurrentState
    MOV PrevState,al
    MOV CurrentState,0
    

    checkUp:    
    ;if 'w' is pressed, move up
    CMP [KeyList + w], 1
    JNE checkDown
    SUB AUX_Y,DX
    ADD CurrentState,2

    checkDown:
    ;if 's' is pressed, move down
    CMP [KeyList + s], 1
    JNE checkRight
    ADD AUX_Y,DX
    ADD CurrentState,4

    checkRight:
    ;if 'd' is pressed, move right
    CMP [KeyList + d], 1
    JNE checkLeft
    ADD AUX_X,BX
    ADD CurrentState,8

    ;if 'a' is pressed, move left
    checkLeft:
    CMP [KeyList + a], 1
    JNE Exit_
    SUB AUX_X,BX
    ADD CurrentState,16

    Exit_:
    MOV AL,PrevState
    CMP AL,CurrentState
    JE MovePlayer2
    CALL ChangeDirection_STATE

    MovePlayer2:
    call CheckOutOfRange ;VALIDATE AUX_X,Y,DIR AND FILL X_POS Y_POS DIRS
    ; MOV CX,AUX_X
    ; MOV DX,AUX_Y
    ; MOV AL,AUX_DIR

    ; ; VALIDATE HERE IF VALID MOVE THEM TO THE ACTUAL POSITIONS
    ; MOV X_POS,CX
    ; MOV Y_POS,DX
    ; MOV DIRS,AL


    pop DX BX
    RET

moveSquares ENDP

ChangeDirection_STATE PROC 
    
    ;AL => DIRECTION
    ;AH => PLAYER
    MOV AH,1

    CMP CurrentState,30
    JNE next1    
    RET

    next1:
    CMP CurrentState,14
    JNE next2
    MOV AL,Right_and
    JMP CHANGE    

    next2:
    CMP CurrentState,22
    JNE next3
    MOV AL,Left_and
    JMP CHANGE

    next3:
    CMP CurrentState,26
    JNE next4
    MOV AL,Up_and
    JMP CHANGE

    next4:
    CMP CurrentState,28
    JNE next5
    MOV AL,Down_and
    JMP CHANGE

    next5:
    CMP CurrentState,6
    JNE next6
    RET   

    next6:
    CMP CurrentState,24
    JNE next8
    RET

    next8:
    CMP CurrentState,20
    JNE next9
    MOV AL,Down_Left_and
    JMP CHANGE

    next9:
    CMP CurrentState,12
    JNE next10
    MOV AL,Down_Right_and
    JMP CHANGE

    next10:
    CMP CurrentState,18
    JNE next11
    MOV AL,Up_Left_and
    JMP CHANGE

    next11:
    CMP CurrentState,10
    JNE next12
    MOV AL,Up_Right_and
    JMP CHANGE

    next12:
    CMP CurrentState,16
    JNE next13
    MOV AL,Left_and
    JMP CHANGE

    next13:
    CMP CurrentState,8
    JNE next14
    MOV AL,Right_and
    JMP CHANGE

    next14:
    CMP CurrentState,4
    JNE next15
    MOV AL,Down_and
    JMP CHANGE

    next15:
    CMP CurrentState,2
    JNE _Exit_
    MOV AL,Up_and
    JMP CHANGE

    CHANGE:

    CMP AH,1
    JNE CHANGE2
    MOV AUX_DIR,AL
    RET

    CHANGE2:

    CMP AH,2
    JNE _Exit_
    MOV AUX_DIR,AL
    RET

    _Exit_:
    RET
ChangeDirection_STATE ENDP

CheckOutOfRange PROC  ;CX => ROW / DX => COLUMN /AX => DIR 

    MOV CX,AUX_X
    MOV DX,AUX_Y
    MOV AL,AUX_DIR
    MOV AH,0

    OUT_UP_DIR:
        CMP AX,Up_and
        JNE OUT_UP_RIGHT_DIR
        MOV [AUX_IMAGE_HEIGHT], verti_height
        MOV [SUB_HEIGHT], verti_height/2
        MOV [AUX_IMAGE_WIDTH], verti_width
        MOV [SUB_WIDTH], verti_width/2
        JMP CHECK

    OUT_UP_RIGHT_DIR:
        CMP AX,Up_Right_and
        JNE OUT_RIGHT_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2        
        JMP CHECK
    
    OUT_RIGHT_DIR:
        CMP AX,Right_and
        JNE OUT_DOWN_RIGHT_DIR
        MOV [AUX_IMAGE_HEIGHT], horiz_height
        MOV [SUB_HEIGHT], horiz_height/2 
        MOV [AUX_IMAGE_WIDTH], horiz_width
        MOV [SUB_WIDTH], horiz_width/2
        JMP CHECK

    OUT_DOWN_RIGHT_DIR:
        CMP AX,Down_Right_and
        JNE OUT_DOWN_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2    
        JMP CHECK

    OUT_DOWN_DIR:
        CMP AX,Down_and
        JNE OUT_DOWN_LEFT_DIR
        MOV [AUX_IMAGE_HEIGHT], verti_height
        MOV [SUB_HEIGHT], verti_height/2
        MOV [AUX_IMAGE_WIDTH], verti_width
        MOV [SUB_WIDTH], verti_width/2    
        JMP CHECK

    OUT_DOWN_LEFT_DIR:
        CMP AX,Down_Left_and
        JNE OUT_LEFT_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2    
        JMP CHECK

    OUT_LEFT_DIR:
        CMP AX,Left_and
        JNE OUT_UP_LEFT_DIR
        MOV [AUX_IMAGE_HEIGHT], horiz_height
        MOV [SUB_HEIGHT], horiz_height/2
        MOV [AUX_IMAGE_WIDTH], horiz_width
        MOV [SUB_WIDTH], horiz_width/2
        JMP CHECK

    OUT_UP_LEFT_DIR:
        CMP AX,Up_Left_and
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2     
        JMP CHECK    

    ;CALC FIRST PIXEL FROM CENTER OF GRAVITY
    
    CHECK:
        SUB CX,SUB_WIDTH
        SUB DX,SUB_HEIGHT
        MOV [START_ROW], DX
        MOV [START_COLUMN], CX

        call checkSqr
 
        CMP IN_PATH,1
        JE EXIT_OUT

        OUT_OF_RANGE:
        MOV CX,X_POS
        MOV DX,Y_POS
        MOV AL,DIRS

        MOV AUX_X,CX
        MOV AUX_Y,DX
        MOV AUX_DIR,AL
        
        RET

        EXIT_OUT:
        MOV AL,AUX_DIR
        MOV CX,AUX_X
        MOV DX,AUX_Y

        MOV X_POS,CX
        MOV Y_POS,DX        
        MOV DIRS,AL

        RET
CheckOutOfRange ENDP 

checkSqr PROC  ; SI => Offset File ;START_ROW => y ;START_COLUMN => X ;AUX_IMAGE_WIDTH => IMAGE_WIDTH ;AUX_IMAGE_HEIGHT => IMAGE_HEIGHT

    PUSHA

    MOV CX,[START_COLUMN]
    MOV DX,[START_ROW]

    MOV SI,CX
    ADD SI,[AUX_IMAGE_WIDTH]

    MOV DI,DX
    ADD DI,[AUX_IMAGE_HEIGHT]


    MOV AH,0DH    
    MOV BH,0
    _DRAW_PIXELS_:
        INT 10H
        CMP AL,00h
        JE  NOT_VALID
        INC CX
        CMP CX,SI
        JNE _DRAW_PIXELS_

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE _DRAW_PIXELS_

    MOV IN_PATH,1
    POPA
    
    RET
    
    NOT_VALID:
    MOV IN_PATH,0
    POPA
    
    RET

checkSqr ENDP

; CHECK_PATH PROC 
;     PUSHA

;     MOV AX,DX
;     MOV DX,0
;     MOV BX,CELL_H
;     DIV BX
;     MOV DI,AX ; STORE THE RESULT (ROW)

;     MOV AX,CX
;     MOV DX,0
;     MOV BX,CELL_W
;     DIV BX
;     MOV CX,AX ;STORE THE RESULT (COLUMN)

;     MOV AX,DI
;     MOV BX,GRID_WIDTH
;     MUL BX
;     ADD AX,CX

;     MOV BX,AX

;     CMP [visited+BX],1
;     JNE NOT_VALID_
    
;     MOV IN_PATH,1
;     POPA
;     RET

;     NOT_VALID_:
;     MOV IN_PATH,0
;     POPA

;     RET

; CHECK_PATH ENDP

CheckOutOfRange  PROC

    MOV DX,AUX_X
    MOV CX,AUX_Y
    CALL VALIDROW
    CALL VALIDCOL
    MOV squareX,DX
    MOV squareY,CX

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


END MAIN

        ; CALL drawImage




;         ;TOP LEFT CORNER
;         fst:
;         SUB CX,SUB_WIDTH
;         SUB DX,SUB_HEIGHT

;         CALL CHECK_PATH
;         CMP IN_PATH,1
;         JE snd
;         JMP OUT_OF_RANGE

;         snd:
;         ;TOP RIGHT CORNER
;         ADD CX,AUX_IMAGE_WIDTH

;         CALL CHECK_PATH
;         CMP IN_PATH,1
;         JE trd
;         JMP OUT_OF_RANGE

;         trd:
;         ;DOWN RIGHT CORNER
;         ADD DX,AUX_IMAGE_HEIGHT
        
;         CALL CHECK_PATH
;         CMP IN_PATH,1
;         JE frth
;         JMP OUT_OF_RANGE
        
;         frth:
;         SUB CX,AUX_IMAGE_WIDTH

;         CALL CHECK_PATH