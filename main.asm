;AUTHOR : SHEHAB KHALED

;---------------------------------------
.MODEL SMALL

.STACK 32
.286
;---------------------------------------
.DATA

include const.inc
include cars.inc
include img.inc 
include data.inc


;ADDRESS VECTOR FOR INTERRUPTS
INT09_BX DW ?
INT09_ES DW ?

;KEYBOARD BUFFERS

KeyList db 128 dup(0)

;AUX VARIABLES
AUX_IMAGE_WIDTH dw ?
AUX_IMAGE_HEIGHT dw ? 
START_ROW dw ?


;GENERAL FILES

file_buffer db 20000 dup(?)



;validate names


;---------------------------------------
.code

include files.inc ;File and image handling
include UI.inc ;UI
include keyboard.inc ;FOR KEYBOARD CONFIGURATION
include loadCars.inc
include grid.inc
include loop_m.inc


MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX

    ; ;SET VIDEO MODE

    MOV AX,VIDEO_MODE
    MOV BX,VIDEO_MODE_BX
    INT 10H

    BEGIN:
    call setBackgroundColor
    
    ;WELCOME PAGE
    call loadLogo

    call drawWelcomePage
    call clearUnderOwl
    call drawpPlayerInfo
    ; call getInfo
    call getplayer1name


    mainmenu:

    call setBackgroundColor
    
    ;WELCOME PAGE
    call loadLogo

    call drawWelcomePage
    call WaitSomeTime
    call getplayer2name
    call WaitSomeTime

    ;TAKE KEY FROM USER

    CHK_KEY:
    ;MOV AH,0
    ;INT 16H

    ;CMP AH,F1
    ;JE CHAT

    ;CMP AH,EscKey
    ;JE CLOSE

    ;CMP AH,EnterKey
    ;JNE CHK_KEY

    ;jmp Names

    chat:
    
    ;call displaychat
    call inviteToChat
    jmp mainmenu


    ;ENTER NAMES

    Names:   

    ;To display the names
    ; mov ah, 9
    ; mov dx, offset player1_name + 2
    ; int 21h

    ; mov ah, 9
    ; mov dx, offset player2_name + 2
    ; int 21h
    ;CHOOSE CHARACTER
    CHOOSE_LBL:

    CALL loadSmallOwl

    MOV BX, owl_current_row
    
    CALL drawPage

    CALL Choose
   
    ; TAKE CHARACTERS AND STORE THEM

    call setBackgroundColor

    ;START THE GAME

    ; call ConfigKeyboard


    CALL SetConfig

    call MAIN_LOOP

    CALL ResetKeyboard

    JMP BEGIN
    HLT

    CLOSE:
    MOV AH,4CH
    INT 21H

MAIN ENDP


getplayer1name proc
; CHECK_PLAYER1_NAME:
namegetting:
    mov dh, player1_y/CharHeight + 2    ;ROW
    mov dl, player1_x/CharWidth     ;COLUMN
    mov bh, 0      ; Page = 0
    mov bl, BackgroundColor
    mov ah, 02h    ; BIOS.SetCursorPosition
    int 10h  

    mov cx,0
    mov bx, offset player1_name+2
    mov di,offset player2_name+2

   namelop:
    mov ah,1
    int 21h
    cmp al,0dh
    je doneee
    mov byte ptr [bx],al
    add bx,1
    inc cx
    cmp cx,15
    jne namelop

    doneee:

    mov player1_name+1,cl

    cmp cx,0
    jne nameexist

    call emptyNameMsg
    call clear_input1
    wait_for_Enterr1:
    MOV AH, 0
    INT 16H
    CMP AH, EnterKey
    JNE wait_for_Enterr1
    call clear_warnings
    JMP namegetting

    nameexist:

    ;  CHECK_first_characterr:
    MOV AL, player1_name + 2
    CMP AL, UPPERCASE_MIN_ASCII
    JB INVALIDname
    CMP AL, LOWERCASE_MAX_ASCII
    JA INVALIDname
    CMP AL, UPPERCASE_MAX_ASCII
    JA CHECKk_IF_LESS_97
    JMP safename
    CHECKk_IF_LESS_97:
        CMP AL, LOWERCASE_MIN_ASCII
        JB INVALID_NAME
        JMP safename
    
    INVALIDname:
    call clear_input1
    Call invalid_Msg
    wait_for_Enter_:
    MOV AH, 0
    INT 16H
    CMP AH, EnterKey
    JNE wait_for_Enter_
    call clear_warnings

    JMP namegetting
    safename:


