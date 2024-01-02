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


chooseCharacter PROC
    MOV DX, offset choose_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, choose_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 99
    MOV [START_COLUMN], 182
    MOV [AUX_IMAGE_HEIGHT], choose_height
    MOV [AUX_IMAGE_WIDTH], choose_width
    CALL drawImage
    RET
chooseCharacter ENDP

flameText PROC
    MOV DX, offset FK_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, FK_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 206
    MOV [START_COLUMN], 330 
    MOV [AUX_IMAGE_HEIGHT], FK_height
    MOV [AUX_IMAGE_WIDTH], FK_width
    CALL drawImage
    RET
flameText ENDP

BloodyText PROC
    MOV DX, offset BF_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, BF_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 280
    MOV [START_COLUMN], 342
    MOV [AUX_IMAGE_HEIGHT], BF_height
    MOV [AUX_IMAGE_WIDTH], BF_width
    CALL drawImage
    RET
BloodyText ENDP

neptuneText PROC
    MOV DX, offset Nep_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, Nep_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 349
    MOV [START_COLUMN], 360
    MOV [AUX_IMAGE_HEIGHT], Nep_height
    MOV [AUX_IMAGE_WIDTH], Nep_width
    CALL drawImage
    RET
neptuneText ENDP

thunderText PROC
    MOV DX, offset Thun_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, Thun_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 416
    MOV [START_COLUMN], 323
    MOV [AUX_IMAGE_HEIGHT], Thun_height
    MOV [AUX_IMAGE_WIDTH], Thun_width
    CALL drawImage
    RET
thunderText ENDP

loadSmallOwl PROC

    MOV DX, offset owlS_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, owlS_file_size
    MOV DX, offset owlS_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET
loadSmallOwl ENDP

drawSmallOwl PROC

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
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, ward_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset file_buffer
    MOV AX, ward_starting_row
    MOV [START_ROW], AX
    MOV AX, ward_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], ward_height
    MOV [AUX_IMAGE_WIDTH], ward_width
    CALL drawImage
    RET
drawWard ENDP

drawSamer PROC
    MOV DX, offset samer_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, samer_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset file_buffer
    MOV AX, samer_starting_row
    MOV [START_ROW], AX
    MOV AX, samer_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], samer_height
    MOV [AUX_IMAGE_WIDTH], samer_width
    CALL drawImage
    RET
drawSamer ENDP

drawMays PROC
    MOV DX, offset mays_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, mays_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset file_buffer
    MOV AX, mays_starting_row
    MOV [START_ROW], AX
    MOV AX, mays_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], mays_height
    MOV [AUX_IMAGE_WIDTH], mays_width
    CALL drawImage
    RET
drawMays ENDP

drawBassam PROC
    MOV DX, offset bassam_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, bassam_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset file_buffer
    MOV AX, bassam_starting_row
    MOV [START_ROW], AX
    MOV AX, bassam_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], bassam_height
    MOV [AUX_IMAGE_WIDTH], bassam_width
    CALL drawImage

    RET
drawBassam ENDP

p2_SelectCharDown PROC
    P2_CHECK_FIRST:
    CMP owl_current_row, first_player
    JNE P2_Check_second
    CALL clearOwl
    CMP player1_character, 2
    JNE CONTINUE1
    MOV owl_current_row, third_player
    MOV player2_character, 3
    CALL drawSmallOwl
    JMP P2_EXIT_PROC

    CONTINUE1:
    MOV owl_current_row, second_player
    MOV player2_character, 2
    CALL drawSmallOwl
    JMP P2_EXIT_PROC
    
    P2_Check_second:
    CMP owl_current_row, second_player
    JNE P2_check_third
    CALL clearOwl
    CMP player1_character, 3
    JNE CONTINUE2
    MOV owl_current_row, fourth_player
    MOV player2_character, 4
    CALL drawSmallOwl
    JMP P2_EXIT_PROC
    
    CONTINUE2:
    MOV owl_current_row, third_player
    MOV player2_character, 3
    CALL drawSmallOwl
    JMP P2_EXIT_PROC

    P2_Check_third:
    CMP owl_current_row, third_player
    JNE P2_check_fourth
    CALL clearOwl
    CMP player1_character, 4
    JNE CONTINUE3
    MOV owl_current_row, first_player
    MOV player2_character, 1
    CALL drawSmallOwl
    JMP P2_EXIT_PROC
    
    CONTINUE3:
    MOV owl_current_row, fourth_player
    MOV player2_character, 4
    CALL drawSmallOwl
    JMP P2_EXIT_PROC

    P2_Check_fourth:
    CALL clearOwl
    CMP player1_character, 1
    JNE CONTINUE4
    MOV owl_current_row, second_player
    MOV player2_character, 2
    CALL drawSmallOwl
    JMP P2_EXIT_PROC
    
    CONTINUE4:
    MOV owl_current_row, first_player
    MOV player2_character, 1
    CALL drawSmallOwl

    P2_EXIT_PROC:
    
    RET
p2_SelectCharDown ENDP




