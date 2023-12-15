
drawWelcomePage PROC

    CALL drawLogo


    MOV DX, offset owl_file_name
    MOV DI, offset file_handle
    call openFile

    MOV CX, owl_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    call ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 91                           
    MOV [START_COLUMN], 265
    MOV [AUX_IMAGE_HEIGHT], owl_height
    MOV [AUX_IMAGE_WIDTH], owl_width
    CALL drawImage


    MOV DX, offset hey_file_name
    MOV DI, offset file_handle
    call openFile

    MOV CX, hey_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    call ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 275
    MOV [START_COLUMN], 101
    MOV [AUX_IMAGE_HEIGHT], hey_height
    MOV [AUX_IMAGE_WIDTH], hey_width
    CALL drawImage

    MOV DX, offset startBtn_file_name
    MOV DI, offset file_handle
    call openFile

    MOV CX, startBtn_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    call ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 437
    MOV [START_COLUMN], 499
    MOV [AUX_IMAGE_HEIGHT], startBtn_height
    MOV [AUX_IMAGE_WIDTH], startBtn_width
    CALL drawImage


    MOV DX, offset exitBtn_file_name
    MOV DI, offset file_handle
    call openFile

    MOV CX, exitBtn_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    call ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 437
    MOV [START_COLUMN], 34
    MOV [AUX_IMAGE_HEIGHT], exitBtn_height
    MOV [AUX_IMAGE_WIDTH], exitBtn_width
    CALL drawImage

    RET

drawWelcomePage ENDP

drawpPlayerInfo PROC

    MOV DX, offset player1_file_name
    MOV DI, offset file_handle
    call openFile

    MOV CX, player1_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    call ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], player1_y                      
    MOV [START_COLUMN], player1_x
    MOV [AUX_IMAGE_HEIGHT], player1_height
    MOV [AUX_IMAGE_WIDTH], player1_width
    CALL drawImage

    MOV DX, offset player2_file_name
    MOV DI, offset file_handle
    call openFile

    MOV CX, player2_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    call ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], player2_y                      
    MOV [START_COLUMN], player2_x
    MOV [AUX_IMAGE_HEIGHT], player2_height
    MOV [AUX_IMAGE_WIDTH], player2_width
    CALL drawImage

    MOV DX, offset score_file_name
    MOV DI, offset file_handle
    call openFile

    MOV CX, score_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    call ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 346                      
    MOV [START_COLUMN], 447
    MOV [AUX_IMAGE_HEIGHT], score_height
    MOV [AUX_IMAGE_WIDTH], score_width
    CALL drawImage

    MOV SI, offset file_buffer
    MOV [START_ROW], 346                      
    MOV [START_COLUMN], 128
    MOV [AUX_IMAGE_HEIGHT], score_height
    MOV [AUX_IMAGE_WIDTH], score_width
    CALL drawImage

    RET

drawpPlayerInfo ENDP

clearUnderOwl PROC

    mov cx, 0           ;Column
    mov dx, 258           ;Row
    mov al, BackgroundColor   
    mov ah, 0ch         ;Draw Pixel Command
    Horizontal_: int 10h
    INC CX
    CMP CX, SCREEN_WIDTH
    JNZ Horizontal_

    MOV CX, 0
    INC DX
    CMP DX, SCREEN_HEIGHT
    JNZ Horizontal_
    RET

clearUnderOwl ENDP
