MAIN_LOOP PROC 
    MOV AX,@DATA
    MOV DS,AX

    CALL ConfigKeyboard

    MOV AX,VIDEO_MODE
    MOV BX,VIDEO_MODE_BX
    INT 10H

    call load_players_cars
    call Generate

    call display_Player1_name
    call display_Player2_name
  

   

    call DrawPath_
    call genPowerUps
    ; CALL genObstacles

    call drawFinishLine

    CALL CalcEnd
    CALL intiPos

    call drawEvilPowerUp
    call drawRedPowerUp
    call drawBluePowerUp
    call drawGreenPowerUp
    
    MOV starting_column, 35
    MOV blue_powerup_starting_column, 70
    MOV evil_powerup_starting_column, 100
    MOV red_powerup_starting_column, 130

    call drawEvilPowerUp
    call drawRedPowerUp
    call drawBluePowerUp
    call drawGreenPowerUp

    call Chat_Box_asmaa


    
    ;MAIN LOOP
    CHECK_TIME:
    Mov AH, 2CH
    INT 21H

    ;GAME COUNTER
    CMP DH,SEC_AUX
    JE GAME

    MOV SEC_AUX,DH
    INC TIME_COUNTER

    inc TimeSec
    cmp TimeSec,60
    jne whatever
    mov TimeSec,0
    inc TimeMin
    whatever:

    CALL displayTime


    CMP TIME_COUNTER,GAME_DURATION
    JNE  GAME
    CALL TIE
    JMP ENDCHK

    GAME:

    PUSHA
    CALL checkEndGame
    POPA

    CMP DL, TIME_AUX
    JE CHECK_TIME

    ; CALL DrawRandomPowerUp

    ;If it is different, draw and move
    MOV TIME_AUX, DL

    CMP PLAYER1_WIN,1
    JNE CHECK_WIN_2
    CALL WIN_1
    JMP ENDCHK

    CHECK_WIN_2:
    CMP PLAYER2_WIN,1
    JNE NO_WIN
    CALL WIN_2
    JMP ENDCHK



    NO_WIN:
    call display_speedUp1
    call display_speedDown1
    call display_Avoid1
    call display_CreationPower1

    call display_speedup2
    call display_speedDown2
    call display_Avoid2
    call display_CreationPower2


    Call display_percentage

    CALL CheckEndPower


    ;MOV SQUARES AND CLEAR PREVIOUS
    call clearPos

    MOV DX,X_POS
    MOV CX,Y_POS
    MOV PrevX1,DX
    MOV PREVY1,CX

    MOV DX,X_POS_2
    MOV CX,Y_POS_2
    MOV PrevX2,DX
    MOV PREVY2,CX

    call movePlayer1
    call movePlayer2

    CALL FinalValidation



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
    RET
MAIN_LOOP ENDP


WIN_1 PROC
    mov ah, 2
    mov dh, SCREEN_HEIGHT/CharHeight - 12     ;ROW
    mov dl, 40                               ;COLUMN
    mov bh, 0         
    int 10h

    mov ah, 9
    mov dx, offset WIN_1_TEXT
    int 21h

    mov ah, 9
    mov dx, offset player1_name + 2
    int 21h

    
    RET
WIN_1 ENDP


WIN_2 PROC
    mov ah, 2
    mov dh, SCREEN_HEIGHT/CharHeight - 12     ;ROW
    mov dl, 40                               ;COLUMN
    mov bh, 0         
    int 10h

    mov ah, 9
    mov dx, offset WIN_2_TEXT
    int 21h

    mov ah, 9
    mov dx, offset player2_name + 2
    int 21h
    RET
WIN_2 ENDP

TIE PROC
    mov ah, 2
    mov dh, SCREEN_HEIGHT/CharHeight - 12     ;ROW
    mov dl, 40                               ;COLUMN
    mov bh, 0         
    int 10h

    mov ah, 9
    mov dx, offset TIE_TEXT
    int 21h
    RET
TIE ENDP

display_Player1_name PROC
    mov ah, 2
    mov dh, SCREEN_HEIGHT/CharHeight - 4     ;ROW
    mov dl, 70                               ;COLUMN
    mov bh, 0         
    int 10h

    mov ah, 9
    mov dx, offset player1_name +2
    int 21h
    RET
display_Player1_name ENDP

display_Player2_name PROC
    mov ah, 2
    mov dh, SCREEN_HEIGHT/CharHeight - 4    ;ROW
    mov dl, 5                               ;COLUMN
    mov bh, 0         
    int 10h

    mov ah, 9
    mov dx, offset player2_name +2
    int 21h
    RET
display_Player2_name ENDP

display_speedup1 PROC
    XOR AX, AX
    mov ah, 2
    mov dh, 400/CharHeight + 2    ;ROW
    mov dl, 600/CharWidth         ;COLUMN
    mov bh, 0         
    mov bh, 00h
    int 10h
    MOV ah, 0
    MOV AL, SpeedUp1
    call OUTPUT_NUM
    RET
display_speedup1 ENDP

display_speedDown1 PROC
    XOR AX, AX
    mov ah, 2
    mov dh, 400/CharHeight + 2    ;ROW
    mov dl, 570/CharWidth         ;COLUMN
    mov bh, 0         
    mov bh, 00h 
    int 10h

    MOV ah, 0
    MOV AL, SpeedDown1
    call OUTPUT_NUM
    RET
display_speedDown1 ENDP

display_Avoid1 PROC
    XOR AX, AX
    mov ah, 2
    mov dh, 400/CharHeight + 2    ;ROW
    mov dl, 540/CharWidth         ;COLUMN
    mov bh, 0         
    mov bh, 00h
    int 10h

    MOV ah, 0
    MOV AL, Avoid1
    call OUTPUT_NUM
    RET
display_Avoid1 ENDP

display_CreationPower1 PROC
    XOR AX, AX
    mov ah, 2
    mov dh, 400/CharHeight + 2    ;ROW
    mov dl, 510/CharWidth         ;COLUMN
    mov bh, 0         
    mov bh, 00h
    int 10h

    MOV ah, 0
    MOV AL, CreationPower1
    call OUTPUT_NUM
    RET
