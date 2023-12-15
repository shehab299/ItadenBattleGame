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
    DRAW_PIXELS_:
        MOV AL,BYTE PTR [SI]
        INC SI
        CMP AL,250
        JE SKIP_
        INT 10H
        SKIP_:
        INC CX
        CMP CX,BX
        JNE DRAW_PIXELS_

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE DRAW_PIXELS_

    POP BX DI
    
    RET

drawImage ENDP




setBackgroundColor PROC FAR
    mov cx, 0           ;Column
    mov dx, 0           ;Row
    mov al, BackgroundColor   
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




loadLogo proc

    MOV DX, offset logo_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, logo_size
    MOV DX, offset logo
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadLogo endp

drawLogo PROC
    MOV SI, offset logo
    MOV [START_ROW], 31
    MOV [START_COLUMN], 28
    MOV [AUX_IMAGE_HEIGHT], logo_height
    MOV [AUX_IMAGE_WIDTH], logo_width
    CALL drawImage
    RET
drawLogo ENDP


