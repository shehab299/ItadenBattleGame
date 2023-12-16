;AUTHOR : SHEHAB KHALED

;---------------------------------------
.MODEL SMALL
.STACK 32

;---------------------------------------
.DATA

KeyList db 128 dup(0)

;ADDRESS VECTOR FOR INTERRUPTS
INT09_BX DW ?
INT09_ES DW ?

MovingSQR DB 0

AUX_IMAGE_WIDTH dw ?
AUX_IMAGE_HEIGHT dw ? 
START_ROW dw ?
START_COLUMN dw ?



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

SUB_WIDTH DW ?
SUB_HEIGHT DW ? 
file_handle DW ? 

;CAR SHOW

TIME_AUX DB 0

X DW 200
Y DW 200

PreX2   DW  0
PreY2   DW  30

squareX2 DW 0
squareY2 DW 30

speed1 DW 2
speed2 DW 2

;CAR DIRECTIONS
DIRS DB 1

Up_and equ 1
Up_Right_and equ 2
Right_and equ 4
Down_Right_and equ 8
Down_and equ 16
Down_Left_and equ 32
Left_and equ 64
Up_Left_and equ 128




;---------------------------------------
.code

include files.inc
include pagesPrc/UI.inc
include pagesPrc/keyboard.inc




MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX

    CALL ConfigKeyboard

    MOV AX,VIDEO_MODE
    MOV BX,VIDEO_MODE_BX
    INT 10H

    call loadRedCar

    

    
    ; MOV AX,32
    ; MOV CX,50
    ; MOV DX,50
    ; CALL drawFirstCar

    

    CHECK_TIME:
    Mov AH, 2CH
    INT 21H

    CMP DL, TIME_AUX
    JE CHECK_TIME

    ;If it is different, draw and move
    MOV TIME_AUX, DL

    call moveSquares
    MOV AL,DIRS
    MOV AH,0
    MOV CX,Y
    MOV DX,X
    CALL drawFirstCar
    JMP CHECK_TIME

CHK:
    ; CHK:
    ; MOV AH,0
    ; INT 10H

    ; CMP [KeyList+W],1
    ; JE Up

    ; CMP [KeyList+s],1
    ; JE Down

    ; CMP [KeyList+a],1
    ; JE Left

    ; CMP [KeyList+d],1
    ; JE Right

    ; JMP CHK

    ; Down:
    ; CALL setBackgroundColor
    ; MOV AX,5    
    ;     MOV CX,50
    ; MOV DX,50
    ; CALL drawFirstCar
    ; JMP CHK

    ; Up:
    ; CALL setBackgroundColor
    ; MOV AX,1    
    ;     MOV CX,50
    ; MOV DX,50
    ; CALL drawFirstCar
    ; JMP CHK

    ; Left:
    ; CALL setBackgroundColor
    ;     MOV CX,50
    ; MOV DX,50
    ; MOV AX,7
    ; CALL drawFirstCar
    ; JMP CHK

    ; Right:
    ; CALL setBackgroundColor
    ;     MOV CX,50
    ; MOV DX,50
    ; MOV AX,3
    ; CALL drawFirstCar
    ; JMP CHK

ENDCHK:

    CALL ResetKeyboard

    MOV AH,4CH
    INT 21H
MAIN ENDP

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

    MOV CX, verti_size
    MOV DX, offset player1_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
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