p2_SelectCharUp PROC
    P2_CHECK_FIRST2:
    CMP owl_current_row, first_player
    JNE P2_Check_second2
    CALL clearOwl
    CMP player1_character, 4
    JNE CONTINUE11
    MOV owl_current_row, third_player
    MOV player2_character, 3
    CALL drawSmallOwl
    JMP P2_EXIT_PROC2

    CONTINUE11:
    MOV owl_current_row, fourth_player
    MOV player2_character, 4
    CALL drawSmallOwl
    JMP P2_EXIT_PROC2
    
    P2_Check_second2:
    CMP owl_current_row, second_player
    JNE P2_check_third2
    CALL clearOwl
    CMP player1_character, 1
    JNE CONTINUE22
    MOV owl_current_row, fourth_player
    MOV player2_character, 4
    CALL drawSmallOwl
    JMP P2_EXIT_PROC2
    
    CONTINUE22:
    MOV owl_current_row, first_player
    MOV player2_character, 1
    CALL drawSmallOwl
    JMP P2_EXIT_PROC2

    P2_Check_third2:
    CMP owl_current_row, third_player
    JNE P2_check_fourth2
    CALL clearOwl
    CMP player1_character, 2
    JNE CONTINUE33
    MOV owl_current_row, first_player
    MOV player2_character, 1
    CALL drawSmallOwl
    JMP P2_EXIT_PROC2
    
    CONTINUE33:
    MOV owl_current_row, second_player
    MOV player2_character, 2
    CALL drawSmallOwl
    JMP P2_EXIT_PROC2

    P2_Check_fourth2:
    CALL clearOwl
    CMP player1_character, 3
    JNE CONTINUE44
    MOV owl_current_row, second_player
    MOV player2_character, 2
    CALL drawSmallOwl
    JMP P2_EXIT_PROC2
    
    CONTINUE44:
    MOV owl_current_row, third_player
    MOV player2_character, 3
    CALL drawSmallOwl

    P2_EXIT_PROC2:
    
    RET
p2_SelectCharUp ENDP



selectCharDown PROC
    CMP owl_current_row, first_player
    JNE Check_second
    CALL clearOwl
    MOV owl_current_row, second_player
    MOV player1_character, 2
    CALL drawSmallOwl
    JMP EXIT_PROC
    
    Check_second:
    CMP owl_current_row, second_player
    JNE check_third
    CALL clearOwl
    MOV owl_current_row, third_player
    MOV player1_character, 3
    CALL drawSmallOwl
    JMP EXIT_PROC

    Check_third:
    CMP owl_current_row, third_player
    JNE check_fourth
    CALL clearOwl
    MOV owl_current_row, fourth_player
    MOV player1_character, 4
    CALL drawSmallOwl
    JMP EXIT_PROC

    Check_fourth:
    CALL clearOwl
    MOV owl_current_row, first_player
    MOV player1_character, 1
    CALL drawSmallOwl
    EXIT_PROC:
    
    RET
selectCharDown ENDP

selectCharUP PROC
    CMP owl_current_row, first_player
    JNE Check_second_UP
    CALL clearOwl
    MOV owl_current_row, fourth_player
    MOV player1_character, 4
    CALL drawSmallOwl
    JMP EXIT_PROC2
    
    Check_second_UP:
    CMP owl_current_row, second_player
    JNE Check_third_UP
    CALL clearOwl
    MOV owl_current_row, first_player
    MOV player1_character, 1
    CALL drawSmallOwl
    JMP EXIT_PROC2

    Check_third_UP:
    CMP owl_current_row, third_player
    JNE Check_fourth_UP
    CALL clearOwl
    MOV owl_current_row, second_player
    MOV player1_character, 2
    CALL drawSmallOwl
    JMP EXIT_PROC2

    Check_fourth_UP:
    CALL clearOwl
    MOV owl_current_row, third_player
    MOV player1_character, 3
    CALL drawSmallOwl

    EXIT_PROC2:

    RET
selectCharUP ENDP



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

    MOV DX, offset chatBtn_file_name
    MOV DI, offset file_handle
    call openFile

    MOV CX, chatBtn_file_size
    MOV DX, offset file_buffer
    MOV BX, [file_handle]
    call ReadFileToMemory

    MOV SI, offset file_buffer
    MOV [START_ROW], 437
    MOV [START_COLUMN], 280
    MOV [AUX_IMAGE_HEIGHT], chatBtn_height
    MOV [AUX_IMAGE_WIDTH], chatBtn_width
    CALL drawImage

    RET

drawWelcomePage ENDP

drawpPlayerInfo PROC
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


Choose PROC
    MOV CL, 1

    Check_Keypress:
        MOV AH, 0
        INT 16H

        CMP AH, 1CH
        JNE SELECT
        CAll setBackgroundColor
        JMP Check_for_player2
        
        SELECT:
            CMP AH, downArrow ;down arrow

            JNE CHECK_UP
            CALL selectCharDown
            JMP LOOP_AGAIN

            CHECK_UP:
            CMP AH, upArrow
            JNE LOOP_AGAIN
            CALL selectCharUP

            LOOP_AGAIN:
    JMP Check_Keypress

    Check_for_player2:

    CMP player1_character, 1
    JE start_from_samer
    MOV owl_current_row, first_player
    JMP Player2_options

    start_from_samer:
    MOV owl_current_row, second_player

    Player2_options:
    
    CALL drawPage
     Check_Keypress2:
       
        MOV AH, 0
        INT 16H

        CMP AH, 1CH
        JNE SELECT2
        CAll setBackgroundColor
        JMP EXIT
        SELECT2:
            CMP AH, s 
            JNE CHECK_UP2
            CALL P2_selectCharDown
            JMP LOOP_AGAIN2

            CHECK_UP2:
            CMP AH, W
            JNE LOOP_AGAIN2
            CALL P2_selectCharUP

            LOOP_AGAIN2:
    
    JMP Check_Keypress2

    EXIT:
    RET

Choose ENDP