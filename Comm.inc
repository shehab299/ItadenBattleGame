
CHECKSEND PROC
    MOV  DX,3FDH
    LOP1:    IN   AL,DX
             AND  AL,00100000B
             JZ   LOP1
    ret
    CHECKSEND ENDP

CHECKRECIEVE PROC

    MOV  DX,3FDH
    IN   AL,DX
    AND  AL,1
    JZ   NoRecieve
    mov RecieveFlag,1
    jmp donerecieve


    NoRecieve:
    mov RecieveFlag,0
donerecieve:
    ret
CHECKRECIEVE ENDP

RecieveByte  proc
    MOV  DX,03F8H
    IN   AL,DX
    MOV  DataIn,AL
    ret
RecieveByte endp

sendbyte proc
    MOV  DX,3F8H
    MOV  AL,DataOut
    OUT  DX,AL
    ret
sendbyte endp

