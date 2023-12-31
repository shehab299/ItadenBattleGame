;AUTHOR : SHEHAB KHALED

;---------------------------------------
.MODEL SMALL

.STACK 32
.286
;---------------------------------------
.DATA

include const.inc
include cars.inc
include img.inc 
include data.inc


FiveSecondsCount DB 0
SECONDS DB 0

;ADDRESS VECTOR FOR INTERRUPTS
INT09_BX DW ?
INT09_ES DW ?

;KEYBOARD BUFFERS

KeyList db 128 dup(0)

;AUX VARIABLES
AUX_IMAGE_WIDTH dw ?
AUX_IMAGE_HEIGHT dw ? 
START_ROW dw ?


;GENERAL FILES

file_buffer db 20000 dup(?)



;validate names


;---------------------------------------
.code

include files.inc ;File and image handling
include UI.inc ;UI
include keyboard.inc ;FOR KEYBOARD CONFIGURATION
include loadCars.inc
include grid.inc
include loop_m.inc


MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX

    ;SET VIDEO MODE

   
    MOV AX,VIDEO_MODE
    MOV BX,VIDEO_MODE_BX
    INT 10H


    ; call clearUnderOwl
   
    ;ENTER NAMES
    Names:

    
    call setBackgroundColor
    call loadLogo
    call drawpPlayerInfo
    call getInfo
    
    ;WELCOME PAGE
    BEGIN:
    
    call setBackgroundColor
    call loadLogo
    call drawWelcomePage


    ;TAKE KEY FROM USER
    CHK_KEY:
    MOV AH,0
    INT 16H

    CMP AH,EscKey
    JE CLOSE

    CMP AH, F2
    JNE CHK_KEY



    ;CHOOSE CHARACTER
    CHOOSE_LBL:

    CALL loadSmallOwl

    MOV BX, owl_current_row
    
    CALL drawPage

    CALL Choose
   
    ;TAKE CHARACTERS AND STORE THEM

    ; call setBackgroundColor

    ;START THE GAME

    ; call ConfigKeyboard

    call MAIN_LOOP
    call wait5sec
    CALL ResetKeyboard
    JMP BEGIN


    HLT

    CLOSE:
    MOV AH,4CH
    INT 21H

MAIN ENDP

getInfo PROC
;PLAYER 1 NAME
    CHECK_PLAYER1_NAME:
    mov dh, player1_y/CharHeight + 2    ;ROW
    mov dl, player1_x/CharWidth     ;COLUMN
    mov bh, 0      ; Page = 0
    mov bl, BackgroundColor
    mov ah, 02h    ; BIOS.SetCursorPosition
    int 10h   

    mov ah, 0AH
    mov dx, offset player1_name
    int 21h

    MOV AL, player1_name + 1
    CMP AL, 0
    JNE CHECK_first_character

    call emptyNameMsg
    call clear_input1
    wait_for_Enterr:
    MOV AH, 0
    INT 16H
    CMP AH, EnterKey
    JNE wait_for_Enterr
    call clear_warnings
    JMP CHECK_PLAYER1_NAME


    CHECK_first_character:
    MOV AL, player1_name + 2
    CMP AL, UPPERCASE_MIN_ASCII
    JB INVALID_NAME
    CMP AL, LOWERCASE_MAX_ASCII
    JA INVALID_NAME
    CMP AL, UPPERCASE_MAX_ASCII
    JA CHECK_IF_LESS_97
    JMP CHECK_PLAYER2_name
    CHECK_IF_LESS_97:
        CMP AL, LOWERCASE_MIN_ASCII
        JB INVALID_NAME
        JMP CHECK_PLAYER2_name
    
    INVALID_NAME:
    call clear_input1
    Call invalid_Msg
    wait_for_Enter:
    MOV AH, 0
    INT 16H
    CMP AH, EnterKey
    JNE wait_for_Enter
    call clear_warnings

    JMP CHECK_PLAYER1_NAME

    ;PLAYER 2 NAME
    CHECK_PLAYER2_name:
    mov dh, player2_y/CharHeight + 2    ;ROW
    mov dl, player2_x/CharWidth         ;COLUMN
    mov bh, 0                           ;Page = 0
    mov bl, BackgroundColor
    mov ah, 02h                         ;BIOS.SetCursorPosition
    int 10h

    ;take input form the user
    mov ah, 0AH
    mov dx, offset player2_name
    int 21h

    MOV AL, player2_name + 1
    CMP AL, 0
    JNE CHECK_first_character2

    call clear_input2
    call emptyNameMsg
    wait_for_Enterr2:
    MOV AH, 0
    INT 16H
    CMP AH, EnterKey
    JNE wait_for_Enterr2
    call clear_warnings
    JMP CHECK_PLAYER2_NAME

    CHECK_first_character2:
    MOV AL, player2_name + 2
    CMP AL, UPPERCASE_MIN_ASCII
    JB INVALID_NAME2
    CMP AL, LOWERCASE_MAX_ASCII
    JA INVALID_NAME2
    CMP AL, UPPERCASE_MAX_ASCII
    JA CHECK2_IF_LESS_97
    JMP EXTI_GET_INFO
    CHECK2_IF_LESS_97:
        CMP AL, LOWERCASE_MIN_ASCII
        JB INVALID_NAME2
        JMP EXTI_GET_INFO
    
    INVALID_NAME2:
    call clear_input2
    call invalid_Msg
    wait_for_Enter2:
    MOV AH, 0
    INT 16H
    CMP AH, EnterKey
    JNE wait_for_Enter2
    call clear_warnings
    JMP CHECK_PLAYER2_NAME

    
    EXTI_GET_INFO:
    RET
