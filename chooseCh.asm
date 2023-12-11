.MODEL SMALL
.STACK 32
.DATA

;AUX VARIABLES

AUX_IMAGE_WIDTH dw ?
AUX_IMAGE_HEIGHT dw ? 
START_ROW dw ?
START_COLUMN dw ?

;FIRST FILE

first_image_width equ 140
first_image_height equ 42

first_file_name db './bin/LogoS.bin', 0

first_file_handle dw ?

first_file_size equ first_image_height * first_image_width

first_file db first_file_size dup(?)

;Ward FILE

ward_width equ 71

ward_height equ 66

ward_file_name db '/bin/ward.bin', 0

ward_file_handle dw ?

ward_file_size equ ward_height * ward_width

ward_file db ward_file_size dup(?)

;Samer FILE

samer_width equ 65

samer_height equ 59

samer_file_name db '/bin/samer.bin', 0

samer_file_handle dw ?

samer_file_size equ samer_height * samer_width

samer_file db samer_file_size dup(?)

;mays FILE

mays_width equ 60

mays_height equ 58

mays_file_name db '/bin/mays.bin', 0

mays_file_handle dw ?

mays_file_size equ mays_height * mays_width

mays_file db mays_file_size dup(?)

;bassam FILE

bassam_width equ 65

bassam_height equ 62

bassam_file_name db '/bin/bassam.bin', 0

bassam_file_handle dw ?

bassam_file_size equ bassam_height * bassam_width

bassam_file db bassam_file_size dup(?)

;choose character FILE

choose_width equ 272

choose_height equ 47

choose_file_name db '/bin/Choose.bin', 0

choose_file_handle dw ?

choose_file_size equ choose_height * choose_width

choose_file db choose_file_size dup(?)

;Flame kaiser FILE
FK_width equ 132
FK_height equ 10
FK_file_name db '/bin/FKTxt.bin', 0
FK_file_handle dw ?
FK_file_size equ FK_height * FK_width
FK_file db FK_file_size dup(?)

;Bloody Fang FILE
BF_width equ 109
BF_height equ 10
BF_file_name db '/bin/BFTxt.bin', 0
BF_file_handle dw ?
BF_file_size equ BF_height * BF_width
BF_file db BF_file_size dup(?)

;Neptune FILE
Nep_width equ 69
Nep_height equ 10
Nep_file_name db '/bin/NepTxt.bin', 0
Nep_file_handle dw ?
Nep_file_size equ Nep_height * Nep_width
Nep_file db Nep_file_size dup(?)

;Thunder Emperor FILE
Thun_width equ 148
Thun_height equ 10
Thun_file_name db '/bin/ThunTxt.bin', 0
Thun_file_handle dw ?
Thun_file_size equ Thun_height * Thun_width
Thun_file db Thun_file_size dup(?)

;selected character
owlS_width equ 26
owlS_height equ 37
owlS_file_name db '/bin/owlS.bin', 0
owlS_file_handle dw ?
owlS_file_size equ owlS_height * owlS_width
owlS_file db owlS_file_size dup(?)
owl_current_row DW 193
first_player EQU 193
second_player EQU 266
third_player EQU 335
fourth_player EQU 402
;ELSE THINGS

errtext db "Error", 10, "$"

IMAGE_HEIGHT equ 68
IMAGE_WIDTH equ 60

SCREEN_WIDTH equ 640
SCREEN_HEIGHT equ 480

VIDEO_MODE    EQU 4F02h                                      ; SVGA MODE
VIDEO_MODE_BX EQU 0101h  

.CODE

