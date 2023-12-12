;AUTHOR : SHEHAB KHALED

;---------------------------------------
.MODEL SMALL
.STACK 32

EXTRN generate: FAR

;---------------------------------------
.DATA

VIDEO_MODE    EQU 4F02h                          
VIDEO_MODE_BX EQU 0101h       

SCREEN_HEIGHT EQU 480
SCREEN_WIDTH  EQU 640

;AUX VARIABLES

AUX_IMAGE_WIDTH dw ?
AUX_IMAGE_HEIGHT dw ? 
START_ROW dw ?
START_COLUMN dw ?


;---------------------------------------
.code


MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX
; Set video mode
    MOV    AX,VIDEO_MODE
    MOV    BX,VIDEO_MODE_BX
    INT    10h                     ; Set video mode


    call setBackgroundColor
    call generate

    MOV AH, 0
    INT 16h


    MOV AH,4CH
    INT 21H

MAIN ENDP



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


     END MAIN