;---------------------------------------
.MODEL SMALL

.STACK 32
.286
;---------------------------------------
.DATA

player1_name db 10, ?, 30 dup('$')
player2_name db 10, ?, 30 dup('$') 

;---------------------------------------
.code

MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX


    mov ah,0
    mov al,13h
    int 10h

    mov ah, 0AH
    mov dx, offset player1_name
    int 21h
   
    
    mov ah, 0AH
    mov dx, offset player2_name
    int 21h


    CLOSE:
    MOV AH,4CH
    INT 21H

MAIN ENDP
