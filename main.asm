;AUTHOR : SHEHAB KHALED

;---------------------------------------
.MODEL SMALL

.STACK 32

;---------------------------------------
.DATA



;ADDRESS VECTOR FOR INTERRUPTS
INT09_BX DW ?
INT09_ES DW ?

;KEYBOARD BUFFERS

KeyList db 128 dup(0)

;AUX VARIABLES
AUX_IMAGE_WIDTH dw ?
AUX_IMAGE_HEIGHT dw ? 
START_ROW dw ?
START_COLUMN dw ?

;GENERAL FILES

file_buffer db 20000 dup(?)
file_handle dw ?


include pagesImg/img.inc ;General Images

include pagesImg/startImg.inc ;IMAGES FOR START PAGE
include pagesImg/pg2_img.inc ;IMAGES FOR CHOOSE PAGE

;position of characters
owl_current_row DW 193

first_player EQU 193
second_player EQU 266
third_player EQU 335
fourth_player EQU 402

;players selected characters
player1_character DB 1
player2_character DB 1

;players name
player1_name db 10,'?',10 dup('?') 
player2_name db 10,'?',10 dup('?') 

score1_txt db 5, '?',5 dup('?')
score2_txt db 5, '?',5 dup('?')

;grid

x DW 0 
y DW 0

color db 0eh


include const.inc ;CONSTANTS
include gameData.inc 

;---------------------------------------
.code

include files.inc ;File and image handling
include pagesPrc/UI.inc ;GENERAL FUNCTIONS
include pagesPrc/Welcome.inc ;FOR WELCOME PAGE
include pagesPrc/Choose.inc ;FOR CHOOSE PAGE
include pagesPrc/grid.inc ;For the grid feature
include pagesPrc/path.inc ;For path generation
include pagesPrc/keyboard.inc ;FOR KEYBOARD CONFIGURATION
include pagesPrc/game.inc ;Game functions

MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX

    ;SET VIDEO MODE

    MOV AX,VIDEO_MODE
    MOV BX,VIDEO_MODE_BX
    INT 10H

    call setBackgroundColor

    
    ;WELCOME PAGE
    call loadLogo
    call drawWelcomePage

    ;TAKE KEY FROM USER
CHK_KEY:
    MOV AH,0
    INT 16H

    CMP AH,EscKey
    JE CLOSE

    CMP AH,EnterKey
    JNE CHK_KEY

    ;ENTER NAMES
Names:

    ; call clearUnderOwl

    ; call getInfo


; CHK_KEY2:
;     MOV AH,0
;     INT 16H

;     CMP AH,EscKey
;     JE CLOSE

;     CMP AH,EnterKey
;     JNE CHK_KEY2


    ;CHOOSE CHARACTER
CHOOSE_LBL:

    CALL loadSmallOwl

    MOV BX, owl_current_row
    
    CALL drawPage

    CALL Choose

    ;TAKE CHARACTERS AND STORE THEM

    call setBackgroundColor
    call drawPath

    ;START THE GAME

    call ConfigKeyboard

    call MainLoop

    CALL ResetKeyboard
    HLT

    CLOSE:
    MOV AH,4CH
    INT 21H

MAIN ENDP



getInfo PROC

;PLAYER 1 NAME
    mov dh,player1_y/CharHeight + 2    ;ROW
    mov dl,player1_x/CharWidth     ;COLUMN
    mov bh, 0      ; Page = 0
    mov bl,BackgroundColor
    mov ah, 02h    ; BIOS.SetCursorPosition
    int 10h   

    mov ah,0AH
    mov dx,offset player1_name
    int 21h  

;PLAYER 2 NAME

    mov dh,player2_y/CharHeight + 2    ;ROW
    mov dl,player2_x/CharWidth     ;COLUMN
    mov bh, 0      ; Page = 0
    mov bl,BackgroundColor
    mov ah, 02h    ; BIOS.SetCursorPosition
    int 10h   

    mov ah,0AH
    mov dx,offset player2_name
    int 21h  

; SCORE 1 
    mov dh,score1_y/CharHeight + 2    ;ROW
    mov dl,score1_x/CharWidth     ;COLUMN
    mov bh, 0      ; Page = 0
    mov bl,BackgroundColor
    mov ah, 02h    ; BIOS.SetCursorPosition
    int 10h   

    mov ah,0AH
    mov dx,offset score1_txt
    int 21h  

;SCORE 2

    mov dh,score2_y/CharHeight + 2    ;ROW
    mov dl,score2_x/CharWidth     ;COLUMN
    mov bh, 0      ; Page = 0
    mov bl,BackgroundColor
    mov ah, 02h    ; BIOS.SetCursorPosition
    int 10h   

    mov ah,0AH
    mov dx,offset score2_txt
    int 21h  

    RET

getInfo ENDP

END MAIN