;AUTHOR : SHEHAB KHALED

;---------------------------------------
.MODEL SMALL
.STACK 32

;---------------------------------------
.DATA

VIDEO_MODE    EQU 4F02h                                      ; SVGA MODE
VIDEO_MODE_BX EQU 0101h  

; FILES

;AUX VARIABLES

AUX_IMAGE_WIDTH dw ?
AUX_IMAGE_HEIGHT dw ? 
START_ROW dw ?
START_COLUMN dw ?

;FIRST FILE

first_image_width equ 60
first_image_height equ 68

first_file_name db 'bin/BF.bin',0

first_file_handle dw ?

first_file_size equ first_image_height * first_image_width

first_file db first_file_size dup(?)



;SECOND FILE

second_image_width equ 60
second_image_height equ 68

second_file_name db 'bin/FKais.bin',0

second_file_handle dw ?

second_file_size equ second_image_height * second_image_width

second_file db second_file_size dup(?)




;THIRD FILE


filename db '../bin/BF.bin', 0

buffer_size equ 68*60
buffer db buffer_size dup(?)


;ELSE THINGS

errtext db "Error", 10, "$"

IMAGE_HEIGHT equ 68
IMAGE_WIDTH equ 60

SCREEN_WIDTH equ 640
SCREEN_HEIGHT equ 480

VIDEO_MODE    EQU 4F02h                 
VIDEO_MODE_BX EQU 0101h 


;---------------------------------------
.code

include drawing.inc



MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX

; Set video mode
    MOV    AX,VIDEO_MODE
    MOV    BX,VIDEO_MODE_BX
    INT    10h                     ; Set video mode

; Clear Screen
    MOV    AH, 0Bh                 ; Function 0Bh = Clear screen
    MOV    BH, 00h                 ; Page number
    MOV    BL, 00h            ; Background color
    INT    10h                     ; Call video interrupt

    MOV DX,offset first_file_name
    MOV DI,offset first_file_handle
    call openFile

    MOV CX,first_file_size
    MOV DX,offset first_file
    MOV BX,[first_file_handle]
    call ReadFileToMemory



    MOV SI,offset first_file
    MOV [START_ROW],50
    MOV [START_COLUMN],50
    MOV [AUX_IMAGE_HEIGHT],first_image_height
    MOV [AUX_IMAGE_WIDTH],first_image_width
    CALL drawImage

    MOV AH, 0
    INT 16h

    error_exit:
    mov ah, 9
    mov dx, offset errtext
    int 21h

    MOV AH,4CH
    INT 21H

MAIN ENDP



END MAIN
