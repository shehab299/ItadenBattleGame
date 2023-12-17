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
include cars/ySp.inc
include cars/flamSp.inc
include cars/blueSp.inc
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

;VALIDATION_BOOLEANS

OUT_OF_SCREEN_BOOL DB ?
OUT_OF_PATH_BOOL DB ?
 
include gridta.inc

;CAR SHOW

MovingSQR DB 0
TIME_AUX DB 0

;PLAYER 1

X_POS DW 200
Y_POS DW 200
DIRS DB 4

AUX_X DW ?
AUX_Y DW ?
AUX_DIR db 4


speed1_X DW 5
speed1_Y DW 5

PrevState db 0
CurrentState db 0

;PLAYER 2

X_POS_2 DW 400
Y_POS_2 DW 400 
DIRS2 DB 4

AUX_X_2 DW ?
AUX_Y_2 DW ? 
AUX_DIR_2 DW ?

speed2_X DW 5
speed2_Y DW 5

PrevState2 db 0 
CurrentState2 db 0

;CAR DIRECTIONS




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



;---------------------------------------
.code

include files.inc
include pagesPrc/UI.inc
include pagesPrc/keyboard.inc
include grid.inc


loadRedCarForOne PROC
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
loadRedCarForOne ENDP

loadRedCarForTwo PROC
    ;1
    MOV DX, offset upFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET
loadRedCarForTwo ENDP

loadYellowCarForOne PROC
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

    MOV CX, horiz_size
    MOV DX, offset player1_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadYellowCarForOne ENDP

loadBlueCarForOne PROC

    ;1
    MOV DX, offset upFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadBlueCarForOne ENDP

loadYellowCarForTWo PROC
    ;1
    MOV DX, offset upFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadYellowCarForTwo ENDP

loadBlueCarForTwo PROC

    ;1
    MOV DX, offset upFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadBlueCarForTwo ENDP

loadFlameCarForOne PROC
    ;1
    MOV DX, offset upFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadFlameCarForOne ENDP

loadFlameCarForTwo PROC

    ;1
    MOV DX, offset upFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadFlameCarForTwo ENDP



MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX

    CALL ConfigKeyboard

    MOV AX,VIDEO_MODE
    MOV BX,VIDEO_MODE_BX
    INT 10H


    call loadBlueCarForOne
    call loadFlameCarForTwo
    call Generate


    call drawPath
    call genPowerUps

    MOV CX,CELL_W/2
    MOV DX,CELL_H/2

    ; CALL Drawobstacle

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

    ;MOV SQUARES AND CLEAR PREVIOUS
    call clearPos
    call moveSquares

    ;DRAW FIRST CAR
    MOV BX,1
    MOV AL,DIRS
    MOV AH,0
    MOV CX,Y_POS
    MOV DX,X_POS
    CALL drawCar

    ;DRAW SECOND CAR
    MOV BX,2
    MOV AL,DIRS2
    MOV AH,0
    MOV CX,Y_POS_2
    MOV DX,X_POS_2
    CALL drawCar


    JMP CHECK_TIME

ENDCHK:

    CALL ResetKeyboard

    MOV AH,4CH
    INT 21H
MAIN ENDP




clearPos PROC

    MOV CX,X_POS
    MOV DX,Y_POS
    MOV AL,DIRS
    MOV AH,0
    CALL getDirctionParamaters
    CALL drawSpot

    MOV CX,X_POS_2
    MOV DX,Y_POS_2
    MOV AL,DIRS2
    MOV AH,0
    CALL getDirctionParamaters
    CALL drawSpot

    RET

clearPos ENDP