display_CreationPower1 ENDP

display_speedup2 PROC
    mov ah, 2
    mov dh, 400/CharHeight + 2    ;ROW
    mov dl, 35/CharWidth         ;COLUMN
    mov bh, 0         
    mov bh, 00h
    int 10h

    MOV ah, 0
    MOV AL, SpeedUp2
    call OUTPUT_NUM
    RET
display_speedup2 ENDP

display_speedDown2 PROC
    mov ah, 2
    mov dh, 400/CharHeight + 2    ;ROW
    mov dl, 70/CharWidth         ;COLUMN
    mov bh, 0         
    mov bh, 00h
    int 10h

    MOV ah, 0
    MOV AL, SpeedDown2
    call OUTPUT_NUM
    RET
display_speedDown2 ENDP

display_Avoid2 PROC
    XOR AX, AX
    mov ah, 2
    mov dh, 400/CharHeight + 2    ;ROW
    mov dl, 100/CharWidth         ;COLUMN
    mov bh, 0         
    mov bh, 00h
    int 10h

    MOV ah, 0
    MOV AL, Avoid2
    call OUTPUT_NUM
    RET
display_Avoid2 ENDP

display_CreationPower2 PROC
    XOR AX, AX
    mov ah, 2
    mov dh, 400/CharHeight + 2    ;ROW
    mov dl, 130/CharWidth         ;COLUMN
    mov bh, 0         
    mov bh, 00h
    int 10h

    MOV ah, 0
    MOV AL, CreationPower2
    call OUTPUT_NUM
    RET
display_CreationPower2 ENDP

intiPos PROC 

    PUSH BX DX AX DX

    MOV BX,[pathx+0]
    MOV DX,[pathy+0]

    PUSH dx

    MOV AX,BX
    MOV BX,CELL_W 
    MUL BX
    ADD AX,CELL_W/2

    MOV X_POS,AX
    MOV AUX_X,AX
    MOV X_POS_2,AX
    MOV AUX_X_2,AX

    POP DX
    MOV AX,DX
    MOV DX,CELL_H
    MUL DX
    ADD AX,CELL_H/4

    MOV Y_POS,AX
    MOV AUX_Y,AX

    ADD AX,CELL_H/2

    MOV Y_POS_2,AX
    MOV AUX_Y_2,AX


    POP DX AX DX BX

    RET

intiPos ENDP

clearPos PROC

    ;CLEAR CAR 1
    MOV CX,X_POS
    MOV DX,Y_POS
    MOV AL,DIRS
    MOV AH,0
    CALL getDirctionParamaters
    CALL drawSpot

    ;CLEAR CAR 2
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
        MOV SI,OFFSET player2_down_left    
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
        MOV SI,OFFSET player2_left
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
        MOV SI,OFFSET player2_up_left
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
movePlayer1 PROC

    PUSH BX DX

    MOV BX,speed1_X
    MOV DX,speed1_Y

    MOV AL,CurrentState
    MOV PrevState,al
    MOV CurrentState,0

Controls1:
    checkUp:    
    ;if 'w' is pressed, move up
    CMP [KeyList + w], 1
    JNE checkDown
    mov MovingCar,1
    SUB AUX_Y,DX
    ADD CurrentState,2

    checkDown:
    ;if 's' is pressed, move down
    CMP [KeyList + s], 1
    JNE checkRight
    mov MovingCar,1
    ADD AUX_Y,DX
    ADD CurrentState,4

    checkRight:
    ;if 'd' is pressed, move right
    CMP [KeyList + d], 1
    JNE checkLeft
    mov MovingCar,1
    ADD AUX_X,BX
    ADD CurrentState,8

   ;if 'a' is pressed, move left
    checkLeft:
    CMP [KeyList + a], 1
    JNE checkSpeedingUp
    mov MovingCar,1
    SUB AUX_X,BX
    ADD CurrentState,16

    checkSpeedingUp:
    CMP [KeyList+q],1
    JNE checkSpeedingDown

    CMP SpeedUp1,0
    JE checkSpeedingDown
    CMP UseSpeedUp1,1
    JE checkSpeedingDown

    DEC SpeedUp1

    MOV UseSpeedUp1,1

    PUSHA
    MOV AH,2CH
    INT 21H
    MOV starttimeUP1,DH
    MOV counterup1,0
    POPA

    MOV speed1_X,IncreasedSpeed
    MOV speed1_Y,IncreasedSpeed

    checkSpeedingDown:
    CMP [KeyList + e],1
    JNE CheckAvoid

    CMP SpeedDown1,0
    JE CheckAvoid
    CMP UseSpeedDown1,1
    JE CheckAvoid

    DEC SpeedDown1
    MOV UseSpeedDown1,1
    PUSHA

    MOV AH,2CH
    INT 21H
    MOV starttimeDown1,DH
    MOV counterDown1,0
    POPA
    MOV speed2_X,DecreasedSpeed
    MOV speed2_Y,DecreasedSpeed

    CheckAvoid:
    CMP [KeyList + z],1
    JNE CheckCreate
    CMP Avoid1,0
    JE CheckCreate
    CMP UseAvoid1,1
    JE CheckCreate

    MOV UseAvoid1, 1
    DEC Avoid1

    CheckCreate:
    CMP [KeyList + xkey],1
    JNE CheckStartInline
    CMP CreationPower1,0
    JE CheckStartInline
    CALL DrawObstaclePower
    DEC CreationPower1
    MOV [KeyList + xkey],0

    CheckStartInline:
    CMP [KeyList + F],1
    JNE CHANGE_DIRECTION_1
    CALL DisplayInlineChat


CHANGE_DIRECTION_1:
    
    MOV AL,PrevState
    CMP AL,CurrentState
    JE VALIDATE1
    MOV AH,1
    CALL ChangeDirection_STATE

    VALIDATE1:
    call CheckOutOfRange ;CHECK OUT OF PATH AND OUT OF SCREEN

    pop DX BX
    RET

movePlayer1 ENDP