include drawing.inc

    setBackgroundColor PROC NEAR
        mov cx, 0           ;Column
        mov dx, 0           ;Row
        mov al, 42H         ;Pixel color
        mov ah, 0ch         ;Draw Pixel Command
        clear: int 10h
        INC CX
        CMP CX, SCREEN_WIDTH
        JNZ clear

        MOV CX, 0
        INC DX
        CMP DX, SCREEN_HEIGHT
        JNZ clear
        RET
    setBackgroundColor ENDP

    clearOwl PROC NEAR
        mov cx, 80                        ;Column
        mov dx, owl_current_row           ;Row
        mov al, 42H                       ;Pixel color
        mov ah, 0ch                       ;Draw Pixel Command
        clear2: int 10h
        INC CX
        CMP CX, 106
        JNZ clear2

        MOV CX, 80
        INC DX
        MOV BX, DX
        SUB BX, owlS_height
        CMP BX, owl_current_row
        JNZ clear2
        RET
    clearOwl ENDP

    drawWard PROC
        MOV DX, offset ward_file_name
        MOV DI, offset ward_file_handle
        call openFile

        MOV CX, ward_file_size
        MOV DX, offset ward_file
        MOV BX, [ward_file_handle]
        call ReadFileToMemory

        MOV SI, offset ward_file
        MOV [START_ROW], 170
        MOV [START_COLUMN], 160
        MOV [AUX_IMAGE_HEIGHT], ward_height
        MOV [AUX_IMAGE_WIDTH], ward_width
        CALL drawImage
        RET
    drawWard ENDP

    drawSamer PROC
        MOV DX, offset samer_file_name
        MOV DI, offset samer_file_handle
        call openFile

        MOV CX, samer_file_size
        MOV DX, offset samer_file
        MOV BX, [samer_file_handle]
        call ReadFileToMemory

        MOV SI, offset samer_file
        MOV [START_ROW], 250
        MOV [START_COLUMN], 168
        MOV [AUX_IMAGE_HEIGHT], samer_height
        MOV [AUX_IMAGE_WIDTH], samer_width
        CALL drawImage
        RET
    drawSamer ENDP

    drawMays PROC
        MOV DX, offset mays_file_name
        MOV DI, offset mays_file_handle
        call openFile

        MOV CX, mays_file_size
        MOV DX, offset mays_file
        MOV BX, [mays_file_handle]
        call ReadFileToMemory

        MOV SI, offset mays_file
        MOV [START_ROW], 321
        MOV [START_COLUMN], 168
        MOV [AUX_IMAGE_HEIGHT], mays_height
        MOV [AUX_IMAGE_WIDTH], mays_width
        CALL drawImage
        RET
    drawMays ENDP

    drawBassam PROC
        MOV DX, offset bassam_file_name
        MOV DI, offset bassam_file_handle
        call openFile

        MOV CX, bassam_file_size
        MOV DX, offset bassam_file
        MOV BX, [bassam_file_handle]
        call ReadFileToMemory

        MOV SI, offset bassam_file
        MOV [START_ROW], 387
        MOV [START_COLUMN], 168
        MOV [AUX_IMAGE_HEIGHT], bassam_height
        MOV [AUX_IMAGE_WIDTH], bassam_width
        CALL drawImage

        RET
    drawBassam ENDP

    drawLogo PROC
        MOV DX, offset first_file_name
        MOV DI, offset first_file_handle
        call openFile

        MOV CX, first_file_size
        MOV DX, offset first_file
        MOV BX, [first_file_handle]
        call ReadFileToMemory

        MOV SI, offset first_file
        MOV [START_ROW], 31
        MOV [START_COLUMN], 469
        MOV [AUX_IMAGE_HEIGHT], first_image_height
        MOV [AUX_IMAGE_WIDTH], first_image_width
        CALL drawImage
        RET
    drawLogo ENDP

    chooseCharacter PROC
        MOV DX, offset choose_file_name
        MOV DI, offset choose_file_handle
        call openFile

        MOV CX, choose_file_size
        MOV DX, offset choose_file
        MOV BX, [choose_file_handle]
        call ReadFileToMemory

        MOV SI, offset choose_file
        MOV [START_ROW], 52
        MOV [START_COLUMN], 172
        MOV [AUX_IMAGE_HEIGHT], choose_height
        MOV [AUX_IMAGE_WIDTH], choose_width
        CALL drawImage
        RET
    chooseCharacter ENDP

    flameText PROC
        MOV DX, offset FK_file_name
        MOV DI, offset FK_file_handle
        call openFile

        MOV CX, FK_file_size
        MOV DX, offset FK_file
        MOV BX, [FK_file_handle]
        call ReadFileToMemory

        MOV SI, offset FK_file
        MOV [START_ROW], 206
        MOV [START_COLUMN], 330
        MOV [AUX_IMAGE_HEIGHT], FK_height
        MOV [AUX_IMAGE_WIDTH], FK_width
        CALL drawImage
        RET
    flameText ENDP

    BloodyText PROC
        MOV DX, offset BF_file_name
        MOV DI, offset BF_file_handle
        call openFile

        MOV CX, BF_file_size
        MOV DX, offset BF_file
        MOV BX, [BF_file_handle]
        call ReadFileToMemory

        MOV SI, offset BF_file
        MOV [START_ROW], 280
        MOV [START_COLUMN], 342
        MOV [AUX_IMAGE_HEIGHT], BF_height
        MOV [AUX_IMAGE_WIDTH], BF_width
        CALL drawImage
        RET
    BloodyText ENDP

    neptuneText PROC
        MOV DX, offset Nep_file_name
        MOV DI, offset Nep_file_handle
        call openFile

        MOV CX, Nep_file_size
        MOV DX, offset Nep_file
        MOV BX, [Nep_file_handle]
        call ReadFileToMemory

        MOV SI, offset Nep_file
        MOV [START_ROW], 349
        MOV [START_COLUMN], 360
        MOV [AUX_IMAGE_HEIGHT], Nep_height
        MOV [AUX_IMAGE_WIDTH], Nep_width
        CALL drawImage
        RET
    neptuneText ENDP

    thunderText PROC
        MOV DX, offset Thun_file_name
        MOV DI, offset Thun_file_handle
        call openFile

        MOV CX, Thun_file_size
        MOV DX, offset Thun_file
        MOV BX, [Thun_file_handle]
        call ReadFileToMemory

        MOV SI, offset Thun_file
        MOV [START_ROW], 416
        MOV [START_COLUMN], 323
        MOV [AUX_IMAGE_HEIGHT], Thun_height
        MOV [AUX_IMAGE_WIDTH], Thun_width
        CALL drawImage
        RET
    thunderText ENDP

    drawSmallOwl PROC
        MOV DX, offset owlS_file_name
        MOV DI, offset owlS_file_handle
        call openFile

        MOV CX, owlS_file_size
        MOV DX, offset owlS_file
        MOV BX, [owlS_file_handle]
        call ReadFileToMemory

        MOV SI, offset owlS_file
        MOV AX, owl_current_row
        MOV [START_ROW], AX
        MOV [START_COLUMN], 80
        MOV [AUX_IMAGE_HEIGHT], owlS_height
        MOV [AUX_IMAGE_WIDTH], owlS_width
        CALL drawImage
        RET
    drawSmallOwl ENDP

    drawPage PROC
        CALL setBackgroundColor
        CALL drawLogo
        CALL chooseCharacter

        CALL drawWard
        CALL drawSamer
        CALL drawMays
        CALL drawBassam

        CALL flameText
        CALL BloodyText
        CALL neptuneText
        CALL thunderText

        Call drawSmallOwl
        RET
    drawPage ENDP

    ;description
    selectCharDown PROC
        CMP owl_current_row, first_player
        JNE Check_second
        CALL clearOwl
        MOV owl_current_row, second_player
        CALL drawSmallOwl
        JMP EXIT_PROC
        
        Check_second:
        CMP owl_current_row, second_player
        JNE check_third
        CALL clearOwl
        MOV owl_current_row, third_player
        CALL drawSmallOwl
        JMP EXIT_PROC

        Check_third:
        CMP owl_current_row, third_player
        JNE check_fourth
        CALL clearOwl
        MOV owl_current_row, fourth_player
        CALL drawSmallOwl
        JMP EXIT_PROC

        Check_fourth:
        CALL clearOwl
        MOV owl_current_row, first_player
        CALL drawSmallOwl
        EXIT_PROC:
        RET
    selectCharDown ENDP

MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    ; Set video mode
    MOV    AX, VIDEO_MODE
    MOV    BX, VIDEO_MODE_BX
    INT    10h                     ; Set video mode

    MOV BX, owl_current_row
    CALL drawPage
    MOV CX, first_player        ;CX to detect the chosen player
    Check_Keypress:
        MOV AH, 0
        INT 16H

        MOV BX, owl_current_row
        CMP AH, 4Dh
        JNE SELECT
        CAll setBackgroundColor
        JMP EXIT
        SELECT:
            CMP AH, 50h ;down arrow
            JNE CHECK_UP
            CALL selectCharDown

            CHECK_UP:
            CMP AH, 48H
            JNE LOOP_AGAIN
            ;HERE goes function call

            LOOP_AGAIN:
    JMP Check_Keypress

    EXIT:
    MOV AH, 0
    INT 16H
   
    RET
MAIN ENDP

   
END MAIN