; THE POSITION WILL BE CALCULATED FROM THE CENTER OF THE IMAGE
drawCar PROC  ;CX => ROW / DX => COLUMN /AX => DIR 

    UP_DIR:
        CMP AX,Up_and
        JNE UP_RIGHT_DIR
        CMP BX,1
        JNE player2_u
        MOV SI,OFFSET player1_up
        JMP para_up
        player2_u:
        MOV SI,OFFSET player2_up
        para_up:
        MOV [AUX_IMAGE_HEIGHT], verti_height
        MOV [SUB_HEIGHT], verti_height/2
        MOV [AUX_IMAGE_WIDTH], verti_width
        MOV [SUB_WIDTH], verti_width/2
        JMP DRAW

    UP_RIGHT_DIR:
        CMP AX,Up_Right_and
        JNE RIGHT_DIR
        CMP BX,1
        JNE player2_upr
        MOV SI,OFFSET player1_up_right
        JMP para_upr
        player2_upr:
        MOV SI,OFFSET player2_up_right
        para_upr:
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2        

        JMP DRAW
    
    RIGHT_DIR:
        CMP AX,Right_and
        JNE DOWN_RIGHT_DIR
        CMP BX,1
        JNE player2_r
        MOV SI,OFFSET player1_right
        JMP para_r
        player2_r:
        MOV SI,OFFSET player2_right
        para_r:
        MOV [AUX_IMAGE_HEIGHT], horiz_height
        MOV [SUB_HEIGHT], horiz_height/2
        MOV [AUX_IMAGE_WIDTH], horiz_width
        MOV [SUB_WIDTH], horiz_width/2
        JMP DRAW

    DOWN_RIGHT_DIR:
        CMP AX,Down_Right_and
        JNE DOWN_DIR
        CMP BX,1
        JNE player2_dr
        MOV SI,OFFSET player1_down_right        
        JMP para_dr
        player2_dr:
        MOV SI,OFFSET player2_down_right        
        para_dr:
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2    
        JMP DRAW

    DOWN_DIR:
        CMP AX,Down_and
        JNE DOWN_LEFT_DIR
        CMP BX,1
        JNE player2_d
        MOV SI,OFFSET player1_down      
        JMP para_d
        player2_d:
        MOV SI,OFFSET player2_down    
        para_d:
        MOV [AUX_IMAGE_HEIGHT], verti_height
        MOV [SUB_HEIGHT], verti_height/2
        MOV [AUX_IMAGE_WIDTH], verti_width
        MOV [SUB_WIDTH], verti_width/2    
        JMP DRAW

    DOWN_LEFT_DIR:
        CMP AX,Down_Left_and
        JNE LEFT_DIR
        CMP BX,1
        JNE player2_dl
        MOV SI,OFFSET player1_down_left   
        JMP para_dl
        player2_dl:
        MOV SI,OFFSET player1_down_left    
        para_dl:
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2    
        JMP DRAW

    LEFT_DIR:
        CMP AX,Left_and
        JNE UP_LEFT_DIR
        CMP BX,1
        JNE player2_l
        MOV SI,OFFSET player1_left 
        JMP para_l
        player2_l:
        MOV SI,OFFSET player1_left
        para_l:
        MOV [AUX_IMAGE_HEIGHT], horiz_height
        MOV [SUB_HEIGHT], horiz_height/2
        MOV [AUX_IMAGE_WIDTH], horiz_width
        MOV [SUB_WIDTH], horiz_width/2
        JMP DRAW

    UP_LEFT_DIR:
        CMP AX,Up_Left_and
        CMP BX,1
        JNE player2_ul
        MOV SI,OFFSET player1_up_left
        JMP para_ul
        player2_ul:
        MOV SI,OFFSET player1_up_left
        para_ul:
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2     
        JMP DRAW    

    ;CALC FIRST PIXEL FROM CENTER OF GRAVITY
    DRAW:
        SUB CX,SUB_HEIGHT
        SUB DX,SUB_WIDTH
        MOV [START_ROW], CX
        MOV [START_COLUMN], DX

        CALL drawImage
    RET
drawCar ENDP
    ;Move Squares