movePlayer2 PROC

    PUSH BX DX

    MOV BX,speed2_X
    MOV DX,speed2_Y

    MOV AL,CurrentState2
    MOV PrevState2,al
    MOV CurrentState2,0

Controls2:
    checkUp2:    
    ;if 'up' is pressed, move up
    CMP [KeyList + upArrow], 1
    JNE checkDown2
    mov MovingCar,2
    SUB AUX_Y_2,DX
    ADD CurrentState2,2

    checkDown2:
    ;if 'down' is pressed, move down
    CMP [KeyList + downArrow], 1
    JNE checkRight2
    mov MovingCar,2
    ADD AUX_Y_2,DX
    ADD CurrentState2,4

    checkRight2:
    ;if 'right' is pressed, move right
    CMP [KeyList + rightArrow], 1
    JNE checkLeft2
    mov MovingCar,2
    ADD AUX_X_2,BX
    ADD CurrentState2,8

    ;if 'left' is pressed, move left
    checkLeft2:
    CMP [KeyList + leftArrow], 1
    JNE checkSpeedingUp2
    mov MovingCar,2
    SUB AUX_X_2,BX
    ADD CurrentState2,16

    checkSpeedingUp2:
    CMP [KeyList+p],1
    JNE checkSpeedingDown2

    CMP SpeedUp2,0
    JE checkSpeedingDown2
    CMP UseSpeedUp2,1
    JE checkSpeedingDown2
    DEC SpeedUp2

    MOV UseSpeedUp2,1
    PUSHA
    MOV AH,2CH
    INT 21H
    MOV starttimeUP2,DH
    ; MOV counterup1,0
    POPA

    MOV speed2_X,IncreasedSpeed
    MOV speed2_Y,IncreasedSpeed

    checkSpeedingDown2:
    CMP [KeyList + o],1
    JNE CheckAvoid2

    CMP SpeedDown2,0
    JE CheckAvoid2
    CMP UseSpeedDown2,1
    JE CheckAvoid2
    DEC SpeedDown2
    MOV UseSpeedDown2,1
    PUSHA

    MOV AH,2CH
    INT 21H
    MOV starttimeDown2,DH
    POPA

    MOV speed1_X,DecreasedSpeed
    MOV speed1_Y,DecreasedSpeed

    CheckAvoid2:
    CMP [KeyList + Kkey],1
    JNE CheckCreate2

    CMP Avoid2,0
    JE CheckCreate2
    CMP UseAvoid2,1
    JE CheckCreate2
    MOV UseAvoid2,1
    DEC Avoid2

    CheckCreate2:
    CMP [KeyList + l],1
    JNE CHANGE_DIRECTION_2

    CMP CreationPower2,0
    JE CHANGE_DIRECTION_2
    CALL DrawObstaclePower2 
    DEC CreationPower2
    MOV [KeyList+l],0

CHANGE_DIRECTION_2:
    
    MOV AL,PrevState2
    CMP AL,CurrentState2
    JE VALIDATE2
    MOV AH,2
    CALL ChangeDirection_STATE

    VALIDATE2:
    call CheckOutOfRange2 ;CHECK OUT OF PATH AND OUT OF SCREEN AND OBSTACLES

    pop DX BX
    RET

movePlayer2 ENDP

ChangeDirection_STATE PROC 

    ;AL => DIRECTION
    ;AH => PLAYER

    CMP AH,1
    JNE DIR_PLAYER_2
    MOV BL,CurrentState
    JMP CHECK_DIRS

    DIR_PLAYER_2:
    MOV BL,CurrentState2

    CHECK_DIRS:
    CMP BL,30
    JNE next1    
    RET

    next1:
    CMP BL,14
    JNE next2
    MOV AL,Right_and
    JMP CHANGE    

    next2:
    CMP BL,22
    JNE next3
    MOV AL,Left_and
    JMP CHANGE

    next3:
    CMP BL,26
    JNE next4
    MOV AL,Up_and
    JMP CHANGE

    next4:
    CMP BL,28
    JNE next5
    MOV AL,Down_and
    JMP CHANGE

    next5:
    CMP BL,6
    JNE next6
    RET   

    next6:
    CMP BL,24
    JNE next8
    RET

    next8:
    CMP BL,20
    JNE next9
    MOV AL,Down_Left_and
    JMP CHANGE

    next9:
    CMP BL,12
    JNE next10
    MOV AL,Down_Right_and
    JMP CHANGE

    next10:
    CMP BL,18
    JNE next11
    MOV AL,Up_Left_and
    JMP CHANGE

    next11:
    CMP BL,10
    JNE next12
    MOV AL,Up_Right_and
    JMP CHANGE

    next12:
    CMP BL,16
    JNE next13
    MOV AL,Left_and
    JMP CHANGE

    next13:
    CMP BL,8
    JNE next14
    MOV AL,Right_and
    JMP CHANGE

    next14:
    CMP BL,4
    JNE next15
    MOV AL,Down_and
    JMP CHANGE

    next15:
    CMP BL,2
    JNE end_dir
    MOV AL,Up_and
    JMP CHANGE

    CHANGE:
    CMP AH,1
    JNE CHANGE2
    MOV AUX_DIR,AL
    RET

    CHANGE2:
    CMP AH,2
    JNE end_dir
    MOV AUX_DIR_2,AL
    RET

    end_dir:
    RET
ChangeDirection_STATE ENDP

CheckOutOfRange PROC  ;CX => ROW / DX => COLUMN /AX => DIR 


    MOV CX,AUX_X
    MOV DX,AUX_Y
    MOV AL,AUX_DIR
    MOV AH,0

    CALL getDirctionParamaters ; START_ROW/START COLUMN -> FIRST PIXEL  CX/DX ALSO ; AUX_IMAGE_HEIGHT/WIDTH

CHECK_OUF_OF_SCREEN:
    MOV AH,1
    call checkOutOfScreen

    CMP OUT_OF_SCREEN_BOOL,1
    JNE OUT_OF_PATH

    MOV OUT_OF_SCREEN_BOOL,0
    RET
    
