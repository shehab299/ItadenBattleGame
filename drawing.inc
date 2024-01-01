openFile PROC FAR ;DX => FILE_NAME_OFFSET  ;DI => FILE_HANDLE_OFFSET

    mov ah,03Dh
    mov al,0
    INT 21h


    MOV [DI],AX

    RET
    
openFile ENDP ;BX

ReadFileToMemory PROC FAR ;CX => BUFFER_SIZE ;DX => FILE_OFFSET ;BX=> FILE_HANDLE

    mov ah,03Fh
    INT 21h

    mov ah, 3Eh       ; DOS function: close file
    INT 21H

    RET    

ReadFileToMemory ENDP


drawImage PROC FAR ; SI => Offset File ;START_ROW => y ;START_COLUMN => X ;AUX_IMAGE_WIDTH => IMAGE_WIDTH ;AUX_IMAGE_HEIGHT => IMAGE_HEIGHT


    PUSH DI BX

    MOV CX,[START_COLUMN]
    MOV DX,[START_ROW]

    MOV BX,CX
    ADD BX,[AUX_IMAGE_WIDTH]

    MOV DI,DX
    ADD DI,[AUX_IMAGE_HEIGHT]

    MOV AX,DS
    MOV ES,AX

    MOV AH,0CH    
    DRAW_PIXELS:
        MOV AL,BYTE PTR [SI]
        INC SI
        CMP AL,250
        JE SKIP
        INT 10H
        SKIP:
        INC CX
        CMP CX,BX
        JNE DRAW_PIXELS

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE DRAW_PIXELS

    POP BX DI
    
    RET

drawImage ENDP
