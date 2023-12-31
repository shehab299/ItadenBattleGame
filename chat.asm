;-----------------------------------------MACROS-------------------------------------------------------------
; 0 NOTHING 1 --> 12 THE PIECES BY ORDER IN .DATA

EXT MACRO ;PRESS ANY KEY TO EXIT APPLICATION
                MOV  AH , 0
                ;INT  16h
                MOV         AH,4CH
                INT         21H
ENDM        EXT

movecursor MACRO x,y ;move cursor
                mov         ah,2
                mov         bh,0
                mov cl,x
                mov ch,y
                mov         dh,ch
                mov         dl,cl
                int         10h
                ENDM        movecursor

cin MACRO MyMessage ;cin STRING
                mov ah,0AH
                mov dx,offset MyMessage
                int 21h
                ENDM        cin

ShowMessage MACRO MyMessage ;PRINT STRING
                MOV         AH,9H
                MOV         DX,offset MyMessage
                INT         21H
                ENDM        ShowMessage

ShowCMessage MACRO MyMessage, X ;PRINT STRING WITH COLOR X
                local clp 
                LOCAL otc
                mov SI,offset MyMessage
                
           clp: 
                MOV AL,byte ptr [SI]
                cmp al,'$'
                je otc
                mov ah,9 ;Display
                mov bh,0 ;Page 0
                mov cx,1h ;1 times
                mov bl,X ;Green (A) on white(F) background
                int 10h
                inc SI
                
                cmp byte ptr [si],'$'
                je otc
                mov ah,3h
                mov bh,0h
                int 10h
                
                mov ah,2
                INC DL
                int 10h
                
                jmp clp
                otc: 
                mov ah,3h
                mov bh,0h
                int 10h
                
                mov ah,2
                INC DL
                int 10h
ENDM        ShowCMessage

TOSTRING MACRO OutMessage
    LOCAL divide
    LOCAL OUTH
    LOCAL MAKESTR
    MOV SI,0
    divide:
        mov cl, 10D
        div cl         ; div number(in ax) by 10 
        add ah, '0'     ;Make into a character
        MOV BX,AX
        PUSH BX
        INC SI 
        MOV AH,0 
        cmp AL, 0
        jne divide
        
    mov di,offset OutMessage    
    MAKESTR:
    CMP SI,0
    JE OUTH
    DEC SI
    POP BX
    mov [di],BH
    INC DI
    JMP MAKESTR
    OUTH:
ENDM TOSTRING

.MODEL SMALL
.286
.STACK 64
;-----------
.Data
    char   db 30 dup('$')
    line   db '---------------------------------------------------','$'
    P1NAME db 'AOZ','$'
    P2NAME db 'HELMY','$'
    VALUE  db 3dh

    SendInviteMes db "You sent a chat invitation to $"
    RecInviteMes db " sent you a chat invitation, to accept press F1$" 

    TerminateChatMes1 db "To end chatting with $"
    TerminateChatMes2 db " press F3$"