OUT_OF_PATH:
    call CheckOoutOfPath
 
    CMP IN_PATH,1
    JE CHANGE_DIRECTION_2OUT

    OUT_OF_RANGE:
    MOV CX,X_POS
    MOV DX,Y_POS
    MOV AL,DIRS

    MOV AUX_X,CX
    MOV AUX_Y,DX
    MOV AUX_DIR,AL
    
    RET

    CHANGE_DIRECTION_2OUT:
    MOV AL,AUX_DIR
    MOV CX,AUX_X
    MOV DX,AUX_Y

    MOV X_POS,CX
    MOV Y_POS,DX        
    MOV DIRS,AL

    RET

CHECK_OBSTACLES:

CheckOutOfRange ENDP 

CheckOutOfRange2 PROC  ;CX => ROW / DX => COLUMN /AX => DIR 


    MOV CX,AUX_X_2
    MOV DX,AUX_Y_2
    MOV AL,AUX_DIR_2
    MOV AH,0

    CALL getDirctionParamaters ; START_ROW/START COLUMN -> FIRST PIXEL  CX/DX ALSO ; AUX_IMAGE_HEIGHT/WIDTH

CHECK_OUF_OF_SCREEN2:
    call checkOutOfScreen

    CMP OUT_OF_SCREEN_BOOL,1
    JNE OUT_OF_PATH2

    MOV OUT_OF_SCREEN_BOOL,0
    RET
    
OUT_OF_PATH2:
    MOV AH,2
    call CheckOoutOfPath2
 
    CMP IN_PATH,1
    JE CHANGE_DIRECTION_1OUT

    OUT_OF_RANGE2:
    MOV CX,X_POS_2
    MOV DX,Y_POS_2
    MOV AL,DIRS2

    MOV AUX_X_2,CX
    MOV AUX_Y_2,DX
    MOV AUX_DIR_2,AL
    
    RET

    CHANGE_DIRECTION_1OUT:
    MOV AL,AUX_DIR_2
    MOV CX,AUX_X_2
    MOV DX,AUX_Y_2

    MOV X_POS_2,CX
    MOV Y_POS_2,DX        
    MOV DIRS2,AL

    RET

CHECK_OBSTACLES2:

CheckOutOfRange2 ENDP 

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

        CMP AL,border_color
        JE NOT_VALID

        ;CHECK OBSTACLES
        CMP AL,04H
        JNE CheckAgain4
        CMP UseAvoid1,1
        JNE NOT_VALID
        CALL AvoidObstacle
        MOV UseAvoid1,0

        ;CHECK SPEED UP
        CheckAgain4:
        CMP AL,SpeedUpColor
        JNZ CheckAgain
        INC SpeedUp1
        call ClearPwr

        ;CHECK SPEED DOWN
        CheckAgain:
        CMP AL,SpeedDownColor
        JNZ CheckAgain1
        MOV FoundSpeedDown1,1
        CALL ClearPwr

        ;CHECK CREATE OBSTACLES
        CheckAgain1:
        CMP AL,CreateObstaclColor
        JNZ CheckAgain2

        ; CALL DrawObstaclePower
        INC CreationPower1
        CALL ClearPwr

        CheckAgain2:
        CMP AL,AvoidObstaclColor
        JNZ CheckAgain3
        INC Avoid1
        CALL ClearPwr
        
        CheckAgain3:
        ; CMP AL,0fh
        ; JNE AAAAAAAAAAAA
        ; MOV PLAYER1_WIN,1

        AAAAAAAAAAAA:
        ;COMPLETE LOOP
        INC CX
        CMP CX,SI
        JNE _DRAW_PIXELS_

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE _DRAW_PIXELS_

    ; CMP FoundSpeedUp,1
    ; JNE NoSpeedUp

    ; ; inc SpeedUp1
    ; mov FoundSpeedUp,0

    NoSpeedUp:

    CMP FoundSpeedDown1,1
    JNE NoSpeedDown

    inc SpeedDown1
    MOV FoundSpeedDown1,0

    NoSpeedDown:
    MOV IN_PATH,1
    POPA
    
    RET
    
    NOT_VALID:
    MOV IN_PATH,0
    POPA
    
    RET

CheckOoutOfPath ENDP

CheckOoutOfPath2 PROC 

    PUSHA

    MOV CX,[START_COLUMN]
    MOV DX,[START_ROW]

    MOV SI,CX
    ADD SI,[AUX_IMAGE_WIDTH]

    MOV DI,DX
    ADD DI,[AUX_IMAGE_HEIGHT]


    MOV AH,0DH    
    MOV BH,0
    _DRAW_PIXELS_2:
        INT 10H

        ;CHECK BACKGROUND
        CMP AL,00h
        JE  NOT_VALID2

        CMP AL,border_color
        JE NOT_VALID2

        ;CHECK OBSTACLES
        CMP AL,04H
        JNE CheckAgain24
        CMP UseAvoid2,1
        JNE NOT_VALID2
        CALL AvoidObstacle2
        MOV UseAvoid2,0

        ;CHECK SPEED UP
        CheckAgain24:
        CMP AL,SpeedUpColor
        JNZ CheckAgain22_
        INC SpeedUp2
        call ClearPwr

        ;CHECK SPEED DOWN
        CheckAgain22_:
        CMP AL,SpeedDownColor
        JNZ CheckAgain21
        MOV FoundSpeedDown2,1
        CALL ClearPwr

        ;CHECK CREATE OBSTACLES
        CheckAgain21:
        CMP AL,CreateObstaclColor
        JNZ CheckAgain22
        INC CreationPower2
        CALL ClearPwr

        CheckAgain22:
        CMP AL,AvoidObstaclColor
        JNZ CheckAgain23
        INC Avoid2
        CALL ClearPwr
        
        CheckAgain23:
        ; CMP AL,0fh
        ; JNE AAAAAAAAAAA
        ; MOV PLAYER2_WIN,1

        AAAAAAAAAAA:
        ;COMPLETE LOOP
        INC CX
        CMP CX,SI
        JNE _DRAW_PIXELS_2

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE _DRAW_PIXELS_2

    ; CMP FoundSpeedUp2,1
    ; JNE NoSpeedUp2

    ; inc SpeedUp2
    ; mov FoundSpeedUp2,0

    NoSpeedUp2:
    CMP FoundSpeedDown2,1
    JNE NoSpeedDown2

    inc SpeedDown2
    mov FoundSpeedDown2,0

    NoSpeedDown2:

    MOV IN_PATH,1
    POPA
    
    RET
    
    NOT_VALID2:
    MOV IN_PATH,0
    POPA
    
    RET