moveSquares PROC

    PUSH BX DX

    MOV BX,speed1_X
    MOV DX,speed1_Y

    MOV AL,CurrentState
    MOV PrevState,al
    MOV CurrentState,0

Controls:
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
    JNE CHANGE_DIRECTION_1
    SUB AUX_X,BX
    ADD CurrentState,16

CHANGE_DIRECTION_1:
    
    MOV AL,PrevState
    CMP AL,CurrentState
    JE VALIDATE1
    CALL ChangeDirection_STATE

    VALIDATE1:
    call CheckOutOfRange ;CHECK OUT OF PATH AND OUT OF SCREEN

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
    JNE _CHANGE_DIRECTION_1
    MOV AL,Up_and
    JMP CHANGE

    CHANGE:

    CMP AH,1
    JNE CHANGE2
    MOV AUX_DIR,AL
    RET

    CHANGE2:

    CMP AH,2
    JNE _CHANGE_DIRECTION_1
    MOV AUX_DIR,AL
    RET

    _CHANGE_DIRECTION_1:
    RET
ChangeDirection_STATE ENDP

CheckOutOfRange PROC  ;CX => ROW / DX => COLUMN /AX => DIR 

    MOV CX,AUX_X
    MOV DX,AUX_Y
    MOV AL,AUX_DIR
    MOV AH,0

    CALL getDirctionParamaters ; START_ROW/START COLUMN -> FIRST PIXEL  CX/DX ALSO ; AUX_IMAGE_HEIGHT/WIDTH

CHECK_OUF_OF_SCREEN:
    call checkOutOfScreen

    CMP OUT_OF_SCREEN_BOOL,1
    JNE OUT_OF_PATH

    MOV OUT_OF_SCREEN_BOOL,0
    RET
    
OUT_OF_PATH:
    call CheckOoutOfPath
 
    CMP IN_PATH,1
    JE CHANGE_DIRECTION_1OUT

    OUT_OF_RANGE:
    MOV CX,X_POS
    MOV DX,Y_POS
    MOV AL,DIRS

    MOV AUX_X,CX
    MOV AUX_Y,DX
    MOV AUX_DIR,AL
    
    RET

    CHANGE_DIRECTION_1OUT:
    MOV AL,AUX_DIR
    MOV CX,AUX_X
    MOV DX,AUX_Y

    MOV X_POS,CX
    MOV Y_POS,DX        
    MOV DIRS,AL

    RET

CHECK_OBSTACLES:

CheckOutOfRange ENDP 

Drawobstacle PROC ;al => color ;cx => column ;dx => row
    MOV AL,04H

    MOV DI,DX 
    ADD DI,11
    
    MOV BX,CX
    ADD BX,15

    MOV AH,0CH

    lloopp: 
        lloopp2:
            INT 10H
            INC DX
            CMP DX,DI
            JNZ lloopp2  
        MOV DX,DI
        SUB DX,11
        INC CX
        CMP CX,BX
        JNZ lloopp 

    RET

Drawobstacle ENDP

