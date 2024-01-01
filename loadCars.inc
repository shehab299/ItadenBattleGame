
loadRedCarForOne PROC
    ;1
    MOV DX, offset upFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET
loadRedCarForOne ENDP

loadRedCarForTwo PROC
    ;1
    MOV DX, offset upFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_R
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET
loadRedCarForTwo ENDP

loadYellowCarForOne PROC
    ;1
    MOV DX, offset upFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadYellowCarForOne ENDP

loadBlueCarForOne PROC

    ;1
    MOV DX, offset upFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadBlueCarForOne ENDP

loadYellowCarForTWo PROC
    ;1
    MOV DX, offset upFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_Y
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadYellowCarForTwo ENDP

loadBlueCarForTwo PROC

    ;1
    MOV DX, offset upFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_B
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadBlueCarForTwo ENDP

loadFlameCarForOne PROC
    ;1
    MOV DX, offset upFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player1_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player1_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player1_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadFlameCarForOne ENDP

loadFlameCarForTwo PROC

    ;1
    MOV DX, offset upFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_up
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;2
    MOV DX, offset downFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, verti_size
    MOV DX, offset player2_down
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;3
    MOV DX, offset leftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;4
    MOV DX, offset rightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, horiz_size
    MOV DX, offset player2_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;5
    MOV DX, offset upleftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;6
    MOV DX, offset uprightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_up_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;7
    MOV DX, offset downleftFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_left
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    ;8
    MOV DX, offset downrightFName_F
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, diag_size
    MOV DX, offset player2_down_right
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    RET

loadFlameCarForTwo ENDP