CheckOoutOfPath2 ENDP

DrawObstaclePower PROC
    PUSHA  

    MOV DX,Y_POS
    MOV CX,X_POS

    cmp DIRS,Up_and
    JNE try1
    ADD dx,[AUX_IMAGE_HEIGHT]
    ; ADD dx,[AUX_IMAGE_HEIGHT]


    JMP DrawObstaclePowerLabel
    try1:
    CMP DIRS,Left_and
    JNZ try2
    ADD CX,[AUX_IMAGE_HEIGHT]
    ; ADD CX,[AUX_IMAGE_HEIGHT]

    JMP DrawObstaclePowerLabel

    try2:
    CMP DIRS,Right_and
    JNE DOWNTRIAL1
    SUB CX,[AUX_IMAGE_HEIGHT]
    ; SUB CX,[AUX_IMAGE_HEIGHT]

    SUB CX,powerlength

    JMP DrawObstaclePowerLabel
    DOWNTRIAL1:
    CMP DIRS,Down_and
    JNE NOOBSTACLE
    SUB DX,[AUX_IMAGE_HEIGHT]
    ; SUB DX,[AUX_IMAGE_HEIGHT]

    SUB DX,powerlength

    MOV AH,0DH
    INT 10H
    CMP AL,TrackColor
    JNZ NOOBSTACLE

    DrawObstaclePowerLabel:
    MOV AL,ObstacleColor
    MOV DI,DX 
    ADD DI,powerlength

    MOV BX,CX
    ADD BX,powerlength


;    MOV BH,0
    MOV AH,0CH
    ob: 
    obs:
        INT 10H
        INC DX
        CMP DX,DI
        JNZ obs  
    MOV DX,DI
    SUB DX,powerlength
    INC CX
    CMP CX,BX
    JNZ ob 
    NOOBSTACLE:
    POPA
    RET
DrawObstaclePower ENDP

AvoidObstacle PROC
    PUSH DX
    TRYFIR:
    cmp DIRS,Down_and
    JNE tri11
    ADD DX,powerlength
    ADD DX,powerlength
    ADD DX,powerlength
    ADD DX,powerlength

    MOV Y_POS,DX
    tri11:
    CMP DIRS,Up_and
    JNE TRI22
    SUB DX,[AUX_IMAGE_HEIGHT]
    ADD DX,powerlength
    mov Y_POS,dx
    TRI22:
    CMP DIRS,Left_and
    JNE TRI33
    SUB CX,[AUX_IMAGE_HEIGHT]
    SUB CX,powerlength
    mov X_POS,CX
    TRI33:
    CMP DIRS,Right_and
    JNE TRI44
    ADD CX,powerlength
    ADD CX,powerlength
    ADD CX,powerlength
    ADD CX,powerlength

    MOV X_POS,CX
    TRI44:
    mov bh,0
    mov ah,0DH
    int 10h
    CMP AL,TrackColor
    JZ PositionDone

     MOV DX,PrevX1
    MOV CX,PREVY1
    MOV X_POS,DX
    MOV AUX_X,DX
    MOV Y_POS,CX
    MOV AUX_Y,CX

    PositionDone:
    POP DX
    RET
AvoidObstacle ENDP

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

    CMP AH,1
    JNE SCREEN2

    MOV AUX_X,CX
    MOV AUX_Y,DX

    MOV X_POS,CX
    MOV Y_POS,DX

    RET

    SCREEN2:

    MOV AUX_X_2,CX
    MOV AUX_Y_2,DX

    MOV X_POS_2,CX
    MOV Y_POS_2,DX

    RET

    VALID:

    MOV OUT_OF_SCREEN_BOOL,0
    RET

    RET

checkOutOfScreen endp

drawSpot PROC

    MOV AL,TrackColor

    MOV CX,[START_COLUMN]
    MOV DX,[START_ROW]

    MOV SI,CX
    ADD SI,[AUX_IMAGE_WIDTH]

    MOV DI,DX
    ADD DI,[AUX_IMAGE_HEIGHT]


    MOV AH,0CH    
    MOV BH,0
    _DRAW_PIXELS_2_:
        INT 10H
        INC CX
        CMP CX,SI
        JNE _DRAW_PIXELS_2_

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE _DRAW_PIXELS_2_

    RET

drawSpot ENDP

DrawObstaclePower2 PROC
    PUSHA  

    MOV DX,Y_POS_2
    MOV CX,X_POS_2

    cmp DIRS2,Up_and
    JNE try11
    ADD dx,[AUX_IMAGE_HEIGHT]

    JMP DrawObstaclePowerLabel2
    try11:
    CMP DIRS2,Left_and
    JNZ try22
    ADD CX,[AUX_IMAGE_HEIGHT]

    JMP DrawObstaclePowerLabel2

    try22:
    CMP DIRS2,Right_and
    JNE DOWNTRIAL
    SUB CX,[AUX_IMAGE_HEIGHT]
    SUB CX,powerlength


    JMP DrawObstaclePowerLabel2
    DOWNTRIAL:
    CMP DIRS2,Down_and
    JNE NONNNN
    SUB DX,[AUX_IMAGE_HEIGHT]

    SUB DX,powerlength


    MOV BH,0
    MOV AH,0DH
    INT 10H
    CMP AL,TrackColor
    JNZ NONNNN

    DrawObstaclePowerLabel2:
    MOV AL,ObstacleColor
    MOV DI,DX 
    ADD DI,powerlength

    MOV BX,CX
    ADD BX,powerlength



    MOV AH,0CH
    ob2: 
    obs2:
        INT 10H
        INC DX
        CMP DX,DI
        JNZ obs2  
    MOV DX,DI
    SUB DX,powerlength
    INC CX
    CMP CX,BX
    JNZ ob2 
    NONNNN:
    POPA
    RET