getDirctionParamaters PROC
        OUT_UP_DIR:
        CMP AX,Up_and
        JNE OUT_UP_RIGHT_DIR
        MOV [AUX_IMAGE_HEIGHT], verti_height
        MOV [SUB_HEIGHT], verti_height/2
        MOV [AUX_IMAGE_WIDTH], verti_width
        MOV [SUB_WIDTH], verti_width/2
        JMP DONE

    OUT_UP_RIGHT_DIR:
        CMP AX,Up_Right_and
        JNE OUT_RIGHT_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2        
        JMP DONE
    
    OUT_RIGHT_DIR:
        CMP AX,Right_and
        JNE OUT_DOWN_RIGHT_DIR
        MOV [AUX_IMAGE_HEIGHT], horiz_height
        MOV [SUB_HEIGHT], horiz_height/2 
        MOV [AUX_IMAGE_WIDTH], horiz_width
        MOV [SUB_WIDTH], horiz_width/2
        JMP DONE

    OUT_DOWN_RIGHT_DIR:
        CMP AX,Down_Right_and
        JNE OUT_DOWN_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2    
        JMP DONE

    OUT_DOWN_DIR:
        CMP AX,Down_and
        JNE OUT_DOWN_LEFT_DIR
        MOV [AUX_IMAGE_HEIGHT], verti_height
        MOV [SUB_HEIGHT], verti_height/2
        MOV [AUX_IMAGE_WIDTH], verti_width
        MOV [SUB_WIDTH], verti_width/2    
        JMP DONE

    OUT_DOWN_LEFT_DIR:
        CMP AX,Down_Left_and
        JNE OUT_LEFT_DIR
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2    
        JMP DONE

    OUT_LEFT_DIR:
        CMP AX,Left_and
        JNE OUT_UP_LEFT_DIR
        MOV [AUX_IMAGE_HEIGHT], horiz_height
        MOV [SUB_HEIGHT], horiz_height/2
        MOV [AUX_IMAGE_WIDTH], horiz_width
        MOV [SUB_WIDTH], horiz_width/2
        JMP DONE

    OUT_UP_LEFT_DIR:
        CMP AX,Up_Left_and
        JNE DONE
        MOV [AUX_IMAGE_HEIGHT], diag_height
        MOV [SUB_HEIGHT], diag_height/2
        MOV [AUX_IMAGE_WIDTH], diag_width
        MOV [SUB_WIDTH], diag_width/2     
        JMP DONE    

    DONE:
        SUB CX,SUB_WIDTH
        SUB DX,SUB_HEIGHT
        MOV [START_ROW], DX
        MOV [START_COLUMN], CX

        RET            

getDirctionParamaters ENDP

CheckOoutOfPath PROC 

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

        ;CHECK BACKGROUND
        CMP AL,00h
        JE  NOT_VALID

        ;CHECK OBSTACLES
        CMP AL,04H
        JE NOT_VALID

        ;COMPLETE LOOP
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

CheckOoutOfPath ENDP

checkOutOfScreen proc

    TOP_BORDER:
    CMP DX,1
    JNL DOWN_BORDER
    MOV DX,0
    JMP LEFT_BORDER
    
    DOWN_BORDER:
    MOV DI,SCREEN_HEIGHT
    SUB DI,AUX_IMAGE_HEIGHT
    CMP DX,DI
    JNA LEFT_BORDER
    MOV DX,DI

    LEFT_BORDER:
    CMP CX,1
    JNL RIGHT_BORDER
    MOV CX,0

    RIGHT_BORDER:
    MOV DI,SCREEN_WIDTH
    SUB DI,AUX_IMAGE_WIDTH
    CMP CX,DI
    JA FINISH_CHECK
    JMP VALID

    FINISH_CHECK:
    MOV OUT_OF_SCREEN_BOOL,1

    MOV CX,DI
    ADD CX,SUB_WIDTH
    ADD DX,SUB_HEIGHT

    MOV AUX_X,CX
    MOV AUX_Y,DX

    MOV X_POS,CX
    MOV Y_POS,DX

    RET

    VALID:

    MOV OUT_OF_SCREEN_BOOL,0
    RET

    RET

checkOutOfScreen endp

drawSpot PROC

    MOV AL,BackgroundColor

    MOV CX,[START_COLUMN]
    MOV DX,[START_ROW]

    MOV SI,CX
    ADD SI,[AUX_IMAGE_WIDTH]

    MOV DI,DX
    ADD DI,[AUX_IMAGE_HEIGHT]


    MOV AH,0CH    
    MOV BH,0
    _DRAW_PIXELS_2:
        INT 10H
        INC CX
        CMP CX,SI
        JNE _DRAW_PIXELS_2

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE _DRAW_PIXELS_2

    RET

drawSpot ENDP

END MAIN