.CODE
MAIN PROC FAR
    ;INITIALIZING 
                  call        GETDATA
                  CALL        CLS


                  ; draw line separating top and bottom
                  movecursor  00,0AH
                  ShowMessage line

                  ; draw line separating bottom part from notification bar
                  movecursor 00,15H
                  ShowMessage line

                  ; draw notification bar line
                  movecursor 00,16h
                  showmessage TerminateChatMes1
                  showmessage P1NAME
                  showmessage TerminateChatMes2

                  movecursor  00,00H
                  ShowMessage P1NAME

                  movecursor  00,0BH
                  ShowMessage P2NAME

                  movecursor 00,01h

                  ;CALL CONFIG LINE



                  mov         dh,00H
                  mov         dl,0CH
                  push        dx
                  mov         dh,00H
                  mov         dl,01H
                  push        dx

                  ;movecursor  00H,0bH
                
    ;program starts here
    mainloop:     
                  
                
                  mov         ah,01
                  int         16h
                  jz          again_bridge_1

                  mov         ah,0
                  int         16h
                  

                  pop         dx
                  push        dx
                  push        ax
                  movecursor  dh,dl
                  pop         ax
                  pop         dx
                  inc         dh
                  push        dx

                  push        ax

                  mov         ah,2
                  mov         dl,al
                  int         21h

                  pop         ax

                  mov         bl,ah
                  cmp         bl,3dh            ; F3 key
                  jne skip_f3_send
                  ; I should, instead, put it in al and move on to sending
                  ;je          deadmid
                  ;mov al,ah
                  ;jmp afterenter

                  EXT

                  skip_f3_send:
                  ; what if it was the f1 key
                  ;cmp         bl,3bh ; F1
                  ;jne         skip_f1_send

                  ;call showChatInvite
                  ;mov al,ah    
                  ;jmp afterenter

                  ;skip_f1_send:

                  mov         bl,al
                  cmp         bl,13
                  jne         afterenter

                  pop         dx
                  inc         dl
                  mov         dh,0
                  PUSH        dx

                  cmp         dx,0009H          ;CURSOR CHECK
                  jne         afterenter

                  mov         ax,0601h
                  mov         bh,07
                  mov         cx,0100H
                  mov         dx,094FH
                  int         10h
                  POP         DX
                  MOV         DL,8
                  PUSH        DX

                  jmp afterenter

                  again_bridge_1: jmp again

    afterenter:   
    ;Sending a value

    ;Check that Transmitter Holding Register is Empty
                  mov         dx , 3FDH         ; Line Status Register

                  In          al , dx           ;Read Line Status
                  AND         al , 00100000b
                  JZ          AGAIN             ;jump untill it is empty

    ;If empty put the VALUE in Transmit data register
                  mov         dx , 3F8H         ; Transmit data register
                  mov         al,bl
                  out         dx , al

                  ;cmp         al , 3dh  
                  ;jne         skip_exit
                  ;EXT         ; should be changed to go back to main menu
                
                  ;skip_exit:
                  ;cmp         al , 3bh 
                  ;jne         again

                  ;call showChatInvite


                  jmp         AGAIN
           
    ;Receiving a value
    deadmid:      
                  jmp         dead
                  
    AGAIN:        
    ;Check that Data Ready
                  mov         dx , 3FDH         ; Line Status Register
          
                  in          al , dx
                  AND         al , 00000001b
                  JZ          CHK               ;jump untill it recive data

    ;If Ready read the VALUE in Receive data register
                  mov         dx , 03F8H
                  in          al , dx

                  ;cmp         al , 3bh 
                  ;jne         skip_f1_receive

                  ;call showChatInviteRec

                  ;skip_f1_receive:
                  
                  pop         cx
                  pop         dx
                  push        dx
                  push        cx
                  movecursor  dh,dl
                  pop         cx
                  pop         dx
                  inc         dh
                  push        dx
                  push        cx

                  cmp         al,13
                  jne         afterenter2

                  pop         cx
                  pop         dx
                  push        dx
                  push        cx
                  movecursor  dh,dl
                  pop         cx
                  pop         dx
                  inc         dl
                  mov         dh,0
                  push        dx
                  push        cx

                  cmp         dx,0015H          ;CURSOR CHECK changed 17 to 15
                  jne         afterenter2
                

                  PUSH        BX
                  PUSH        AX
                  mov         ax,0601h
                  mov         bh,07
                  mov         cx,0C00H
                  mov         dx,144FH ; changed 164f to 144f
                  int         10h
                  POP         AX
                  POP         BX
                  pop         cx
                  pop         dx
                  MOV         DL,14H ; changed 16 to 14
                  push        dx
                  push        cx

    afterenter2:  

                  mov         dl,al
                  mov         ah,2
                  int         21h
                  
    CHK:          

                  jmp         mainloop
    dead:         
                  EXT
MAIN ENDP
    ;----------------------------------------------------------------------------------------------------------------


    ;--------------------------------------------------Functions---------------------------------------------------------
GETDATA PROC                                    ;GET DATA
                  MOV         AX,@DATA
                  MOV         DS,AX
                  ret
GETDATA ENDP

CLS PROC                                        ;CLEAR SCREEN
                  MOV         AX,0003H          ;;ah == 0 set to graph mod the al = 3 return to text mode
                  INT         10H
                  ret
CLS ENDP

EnterText PROC                                  ;ENTER TEXT MODE
                  MOV         AX,3H
                  INT         10H
                  ret
EnterText ENDP

EnterGraphics PROC                              ;ENTER GRAPHICS MODE
                  MOV         AX,4F02H
                  MOV         BX,103H           ;(800x600) pixel ;grid =480*480; char=60*60
                  INT         10H
                  ret
EnterGraphics ENDP

waitkey PROC                                    ;wait for key
                  MOV         AH , 0
                  INT         16h
                  ret
waitkey ENDP

showChatInvite PROC 
    movecursor 00,16h
    ShowMessage SendInviteMes
    ShowMessage P2NAME
    ret       
showChatInvite ENDP

stopChatting PROC    

    ret
stopChatting ENDP

showChatInviteRec proc     
    movecursor 00,16h   
    ShowMessage P1NAME
    ShowMessage RecInviteMes
    ret       
showChatInviteRec endp


END MAIN

;http://www.wagemakers.be/english/doc/vga