DrawObstaclePower2 ENDP

AvoidObstacle2 PROC
    PUSH DX
    TRYFIRR:
    cmp DIRS2,Down_and
    JNE tri111
    ADD DX,powerlength
    ADD DX,powerlength
    ADD DX,powerlength
    ADD DX,powerlength

    MOV Y_POS_2,DX
    tri111:
    CMP DIRS2,Up_and
    JNE TRI222
    SUB DX,[AUX_IMAGE_HEIGHT]
    ADD DX,powerlength
    mov Y_POS_2,dx
    TRI222:
    CMP DIRS2,Left_and
    JNE TRI333
    SUB CX,[AUX_IMAGE_HEIGHT]
    SUB CX,powerlength
    mov X_POS_2,CX
    TRI333:
    CMP DIRS2,Right_and
    JNE TRI444
    ADD CX,powerlength
    ADD CX,powerlength
    ADD CX,powerlength
    ADD CX,powerlength

    MOV X_POS_2,CX
    TRI444:

    mov bh,0
    mov ah,0DH
    int 10h
    CMP AL,TrackColor
    JZ PositionDone2

    MOV DX,PrevX2
    MOV CX,PREVY2
    MOV X_POS_2,DX
    MOV Y_POS_2,CX
    MOV AUX_X_2,DX
    MOV AUX_Y_2,CX

    PositionDone2:
    POP DX
    RET
AvoidObstacle2 ENDP

FinalValidation PROC
    PUSHA

    MOV DX,X_POS
    MOV CX,Y_POS
    CALL SetFourCorners
    call checkintersection
    CMP CarIntersect,1
    JNZ NOINTERSECTION

    CMP MovingCar,1
    JNZ SecondMoving
    MOV DX,PrevX1
    MOV CX,PREVY1
    MOV X_POS,DX
    MOV AUX_X,DX
    MOV Y_POS,CX
    MOV AUX_Y,CX
    JMP NOINTERSECTION

    SecondMoving:
    MOV DX,PrevX2
    MOV CX,PREVY2
    MOV X_POS_2,DX
    MOV Y_POS_2,CX
    MOV AUX_X_2,DX
    MOV AUX_Y_2,CX

    NOINTERSECTION:

    MOV CarIntersect,0
    MOV FirstVertical,0
    MOV SecondVertical,0


    POPA
    RET
    FinalValidation ENDP

checkintersection PROC
    PUSHA
    MOV AX,CornerTLRow
    MOV BX,CornerTLCol

    CALL CHECKINSIDESECOND

    CMP CarIntersect,1
    JZ INTERSECTION

    MOV AX,CornerTRRow
    MOV BX,CornerTRCol

    CALL CHECKINSIDESECOND

    CMP CarIntersect,1
    JZ INTERSECTION

    MOV AX,CornerBLRow
    MOV BX,CornerBLCol

    CALL CHECKINSIDESECOND

    CMP CarIntersect,1
    JZ INTERSECTION

    MOV AX,CornerBRRow
    MOV BX,CornerBRCol

    CALL CHECKINSIDESECOND

    CMP CarIntersect,1
    JZ INTERSECTION

    INTERSECTION:

    POPA
    RET
    checkintersection ENDP

CHECKINSIDESECOND PROC

    CMP AX,CornerTLRow2
    JC NOTINSIDE
    CMP AX,CornerBLRow2
    JNC NOTINSIDE
    CMP BX,CornerTLCol2
    JC NOTINSIDE
    CMP BX,CornerBRCol2
    JNC NOTINSIDE

    MOV CarIntersect,1

    NOTINSIDE:

    RET
    CHECKINSIDESECOND ENDP

;;Y ROW   
SetFourCorners PROC
    PUSHA
    MOV AX,X_POS ;;;AX&DX   X   COL
    MOV BX,Y_POS ;;;BX&CX   Y   ROW

    CMP DIRS,Up_and
    JNE CheckVerAgain
    MOV FirstVertical,1

    CheckVerAgain:
    CMP DIRS,Down_and
    JNE HORIZONTALL
    MOV FirstVertical,1
    JMP CalcCorners

    HORIZONTALL:
    Mov FirstVertical,0

    CalcCorners:
    CALL CalcCornersFUN

    CMP DIRS2,Up_and
    JNE CheckVerAgain2
    MOV SecondVertical,1

    CheckVerAgain2:
    CMP DIRS2,Down_and
    JNE HORIZONTAL2
    MOV SecondVertical,1

    MOV AX,X_POS_2
    MOV BX,Y_POS_2
    JMP CalcCorners2

    HORIZONTAL2:
    Mov SecondVertical,0

    CalcCorners2:
    MOV AX,X_POS_2
    MOV BX,Y_POS_2
    CALL CalcCorners2FUN 

    POPA
    RET
SetFourCorners ENDP

CalcCornersFUN PROC
    CMP FirstVertical,1
    JNZ HOR  
    MOV CornerTLRow,BX
    SUB CornerTLRow,17
    MOV CornerTLCol,AX
    SUB CornerTLCol,9

    MOV CornerTRRow,BX
    SUB CornerTRRow,17
    MOV CornerTRCol,AX
    ADD CornerTRCol,9

    MOV CornerBLRow,BX
    ADD CornerBLRow,17
    MOV CornerBLCol,AX
    SUB CornerBLCol,9

    MOV CornerBRRow,BX
    ADD CornerBRRow,17
    MOV CornerBRCol,AX
    ADD CornerBRCol,9

    JMP CALC1DONE

    HOR:
    MOV CornerTLRow,BX
    SUB CornerTLRow,9
    MOV CornerTLCol,AX
    SUB CornerTLCol,17

    MOV CornerTRRow,BX
    SUB CornerTRRow,9
    MOV CornerTRCol,AX
    ADD CornerTRCol,17

    MOV CornerBLRow,BX
    ADD CornerBLRow,9
    MOV CornerBLCol,AX
    SUB CornerBLCol,17

    MOV CornerBRRow,BX
    ADD CornerBRRow,9
    MOV CornerBRCol,AX
    ADD CornerBRCol,17
    CALC1DONE:
    RET
    CalcCornersFUN ENDP