getInfo ENDP

ExitProg Proc
    mov ah,4ch
    int 21h
ExitProg ENDP

emptyNameMsg PROC
    MOV DX, offset emptyName_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, emptyName_file_size
    MOV DX, offset emptyName_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset emptyName_file
    MOV AX, emptyName_starting_row
    MOV [START_ROW], AX
    MOV AX, emptyName_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], emptyName_height
    MOV [AUX_IMAGE_WIDTH], emptyName_width
    CALL drawImage
    RET
emptyNameMsg ENDP

invalid_Msg PROC
    MOV DX, offset firstCharCheck_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, firstCharCheck_file_size
    MOV DX, offset firstCharCheck_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset firstCharCheck_file
    MOV AX, firstCharCheck_starting_row
    MOV [START_ROW], AX
    MOV AX, firstCharCheck_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], firstCharCheck_height
    MOV [AUX_IMAGE_WIDTH], firstCharCheck_width
    CALL drawImage
    RET
invalid_Msg ENDP

clear_input1 PROC
    mov cx, 64                ;Column
    mov dx, 290               ;Row
    mov al, BackgroundColor   ;Pixel color
    mov ah, 0ch               ;Draw Pixel Command
    clear_text1: int 10h
    INC CX
    MOV BX, CX
    SUB BX, 182
    CMP BX, 66
    JNZ clear_text1

    MOV CX, 64
    INC DX
    MOV BX, DX
    SUB BX, 32
    CMP BX, 290
    JNZ clear_text1
    RET
clear_input1 ENDP

clear_input2 PROC
    mov cx, 367                 ;Column
    mov dx, 290                 ;Row
    mov al, BackgroundColor     ;Pixel color
    mov ah, 0ch                 ;Draw Pixel Command
    clear_text2: int 10h
    INC CX
    MOV BX, CX
    SUB BX, 182
    CMP BX, 367
    JNZ clear_text2

    MOV CX, 367
    INC DX
    MOV BX, DX
    SUB BX, 32
    CMP BX, 290
    JNZ clear_text2
    RET
clear_input2 ENDP

clear_warnings PROC
    mov cx, emptyName_starting_column        ;Column
    mov dx, emptyName_starting_row           ;Row
    mov al, BackgroundColor                  ;Pixel color
    mov ah, 0ch                              ;Draw Pixel Command
    clear_msgs: int 10h
    INC CX
    MOV BX, CX
    SUB BX, emptyName_width
    CMP BX, emptyName_starting_column + 2
    JNZ clear_msgs

    MOV CX, emptyName_starting_column
    INC DX
    MOV BX, DX
    SUB BX, emptyName_height
    CMP BX, emptyName_starting_row + 2
    JNZ clear_msgs
    RET
clear_warnings ENDP

findCarRemSteps proc ;DI -> X_POS ; SI -> Y_POS
    MOV DX,0
    MOV ax,DI
    MOV BX,CELL_W
    div Bx
    mov x,ax

    MOV DX,0
    MOV ax,SI
    MOV BX,CELL_H
    div BX
    mov y,ax

    mov cx,0 
    search_findcarindex:
    MOV DX,x
    MOV BX,CX
    cmp [pathx+BX],DX
    jnz skip_search_findcarindex
        MOV DX,y
        cmp [pathy+BX],DX
        jnz skip_search_findcarindex
            ;found
            mov bx, 2 
            mov ax,cx 
            mov dx, 0          
            div bx      
            mov carIndex,ax
            ret 

    skip_search_findcarindex:
    add cx,2
    cmp cx,200
    jl search_findcarindex
    ret
findCarRemSteps endp

wait5sec PROC
    PUSHA
    Mov AH, 2CH
    INT 21H
    MOV SECONDS, DH

    CHECK_TIME2:
        Mov AH, 2CH
        INT 21H     ;DH => SECONDS

        CMP DH, SECONDS
        JE CHECK_TIME2

        MOV SECONDS, DH
        INC FiveSecondsCount
        CMP  FiveSecondsCount, 5
        JE EXIT_WAITING
    JMP CHECK_TIME2

    EXIT_WAITING:
    POPA
    RET
wait5sec ENDP 

END MAIN