; THE POSITION WILL BE CALCULATED FROM THE CENTER OF THE IMAGE
drawFirstCar PROC  ;CX => ROW / DX => COLUMN /AX => DIR 

    UP_DIR:
        CMP AX,1
        JNE UP_RIGHT_DIR
        MOV SI,OFFSET player1_up
        MOV [AUX_IMAGE_HEIGHT], verti_height
        MOV [SUB_HEIGHT], verti_height/2
        MOV [AUX_IMAGE_WIDTH], verti_width
        MOV [SUB_WIDTH], verti_width/2
        JMP DRAW

    UP_RIGHT_DIR:
        CMP AX,2
        JNE RIGHT_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2        
        MOV SI,OFFSET player1_up_right
        JMP DRAW
    
    RIGHT_DIR:
        CMP AX,4
        JNE DOWN_RIGHT_DIR
        MOV [AUX_IMAGE_HEIGHT], horiz_height
        MOV [SUB_HEIGHT], horiz_height/2
        MOV [AUX_IMAGE_WIDTH], horiz_width
        MOV [SUB_WIDTH], horiz_width/2
        MOV SI,OFFSET player1_right
        JMP DRAW

    DOWN_RIGHT_DIR:
        CMP AX,8
        JNE DOWN_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2    
        MOV SI,OFFSET player1_down_right
        JMP DRAW

    DOWN_DIR:
        CMP AX,16
        JNE DOWN_LEFT_DIR
        MOV SI,OFFSET player1_down
        MOV [AUX_IMAGE_HEIGHT], verti_height
        MOV [SUB_HEIGHT], verti_height/2
        MOV [AUX_IMAGE_WIDTH], verti_width
        MOV [SUB_WIDTH], verti_width/2    
        JMP DRAW

    DOWN_LEFT_DIR:
        CMP AX,32
        JNE LEFT_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2    
        MOV SI,OFFSET player1_down_left
        JMP DRAW

    LEFT_DIR:
        CMP AX,64
        JNE UP_LEFT_DIR
        MOV [AUX_IMAGE_HEIGHT], horiz_height
        MOV [SUB_HEIGHT], horiz_height/2
        MOV [AUX_IMAGE_WIDTH], horiz_width
        MOV [SUB_WIDTH], horiz_width/2
        MOV SI,OFFSET player1_left
        JMP DRAW

    UP_LEFT_DIR:
        CMP AX,128
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

    MOV MovingSQR,0

    checkUp:    
    ;if 'w' is pressed, move up
    CMP [KeyList + w], 1
    JNE checkDown
    MOV MovingSQR,1
    CALL DirectionalIncrease

    checkDown:
    ;if 's' is pressed, move down
    CMP [KeyList + s], 1
    JNE checkRight
    MOV MovingSQR,1
    CALL DirectionalDecrease

    checkRight:
    ;if 'd' is pressed, move right
    CMP [KeyList + d], 1
    JNE checkLeft
    CMP MovingSQR,1
    JNE checkLeft 
    ROL DIRS,1

    ;if 'a' is pressed, move left
    checkLeft:
    CMP [KeyList + a], 1
    JNE Exit
    CMP MovingSQR,1
    JNE Exit
    ROR DIRS,1

    Exit:
    RET
moveSquares ENDP

DirectionalIncrease PROC

    MOV AL,DIRS
    MOV AH,0

    CMP AX,Up_and
    JE Up

    CMP AX,Up_Left_and
    JE Up_Left

    CMP AX,Left_and
    JE Left

    CMP AX,Down_Left_and
    JE Down_Left

    CMP AX,Down_and
    JE Down

    CMP AX,Down_Right_and
    JE Down_Right

    CMP AX,Right_and
    JE Right

    CMP AX,Up_Right_and
    JE Up_Right

    Up:
    DEC Y
    RET 

    Up_Left:
    DEC X
    DEC Y
    RET 

    Left:
    DEC X
    RET 

    Down_Left:
    DEC X
    INC Y
    RET 

    DOWN:
    INC Y
    RET 

    Down_Right:
    INC X
    INC Y 
    RET

    Right:
    INC X
    RET 

    Up_Right:
    INC X
    DEC Y
    RET

DirectionalIncrease ENDP

DirectionalDecrease PROC

    MOV AL, DIRS
    MOV AH,0

    CMP AX,Up_and
    JE Up_

    CMP AX,Up_Left_and
    JE Up_Left_

    CMP AX,Left_and
    JE Left_

    CMP AX,Down_Left_and
    JE Down_Left_

    CMP AX,Down_and
    JE Down_

    CMP AX,Down_Right_and
    JE Down_Right_

    CMP AX,Right_and
    JE Right_

    CMP AX,Up_Right_and
    JE Up_Right_

    Up_:
    INC Y
    RET 

    Up_Left_:
    INC X
    INC Y
    RET 

    Left_:
    INC X
    RET 

    Down_Left_:
    INC X
    DEC Y
    RET 

    DOWN_:
    DEC Y
    RET 

    Down_Right_:
    DEC X
    DEC Y 
    RET

    Right_:
    DEC X
    RET 

    Up_Right_:
    DEC X
    INC Y
    RET

DirectionalDecrease ENDP



END MAIN