CalcCorners2FUN PROC
CMP SecondVertical,1
JNZ HOR2  
MOV CornerTLRow2,BX
SUB CornerTLRow2,17
MOV CornerTLCol2,AX
SUB CornerTLCol2,9

MOV CornerTRRow2,BX
SUB CornerTRRow2,17
MOV CornerTRCol2,AX
ADD CornerTRCol2,9

MOV CornerBLRow2,BX
ADD CornerBLRow2,17
MOV CornerBLCol2,AX
SUB CornerBLCol2,9

MOV CornerBRRow2,BX
ADD CornerBRRow2,17
MOV CornerBRCol2,AX
ADD CornerBRCol2,9

JMP CALC2DONE

HOR2:
MOV CornerTLRow2,BX
SUB CornerTLRow2,9
MOV CornerTLCol2,AX
SUB CornerTLCol2,17

MOV CornerTRRow2,BX
SUB CornerTRRow2,9
MOV CornerTRCol2,AX
ADD CornerTRCol2,17

MOV CornerBLRow2,BX
ADD CornerBLRow2,9
MOV CornerBLCol2,AX
SUB CornerBLCol2,17

MOV CornerBRRow2,BX
ADD CornerBRRow2,9
MOV CornerBRCol2,AX
ADD CornerBRCol2,17
CALC2DONE:
RET
CalcCorners2FUN ENDP

displayTime     PROC
    PUSHA
    ; MOV DX,TimeRow
    ; MOV CX,TimeCol

    MOV AH,2
    MOV DX,0
    INT 10H

    MOV BL,10
    MOV AX,TimeMin
    DIV BL
    MOV BH,AH

    MOV DL,AL
    ADD DL,30H
    MOV AH,2 
    INT 21H

    MOV DL,BH
    ADD DL,30H
    MOV AH,2 
    INT 21H

    MOV DL,':'
    MOV AH,2 
    INT 21H

    MOV BL,10
    MOV AX,TimeSec
    DIV BL
    MOV BH,AH

    MOV DL,AL
    ADD DL,30H
    MOV AH,2 
    INT 21H

    MOV DL,BH
    ADD DL,30H
    MOV AH,2 
    INT 21H

    POPA
    RET
    displayTime ENDP

display_percentage PROC
    PUSHA

    MOV DI,X_POS
    MOV SI,Y_POS
    CALL findCarRemSteps

    MOV BX,100
    MOV AX,carIndex
    MUL BX
    ;DIV Path_Length
    DIV Path_Length_dec
    
    mov ah, 2
    mov dh, 470/CharHeight    ;ROW
    mov dl, 70                               ;COLUMN
    mov bh, 0         
    int 10h
    ;Al IS THE PERCENTAGE OF THE PATH OF PLAYER 1
    MOV AH,0

    MOV num,AX
    CALL OUTPUT_NUM
    

    MOV DI,X_POS_2
    MOV SI,Y_POS_2
    CALL findCarRemSteps

    MOV BX,100
    MOV AX,carIndex
    MUL BX
    DIV Path_Length_dec


    mov ah, 2
    mov dh, 470/CharHeight    ;ROW
    mov dl, 5                               ;COLUMN
    mov bh, 0         
    int 10h
    ;AL IS THE PERCENTAGE OF THE PATH OF PLAYER2
    MOV AH,0

    MOV num,AX
    CALL OUTPUT_NUM

    POPA

    RET
display_percentage ENDP

OUTPUT_NUM PROC
    mov bl,100
    div bl
    mov dl,al
    push ax
    add dl,30h
    mov ah,02h
    int 21h
    pop ax
    mov bl,10
    mov al,ah
    mov ah,0
    div bl
    mov dl,al
    push ax
    add dl,30h 
    mov ah,02h
    int 21h
    pop ax
    mov dl,ah 
    add dl,30h 
    mov ah,02h
    int 21h
    RET
OUTPUT_NUM ENDP





checkEndGame PROC 
    ;PLAYER1
    MOV AL,DIRS
    MOV AH,0
    MOV CX,Y_POS
    MOV DX,X_POS
    CALL getDirctionParamaters    

    ;FRONT CORNER
    ADD CX,[SUB_HEIGHT]
    ADD DX,[SUB_WIDTH]

    CALL checkEndRange
    cmp AUX_BOOL,1
    JE  FIRST_WIN
    ; DO SOMETHING

    ;SECOND CORNER
    SUB DX,[AUX_IMAGE_WIDTH]

    CALL checkEndRange
    cmp AUX_BOOL,1
    JE  FIRST_WIN

    ;PlAYER2
    MOV AL,DIRS2
    MOV AH,0
    MOV CX,Y_POS_2
    MOV DX,X_POS_2
    CALL getDirctionParamaters

    ;FRONT CORNER
    ADD CX,[SUB_HEIGHT]
    ADD DX,[SUB_WIDTH]

    CALL checkEndRange
    cmp AUX_BOOL,1
    JE  SECOND_WIN

    ;SECOND CORNER
    SUB DX,[AUX_IMAGE_WIDTH]

    CALL checkEndRange
    cmp AUX_BOOL,1
    JE  SECOND_WIN

    JMP JUST_END

    FIRST_WIN:
    MOV PLAYER1_WIN,1

    SECOND_WIN:
    MOV PLAYER2_WIN,1

    JUST_END:
    RET

checkEndGame ENDP

checkEndRange PROC ;CX => ROW / DX => COLUMN


RANGE_Y:
    CMP CX,END_END_Y
    JNB END_NOT

    CMP CX,END_START_Y
    JNA END_NOT

RANGE_X:
    CMP DX,END_END_X
    JNB END_NOT

    CMP DX,END_START_X
    JNA END_NOT

    MOV AUX_BOOL,1
    RET

    END_NOT:
    MOV AUX_BOOL,0

    
    RET
checkEndRange ENDP

