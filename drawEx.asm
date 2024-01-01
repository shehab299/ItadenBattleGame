;AUTHOR : SHEHAB KHALED

;---------------------------------------
.MODEL HUGE
.STACK 32
;---------------------------------------
.DATA
; FILES

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

;SECOND FILE
owl_width equ 117
owl_height equ 167
owl_file_name db '/bin/owl.bin', 0
owl_file_handle dw ?
owl_file_size equ owl_height * owl_width
owl_file db owl_file_size dup(?)

;HeroText FILE
hey_width equ 438
hey_height equ 45
hey_file_name db '/bin/Hey.bin', 0
hey_file_handle dw ?
hey_file_size equ hey_height * hey_width
hey_file db hey_file_size dup(?)

;Start FILE
startBtn_width equ 98
startBtn_height equ 18
startBtn_file_name db '/bin/Start.bin', 0
startBtn_file_handle dw ?
startBtn_file_size equ startBtn_height * startBtn_width
startBtn_file db startBtn_file_size dup(?)

;Exit FILE
exitBtn_width equ 70
exitBtn_height equ 16
exitBtn_file_name db '/bin/Exit.bin', 0
exitBtn_file_handle dw ?
exitBtn_file_size equ exitBtn_height * exitBtn_width
exitBtn_file db exitBtn_file_size dup(?)

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

;ELSE THINGS
errtext db "Error", 10, "$"

IMAGE_HEIGHT equ 68
IMAGE_WIDTH equ 60

SCREEN_WIDTH equ 640
SCREEN_HEIGHT equ 480

VIDEO_MODE    EQU 4F02h                                      ; SVGA MODE
VIDEO_MODE_BX EQU 0101h  
;---------------------------------------
.code

include drawing.inc
    setBackgroundColor PROC NEAR
        mov cx, 0           ;Column
        mov dx, 0           ;Row
        mov al, 42H         ;Pixel color
        mov ah, 0ch         ;Draw Pixel Command
        Horizontal: int 10h
        INC CX
        CMP CX, SCREEN_WIDTH
        JNZ Horizontal

        MOV CX, 0
        INC DX
        CMP DX, SCREEN_HEIGHT
        JNZ Horizontal
        RET
    setBackgroundColor ENDP

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



MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    ; Set video mode
    MOV    AX, VIDEO_MODE
    MOV    BX, VIDEO_MODE_BX
    INT    10h                     ; Set video mode

    CALL setBackgroundColor

    CALL drawLogo


    MOV DX, offset owl_file_name
    MOV DI, offset owl_file_handle
    call openFile

    MOV CX, owl_file_size
    MOV DX, offset owl_file
    MOV BX, [owl_file_handle]
    call ReadFileToMemory

    MOV SI, offset owl_file
    MOV [START_ROW], 91
    MOV [START_COLUMN], 265
    MOV [AUX_IMAGE_HEIGHT], owl_height
    MOV [AUX_IMAGE_WIDTH], owl_width
    CALL drawImage


    MOV DX, offset hey_file_name
    MOV DI, offset hey_file_handle
    call openFile

    MOV CX, hey_file_size
    MOV DX, offset hey_file
    MOV BX, [hey_file_handle]
    call ReadFileToMemory

    MOV SI, offset hey_file
    MOV [START_ROW], 275
    MOV [START_COLUMN], 101
    MOV [AUX_IMAGE_HEIGHT], hey_height
    MOV [AUX_IMAGE_WIDTH], hey_width
    CALL drawImage

    MOV DX, offset startBtn_file_name
    MOV DI, offset startBtn_file_handle
    call openFile

    MOV CX, startBtn_file_size
    MOV DX, offset startBtn_file
    MOV BX, [startBtn_file_handle]
    call ReadFileToMemory

    MOV SI, offset startBtn_file
    MOV [START_ROW], 437
    MOV [START_COLUMN], 499
    MOV [AUX_IMAGE_HEIGHT], startBtn_height
    MOV [AUX_IMAGE_WIDTH], startBtn_width
    CALL drawImage


    MOV DX, offset exitBtn_file_name
    MOV DI, offset exitBtn_file_handle
    call openFile

    MOV CX, exitBtn_file_size
    MOV DX, offset exitBtn_file
    MOV BX, [exitBtn_file_handle]
    call ReadFileToMemory

    MOV SI, offset exitBtn_file
    MOV [START_ROW], 437
    MOV [START_COLUMN], 34
    MOV [AUX_IMAGE_HEIGHT], exitBtn_height
    MOV [AUX_IMAGE_WIDTH], exitBtn_width
    CALL drawImage

    MOV AH, 0
    INT 16h
    CMP AH, 4DH
    JNE EXIT

    ;Choose a character
    CALL setBackgroundColor

    CALL drawLogo
    ; CALL chooseCharacter
    MOV AH, 0
    INT 16h

    EXIT:
    RET

MAIN ENDP


END MAIN