ret
getplayer1name endp

getInfo PROC
;PLAYER 1 NAME
    CHECK_PLAYER1_NAME:
    mov dh, player1_y/CharHeight + 2    ;ROW
    mov dl, player1_x/CharWidth     ;COLUMN
    mov bh, 0      ; Page = 0
    mov bl, BackgroundColor
    mov ah, 02h    ; BIOS.SetCursorPosition
    int 10h   

    mov ah, 0AH
    mov dx, offset player1_name
    int 21h

    MOV AL, player1_name + 1
    CMP AL, 0
    JNE CHECK_first_character

    call emptyNameMsg
    call clear_input1
    wait_for_Enterr:
    MOV AH, 0
    INT 16H
    CMP AH, EnterKey
    JNE wait_for_Enterr
    call clear_warnings
    JMP CHECK_PLAYER1_NAME


    CHECK_first_character:
    MOV AL, player1_name + 2
    CMP AL, UPPERCASE_MIN_ASCII
    JB INVALID_NAME
    CMP AL, LOWERCASE_MAX_ASCII
    JA INVALID_NAME
    CMP AL, UPPERCASE_MAX_ASCII
    JA CHECK_IF_LESS_97
    JMP CHECK_PLAYER2_name
    CHECK_IF_LESS_97:
        CMP AL, LOWERCASE_MIN_ASCII
        JB INVALID_NAME
        JMP CHECK_PLAYER2_name
    
    INVALID_NAME:
    call clear_input1
    Call invalid_Msg
    wait_for_Enter:
    MOV AH, 0
    INT 16H
    CMP AH, EnterKey
    JNE wait_for_Enter
    call clear_warnings

    JMP CHECK_PLAYER1_NAME

    ;PLAYER 2 NAME
    CHECK_PLAYER2_name:
    ; mov dh, player2_y/CharHeight + 2    ;ROW
    ; mov dl, player2_x/CharWidth         ;COLUMN
    ; mov bh, 0                           ;Page = 0
    ; mov bl, BackgroundColor
    ; mov ah, 02h                         ;BIOS.SetCursorPosition
    ; int 10h

    ; ;take input form the user
    ; mov ah, 0AH
    ; mov dx, offset player2_name
    ; int 21h

    ; MOV AL, player2_name + 1
    ; CMP AL, 0
    ; JNE CHECK_first_character2

    ; call clear_input2
    ; call emptyNameMsg
    ; wait_for_Enterr2:
    ; MOV AH, 0
    ; INT 16H
    ; CMP AH, EnterKey
    ; JNE wait_for_Enterr2
    ; call clear_warnings
    ; JMP CHECK_PLAYER2_NAME

    ; CHECK_first_character2:
    ; MOV AL, player2_name + 2
    ; CMP AL, UPPERCASE_MIN_ASCII
    ; JB INVALID_NAME2
    ; CMP AL, LOWERCASE_MAX_ASCII
    ; JA INVALID_NAME2
    ; CMP AL, UPPERCASE_MAX_ASCII
    ; JA CHECK2_IF_LESS_97
    ; JMP EXTI_GET_INFO
    ; CHECK2_IF_LESS_97:
    ;     CMP AL, LOWERCASE_MIN_ASCII
    ;     JB INVALID_NAME2
    ;     JMP EXTI_GET_INFO
    
    ; INVALID_NAME2:
    ; call clear_input2
    ; call invalid_Msg
    ; wait_for_Enter2:
    ; MOV AH, 0
    ; INT 16H
    ; CMP AH, EnterKey
    ; JNE wait_for_Enter2
    ; call clear_warnings
    ; JMP CHECK_PLAYER2_NAME

    
    EXTI_GET_INFO:
    RET
getInfo ENDP

ExitProg Proc
    mov ah,4ch
    int 21h
ExitProg ENDP

emptyNameMsg PROC
    MOV DX, offset emptyName_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, emptyName_file_size
    MOV DX, offset emptyName_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset emptyName_file
    MOV AX, emptyName_starting_row
    MOV [START_ROW], AX
    MOV AX, emptyName_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], emptyName_height
    MOV [AUX_IMAGE_WIDTH], emptyName_width
    CALL drawImage
    RET
emptyNameMsg ENDP