CalcEnd PROC

    MOV BX,Path_Length
    ADD BX,Path_Length
    SUB BX,2

    MOV CX,[pathx+BX]
    MOV DX,[pathy+BX]


    ;CALCULATE X POSES
    PUSH dx

    MOV DX,0
    MOV AX,CELL_W
    MUL CX

    MOV END_START_X,AX
    ADD AX,CELL_W
    MOV END_END_X,AX

    POP dx

    ;CALCULATE Y POSES
    MOV AX,CELL_H
    MUL DX

    MOV END_START_Y,AX
    ADD AX,CELL_H
    MOV END_END_Y,AX

    RET

CalcEnd ENDP

;description
load_players_cars PROC
    CMP player1_character, 1
    JNE player1_checkCar2
    call loadFlameCarForOne
    JMP Get_Player2_Car
   
    player1_checkCar2:
    CMP player1_character, 2
    JNE player1_checkCar3
    CALL loadRedCarForOne
    JMP Get_Player2_Car

    player1_checkCar3:
    CMP player1_character, 3
    JNE player1_checkCar4
    call loadBlueCarForOne
    JMP Get_Player2_Car

    player1_checkCar4:
    CALL loadYellowCarForOne


    Get_Player2_Car:
    CMP player2_character, 1
    JNE player2_checkCar2
    call loadFlameCarForTwo
    JMP End_load_Cars
   
    player2_checkCar2:
    CMP player2_character, 2
    JNE player2_checkCar3
    CALL loadRedCarForTwo
    JMP End_load_Cars

    player2_checkCar3:
    CMP player2_character, 3
    JNE player2_checkCar4
    call loadBlueCarForTwo
    JMP End_load_Cars

    player2_checkCar4:
    CALL loadYellowCarForTwo

    End_load_Cars:
    RET
load_players_cars ENDP

drawGreenPowerUp PROC
        MOV DX, offset greenPower_file_name
        MOV DI, offset greenPower_file_handle
        call openFile

        MOV CX, greenPower_file_size
        MOV DX, offset greenPower_file
        MOV BX, [greenPower_file_handle]
        call ReadFileToMemory

        MOV SI, offset greenPower_file
        MOV AX, starting_row
        MOV [START_ROW], AX
         MOV AX, starting_column
        MOV [START_COLUMN], AX
        MOV [AUX_IMAGE_HEIGHT], greenPower_height
        MOV [AUX_IMAGE_WIDTH], greenPower_width
        CALL drawImage
        RET
    drawGreenPowerUp ENDP

    drawRedPowerUp PROC
    MOV DX, offset redPower_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, redPower_file_size
    MOV DX, offset redPower_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset redPower_file
    MOV AX, red_powerup_starting_row
    MOV [START_ROW], AX
    MOV AX, red_powerup_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], redPower_height
    MOV [AUX_IMAGE_WIDTH], redPower_width
    CALL drawImage
    RET
    drawRedPowerUp ENDP

    drawBluePowerUp PROC
    MOV DX, offset bluePower_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, bluePower_file_size
    MOV DX, offset bluePower_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset bluePower_file
    MOV AX, blue_powerup_starting_row
    MOV [START_ROW], AX
    MOV AX, blue_powerup_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], bluePower_height
    MOV [AUX_IMAGE_WIDTH], bluePower_width
    CALL drawImage
    RET
    drawBluePowerUp ENDP

    drawEvilPowerUp PROC
    MOV DX, offset evilPower_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, evilPower_file_size
    MOV DX, offset evilPower_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset evilPower_file
    MOV AX, evil_powerup_starting_row
    MOV [START_ROW], AX
    MOV AX, evil_powerup_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], evilPower_height
    MOV [AUX_IMAGE_WIDTH], evilPower_width
    CALL drawImage
    RET
drawEvilPowerUp ENDP

;description
draw_All_Powers PROC
    ; Mov starting_row, 350
    ; Mov starting_row, 600

   
    call drawEvilPowerUp
    call drawRedPowerUp
    call drawBluePowerUp
    call drawGreenPowerUp
draw_All_Powers ENDP

Chat_Box_asmaa PROC
        mov cx, chat_starting_column        ;Column
        mov dx, chat_starting_row           ;Row
        mov al, BackgroundColor             ;Pixel color
        mov ah, 0CH                         ;Draw Pixel Command

        chat_horizontal: int 10H
        INC CX
        MOV BX, CX
        SUB BX, chat_starting_column
        CMP BX, chat_width
        JNZ chat_horizontal

        MOV CX, chat_starting_column
        INC DX
        MOV BX, DX
        SUB BX, chat_starting_row
        CMP BX, chat_length
        JNZ chat_horizontal
        RET
Chat_Box_asmaa ENDP

DisplayInlineChat proc
pusha

AGAINinline:
             mov  dl,20
             mov  dh,25
             mov  ah,2
             int  10h

             CALL CHECKRECIEVE

             CMP RecieveFlag,1
             JNE SENDLOPinline

             call RecieveByte

             MOV  DL,DataIn
             MOV  AH,2
             INT  21H

            CMP DataIn,0DH
            JNZ NEX
            jmp doneinline
            NEX:

            mov ah,3h
            mov bh,0h
            int 10h

            CMP dh,30
            JNZ skip1in
            call Chat_Box_asmaa
            skip1in:

             JMP  AGAINinline

    SENDLOPinline:

             mov  dl,20  ;c
             mov  dh,29
             mov  ah,2
             int  10h

             mov  ah,01h
             int  16h
             jz   AGAINinline

             mov  ah,00H
             int  16h
             mov  bl,al
             MOV DataOut,AL

             mov  dl,bl
             mov  ah,2
             INT  21H

             CALL CHECKSEND
             call sendbyte


             CMP BL,0DH
            jz doneinline

            mov ah,3h
            mov bh,0h
            int 10h

            CMP dh,30
            JNZ skip1in2
            call Chat_Box_asmaa
            skip1in2:
             JMP  SENDLOPinline
    doneinline:
    call Chat_Box_asmaa
    popa
ret
DisplayInlineChat endp