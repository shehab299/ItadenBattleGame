;greenPowerUp FILE
greenPower_width equ 15
greenPower_height equ 11
greenPower_file_name db '/bin/GPower.bin', 0
greenPower_file_handle dw ?
greenPower_file_size equ greenPower_height * greenPower_width
greenPower_file db greenPower_file_size dup(?)
starting_row dw 10
starting_column dw 10

;---------------------------------------
;red powerup
redPower_width equ 14
redPower_height equ 11
redPower_file_name db '/bin/RPower.bin', 0
redPower_file_size equ redPower_height * redPower_width
redPower_file db redPower_file_size dup(?)
red_powerup_starting_row dw 10
red_powerup_starting_column dw 30

;---------------------------------------
;blue powerup
bluePower_width equ 15
bluePower_height equ 11
bluePower_file_name db '/bin/BPower.bin', 0
bluePower_file_size equ bluePower_height * bluePower_width
bluePower_file db bluePower_file_size dup(?)
blue_powerup_starting_row dw 10
blue_powerup_starting_column dw 50

;---------------------------------------
;evil powerup
evilPower_width equ 12
evilPower_height equ 11
evilPower_file_name db '/bin/EPower.bin', 0
evilPower_file_size equ evilPower_height * evilPower_width
evilPower_file db evilPower_file_size dup(?)
evil_powerup_starting_row dw 10
evil_powerup_starting_column dw 70


 drawGreenPowerUp PROC
        MOV DX, offset greenPower_file_name
        MOV DI, offset greenPower_file_handle
        call openFile

        MOV CX, greenPower_file_size
        MOV DX, offset greenPower_file
        MOV BX, [greenPower_file_handle]
        call ReadFileToMemory

        MOV SI, offset greenPower_file
        MOV AX, starting_row
        MOV [START_ROW], AX
         MOV AX, starting_column
        MOV [START_COLUMN], AX
        MOV [AUX_IMAGE_HEIGHT], greenPower_height
        MOV [AUX_IMAGE_WIDTH], greenPower_width
        CALL drawImage
        RET
    drawGreenPowerUp ENDP

    drawRedPowerUp PROC
    MOV DX, offset redPower_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, redPower_file_size
    MOV DX, offset redPower_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset redPower_file
    MOV AX, red_powerup_starting_row
    MOV [START_ROW], AX
    MOV AX, red_powerup_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], redPower_height
    MOV [AUX_IMAGE_WIDTH], redPower_width
    CALL drawImage
    RET
    drawRedPowerUp ENDP

    drawBluePowerUp PROC
    MOV DX, offset bluePower_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, bluePower_file_size
    MOV DX, offset bluePower_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset bluePower_file
    MOV AX, blue_powerup_starting_row
    MOV [START_ROW], AX
    MOV AX, blue_powerup_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], bluePower_height
    MOV [AUX_IMAGE_WIDTH], bluePower_width
    CALL drawImage
    RET
    drawBluePowerUp ENDP

    drawEvilPowerUp PROC
    MOV DX, offset evilPower_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, evilPower_file_size
    MOV DX, offset evilPower_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset evilPower_file
    MOV AX, evil_powerup_starting_row
    MOV [START_ROW], AX
    MOV AX, evil_powerup_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], evilPower_height
    MOV [AUX_IMAGE_WIDTH], evilPower_width
    CALL drawImage
    RET
    drawEvilPowerUp ENDP