invalid_Msg PROC
    MOV DX, offset firstCharCheck_file_name
    MOV DI, offset file_handle
    CALL openFile

    MOV CX, firstCharCheck_file_size
    MOV DX, offset firstCharCheck_file
    MOV BX, [file_handle]
    CALL ReadFileToMemory

    MOV SI, offset firstCharCheck_file
    MOV AX, firstCharCheck_starting_row
    MOV [START_ROW], AX
    MOV AX, firstCharCheck_starting_column
    MOV [START_COLUMN], AX
    MOV [AUX_IMAGE_HEIGHT], firstCharCheck_height
    MOV [AUX_IMAGE_WIDTH], firstCharCheck_width
    CALL drawImage
    RET
invalid_Msg ENDP

clear_input1 PROC
    mov cx, 64                ;Column
    mov dx, 290               ;Row
    mov al, BackgroundColor   ;Pixel color
    mov ah, 0ch               ;Draw Pixel Command
    clear_text1: int 10h
    INC CX
    MOV BX, CX
    SUB BX, 182
    CMP BX, 66
    JNZ clear_text1

    MOV CX, 64
    INC DX
    MOV BX, DX
    SUB BX, 32
    CMP BX, 290
    JNZ clear_text1
    RET
clear_input1 ENDP

clear_input2 PROC
    mov cx, 367                 ;Column
    mov dx, 290                 ;Row
    mov al, BackgroundColor     ;Pixel color
    mov ah, 0ch                 ;Draw Pixel Command
    clear_text2: int 10h
    INC CX
    MOV BX, CX
    SUB BX, 182
    CMP BX, 367
    JNZ clear_text2

    MOV CX, 367
    INC DX
    MOV BX, DX
    SUB BX, 32
    CMP BX, 290
    JNZ clear_text2
    RET
clear_input2 ENDP

clear_warnings PROC
    mov cx, emptyName_starting_column        ;Column
    mov dx, emptyName_starting_row           ;Row
    mov al, BackgroundColor                  ;Pixel color
    mov ah, 0ch                              ;Draw Pixel Command
    clear_msgs: int 10h
    INC CX
    MOV BX, CX
    SUB BX, emptyName_width
    CMP BX, emptyName_starting_column + 2
    JNZ clear_msgs

    MOV CX, emptyName_starting_column
    INC DX
    MOV BX, DX
    SUB BX, emptyName_height
    CMP BX, emptyName_starting_row + 2
    JNZ clear_msgs
    RET
clear_warnings ENDP

findCarRemSteps proc ;DI -> X_POS ; SI -> Y_POS
    MOV DX,0
    MOV ax,DI
    MOV BX,CELL_W
    div Bx
    mov x,ax

    MOV DX,0
    MOV ax,SI
    MOV BX,CELL_H
    div BX
    mov y,ax

    mov cx,0 
    search_findcarindex:
    MOV DX,x
    MOV BX,CX
    cmp [pathx+BX],DX
    jnz skip_search_findcarindex
        MOV DX,y
        cmp [pathy+BX],DX
        jnz skip_search_findcarindex
            ;found
            mov bx,2 
            mov ax,cx 
            mov dx,0          
            div bx      
            mov carIndex,ax
            ret 

    skip_search_findcarindex:
    add cx,2
    cmp cx,200
    jl search_findcarindex
    ret
findCarRemSteps endp

CHECKSEND PROC
    PUSHA
    MOV  DX,3FDH
    LOP1:    IN   AL,DX
             AND  AL,00100000B
             JZ   LOP1
    POPA
    ret
    CHECKSEND ENDP

CHECKRECIEVE PROC
    PUSHA

     MOV  DX,3FDH
     IN   AL,DX
    AND  AL,1
    JZ   NoRecieve
    mov RecieveFlag,1
    jmp donerecieve


    NoRecieve:
    mov RecieveFlag,0
donerecieve:
POPA
    ret
    CHECKRECIEVE ENDP

RecieveByte  proc
PUSHA
MOV  DX,03F8H
IN   AL,DX
MOV  DataIn,AL
POPA
ret
RecieveByte endp

sendbyte proc
PUSHA
MOV  DX,3F8H
 MOV  AL,DataOut
 OUT  DX,AL
 POPA
ret
sendbyte endp

getplayer2name proc
PUSHA
mov si,offset player1_name+2
mov di,offset player2_name +2
mov cl,15

namesloop:

; call CHECKRECIEVE
; cmp RecieveFlag,1
; jne trysend
; call RecieveByte
; mov al,DataIn
; mov ah,0
; mov byte ptr [di],al
; add di,1 

trysend:
mov al,byte ptr [si]
mov DataOut,al
call CHECKSEND
call sendbyte
add si,1
call WaitSomeTime

trysend2:
call CHECKRECIEVE
cmp RecieveFlag,1
jne trysend2
call RecieveByte
mov al,DataIn
mov ah,0
mov byte ptr [di],al
add di,1 
nnnnnn:
dec cl
cmp cl,0
jne namesloop

POPA
ret
getplayer2name endp

Wait_Sec PROC

; in memory
	pusha
	mov ah, 2Ch
	int 21H    ; puts the millseconds in dl
	add dh,waittime
	mov al, dh ; contain hundreds of seconds
	mov bl,60
	mov ah,0
	xor dx,dx
	div bl
    mov goaltime,ah

    wait_loop:
	mov ah, 2Ch
	int 21H    ; puts the millseconds in dl
	mov al, dh ; contain hundreds of seconds
	mov bl,60
	mov ah,0
	xor dx,dx
	div bl
	cmp ah,goaltime
	jnz wait_loop
	popa
	ret
Wait_Sec ENDP

displaychat proc

mov cx, 0           ;Column
    mov dx, 0           ;Row
    mov al, 0         ;Pixel color
    mov ah, 0ch         ;Draw Pixel Command
HorizonQ: int 10h
    INC CX
    CMP CX, 640
    JNZ HorizonQ

    MOV CX, 0
    INC DX
    CMP DX, 480
    JNZ HorizonQ

     mov  ah,0CH
             mov  al,01
             mov  cx,0
             mov  dx,240
    LL1:
             int  10h
             inc  cx
             cmp  cx,640
             jnz  LL1

    call displayPlayerNames

    mov cx, 0           ;Column
            mov dx, 270           ;Row
            mov al, 0         ;Pixel color
            mov ah, 0ch         ;Draw Pixel Command
       HorizonQ3: int 10h
            INC CX
            CMP CX, 640
            JNZ HorizonQ3
        
            MOV CX, 0
            INC DX
            CMP DX, 480
            JNZ HorizonQ3

AGAIN:
            CMP ENDCHAT1,1
            JNE DONTQUIT1
            MOV ENDCHAT1,0
            MOV ENDCHAT2,0
            JMP ENDINGCHAT


            DONTQUIT1:
            CMP ENDCHAT2,1
            JNE DONTQUIT
            MOV ENDCHAT1,0
            MOV ENDCHAT2,0
            JMP ENDINGCHAT
            DONTQUIT:

             mov  dl,SRX
             mov  dh,SRY
             mov  ah,2
             int  10h

             CALL CHECKRECIEVE

             CMP RecieveFlag,1
             JNE SENDLOP

             call RecieveByte

             MOV  DL,DataIn
             MOV  AH,2
             INT  21H
             
             CMP DL,0   
             JNE NOQUIT2
            MOV ENDCHAT2,1
             NOQUIT2:


             MOV  AH,3
             INT  10h
             MOV  SRX,DL
             MOV  SRY,DH

            CMP DataIn,0DH
            JNZ NEXmain
            INC SRY
            NEXmain:

            CMP SRY,30
            JNZ SKIP1111
            mov cx, 0           ;Column
            mov dx, 270           ;Row
            mov al, 0         ;Pixel color
            mov ah, 0ch         ;Draw Pixel Command
       HorizonQ23: int 10h
            INC CX
            CMP CX, 640
            JNZ HorizonQ23
        
            MOV CX, 0
            INC DX
            CMP DX, 480
            JNZ HorizonQ23
            MOV SRY,17
            MOV SRX,0

            SKIP1111:

             JMP  AGAIN
             KOBRY:
             JMP AGAIN

    SENDLOP:

             mov  ah,2
             mov  dl,SSendX
             mov  dh,SSendY
             int  10h

             mov  ah,01h
             int  16h
             jz   KOBRY

             mov  ah,00H
             int  16h
             mov  bl,al
             MOV DataOut,AL

             CMP AH,F3
             JNE NOQUIT
             MOV ENDCHAT1,1

             NOQUIT:

             mov  dl,bl
             mov  ah,2
             INT  21H

             CALL CHECKSEND

             
             call sendbyte


             MOV  AH,3
             INT  10h
             MOV  SSendX,DL
             MOV  SSendY,dh

             CMP BL,0DH
            JNZ NEX1
            INC SSendY
            NEX1:

            CMP SSendY,14
            JNZ SKIPppp
            mov cx, 0           ;Column
            mov dx, 15           ;Row
            mov al, 0         ;Pixel color
            mov ah, 0ch         ;Draw Pixel Command
       HorizonQ2: int 10h
            INC CX
            CMP CX, 640
            JNZ HorizonQ2
        
            MOV CX, 0
            INC DX
            CMP DX, 222
            JNZ HorizonQ2
            MOV SSendX,0
            MOV SSendY,1

            SKIPppp:
             JMP  SENDLOP

    ENDINGCHAT:
ret
displaychat endp

displayplayernames proc
PUSHA
mov ah,2        
mov dx,0 
int 10h  
mov dx, offset player1_name + 2
mov ah, 9
int 21h

mov ah,2                                        
mov dl,0  
mov dh,16 
int 10h 

mov dx, offset player2_name+2
mov ah, 9
int 21h
popa
ret
displayplayernames endp


SetConfig PROC
    MOV  DX,3FBH
    MOV  AL,10000000B
    OUT  DX,AL

    MOV  DX,3F8H
    MOV  AL,0CH
    OUT  DX,AL

    MOV  DX,3F9H
    MOV  AL,00H
    OUT  DX,AL

    MOV  DX,3FBH
    MOV  AL,00011011B
    OUT  DX,AL
    RET
SetConfig ENDP

inviteToChat proc

    mainLoop_inviteToChat:
    ;send 
    mov ah,1    
    int 16h   
    jnz readKeyInviteToChat
    cmp receivedInviteToChat,1
    jnz receive_inviteToChat
    jmp mainLoop_inviteToChat

    readKeyInviteToChat:

    MOV AH,0
    INT 16H

        cmp ah,F1 
    jz continue_send_inviteToChat
    ret 
    continue_send_inviteToChat:
    ;Check that Transmitter Holding Register is Empty
    mov         dx , 3FDH         ; Line Status Register

    In          al , dx           ;Read Line Status
    AND         al , 00100000b
    JZ          receive_inviteToChat             ;jump untill it is empty

    ;If empty put the VALUE in Transmit data register
    mov         dx , 3F8H         ; Transmit data register
    mov         al, F1
    out         dx , al

    cmp invitedChat,1 
    jne not_invited_send
        call displaychat
        mov invitedChat,0
        mov receivedInviteToChat,0
        ret

    not_invited_send:

    ;set cursor
    mov ah, 2h
    mov dh, 350/CharHeight + 2    ;ROW
    mov dl, 130/CharWidth        ;COLUMN
    mov bh, 0         
    mov bh, 00h
    int 10h

    mov ah, 9  
    mov dx, offset sendChatInviteMes
    int 21h
    mov dx,offset player2_name + 2
    int 21h

    mov invitedChat,1


    receive_inviteToChat:

    ;Check that Data Ready
    mov         dx , 3FDH         ; Line Status Register

    in          al , dx
    AND         al , 00000001b

    jnz          readValue_inviteToChat

    cmp invitedChat,1
    jz          receive_inviteToChat
    Jmp          mainLoop_inviteToChat        ;jump untill it recive data

    ;If Ready read the VALUE in Receive data register
    readValue_inviteToChat:
        mov         dx , 03F8H
        in          al , dx
    cmp al,F1   
    je continue_receive_inviteToChat

    ret     

    mainLoop_inviteToChat_bridge_1: jmp mainLoop_inviteToChat   

    continue_receive_inviteToChat:

    cmp invitedChat,1
    jne not_invited_receive
        call displaychat
        mov invitedChat,0
        mov receivedInviteToChat,0
        ret

    not_invited_receive:
    mov ah, 02h                   ;BIOS.SetCursorPosition
    mov dh, 350/CharHeight + 2    ;ROW
    mov dl, 100/CharWidth         ;COLUMN
    mov bh, 0         
    mov bh, 00h
    int 10h

    mov ah,9  
    mov dx, offset player2_name + 2
    int 21h
    mov dx, offset recChatInviteMes
    int 21h


    mov invitedChat,1
    mov receivedInviteToChat,1
    jmp mainLoop_inviteToChat_bridge_1

    ret
inviteToChat ENDP

END MAIN