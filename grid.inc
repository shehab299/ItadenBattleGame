
DrawPath_ proc     
    mov cx,Path_Length
    mov bx,0
    drawTrack:

    mov ax,PathX[bx]
    mov x,ax 

    mov ax,PathY[bx]
    mov y,ax 

    mov ax, Path_Tile[bx]

    cmp ax,0
    jnz dp_skip1 
        call drawSquare
        jmp dp_skip0

    dp_skip1:
    cmp ax,1
    jnz dp_skip2
        call drawSquareLeftRight
        jmp dp_skip0

    dp_skip2:
    cmp ax,2
    jnz dp_skip3
        call drawSquareLeftDown
        jmp dp_skip0

    dp_skip3:
    cmp ax,3
    jnz dp_skip4 
        call drawSquareRightDown
        jmp dp_skip0
    
    dp_skip4:
    cmp ax,4
    jnz dp_skip5 
        call drawSquareDownLeft
        jmp dp_skip0
    
    dp_skip5:
    cmp ax,5
    jnz dp_skip0
        call drawSquareDownRight
    
    dp_skip0:

    inc bx
    inc bx
    loop drawTrack
    ret
DrawPath_ endp 

Generate proc 
    ;generatePath:

        ;initialize
        call genRand
        mov ax,RandNum
        mov y,ax
        mov x,0

        ; the currIndex should keep up with values of x & y
        mov cx,y
        indexLoop:
            add currIndex,GRID_WIDTH
        loop indexLoop

        generatePath:
        ;main subroutine

        cmp x, GRID_WIDTH
        jge exit_

            call checkCurrentDirections
            call chooseDirection

            cmp x,GRID_WIDTH
            jge continue_generatePath
                call updateMap
            
            continue_generatePath:

            cmp currDirection,1 ;DOWN
            jnz generatePath
                inc x
                inc currIndex

        jmp generatePath

    exit_:   
    mov ax,Path_Length
    mov Path_Length_dec,ax        
    dec Path_Length_dec
    dec Path_Length_dec
    mov Path_Length_aux,ax 
    add Path_Length_aux,ax
    mov Path_Length_aux_2,ax 
    add Path_Length_aux_2,ax 
    add Path_Length_aux_2,ax 
    add Path_Length_aux_2,ax
    ret
Generate endp


genRand PROC ;;CHANGES AX CX

    PUSH AX CX

    mov cx,60000
    loop1:
    loop loop1

    ;mov cx,60000
    ;loop2:
    ;loop loop2
;
    ;mov cx,60000
    ;loop3:
    ;loop loop3
;
    mov AH, 2Ch
    int 21h

    mov AH,0
    mov AL,dl

    DIV Threshold

    mov al,AH
    mov ah,0
    MOV RandNum,Ax

    POP CX AX

    RET
genRand ENDP

writeProbingIndex proc 

    mov ax,currIndex
    mov probingIndex,ax

    ; ----- x - probe -----
    cmp x_probe,0
    jz skip_x_probe
        
        ;either 1 or -1 
        cmp x_probe,1 
        jnz neg_x_probe

            ; + 1
            add probingIndex,1
            jmp skip_x_probe

        neg_x_probe:

            ; - 1
            sub probingIndex,1

    skip_x_probe:

    ; ----- y - probe -----
    cmp y_probe,0
    jz skip_y_probe
        
        ;either 1 or -1 
        cmp y_probe,1 
        jnz neg_y_probe

            ; + 1 * GRID_WIDTH
            add probingIndex, GRID_WIDTH
            jmp skip_y_probe

        neg_y_probe:

            ; - 1 * GRID_WIDTH
            sub probingIndex, GRID_WIDTH

    skip_y_probe:

    ;now probingIndex is ready

    mov si,offset visited
    add si,probingIndex
    add si,probingIndex

    cmp [si],1
    jz writeProbing_true

        ;writeProbing_false 
        mov ax,0
        ret 

    writeProbing_true:
        mov ax,1
        ret
writeProbingIndex endp 

changeDirection proc   
    mov Threshold,3
    call genRand
    
    ;block 1
    cmp RandNum,0
    jnz continue_block1_cd
        cmp currDirection,2 ;LEFT
        jnz continue_block1_cd
            cmp y,1
            jle continue_block1_cd

                jmp block1_cd_if

    continue_block1_cd:
        cmp RandNum,0
        jnz block2_cd
            cmp currDirection,3 ;RIGHT
            jnz block2_cd
                cmp y,GRID_HEIGHT -2
                jge block2_cd

    block1_cd_if:
        cmp x,1
        jl block2_cd
            ;set scalars
            mov x_probe,-1
            mov y_probe,0
            call writeProbingIndex
            cmp ax,0
            jnz block2_cd
                mov x_probe,-1
                mov y_probe,-1
                call writeProbingIndex
                cmp ax,0
                jnz block2_cd
                    mov x_probe,-1
                    mov y_probe,1
                    call writeProbingIndex
                    cmp ax,0
                    jnz block2_cd 

                        call goUp
                        ret 
    
    block2_cd:
        cmp currDirection,2 ;LEFT
        jnz block2_cd_else 
            mov tile_no, 2;leftdown unchanged
            call updateMap
            jmp block3_cd 

        block2_cd_else:
            cmp currDirection,3 ;RIGHT
            jnz block3_cd
                mov tile_no, 5 ;rightdown to downright
                call updateMap
    
    block3_cd:
        cmp currDirection,2 ;LEFT
        jnz or_block3_cd
            jmp block3_cd_if
        
        or_block3_cd:
            cmp currDirection,3 ;RIGHT
            jnz block4_cd

        block3_cd_if:
            inc x
            inc currIndex
            mov currDirection,0 ;DOWN to leftright
            mov tile_no, 0 ;downpath
            ret 

    block4_cd:
        ; OR if block
        cmp continueLeft,1
        jz block4_cd_if1
        
        cmp continueRight,1
        jz block4_cd_if1

        cmp y,1
        jle bridge_else1out
            cmp y,GRID_HEIGHT - 2
            jge bridge_else1out

        block4_cd_if1:
            cmp continueLeft,1
            jz block4_cd_if2
            
            cmp RandNum,1
            jnz block4_cd_else_if1
                cmp continueRight,0
                jnz block4_cd_else_if1
            
            block4_cd_if2:
                ; set probes 
                mov x_probe,0
                mov y_probe,-1
                call writeProbingIndex 
                cmp ax,0
                jnz bridge_block5_cd ; i believe this is where control flow heads

                    cmp continueLeft,1
                    jnz block4_cd_else_if2
                        ;char?
                        mov continueLeft,0
                        mov tile_no, 5 ;rightdown to downright
                        mov currDirection,2 ;LEFT
                        jmp block5_cd


                        ;bridging 

                        bridge_else1out: jmp block4_cd_else1out
                        bridge_block5_cd: jmp block5_cd
                    
                    block4_cd_else_if2:
                        ;char?
                        mov tile_no, 4;downleft unchanged
                        mov currDirection,2 ;LEFT
                        jmp block5_cd


            block4_cd_else_if1:
                ;set probes 
                mov x_probe,0
                mov y_probe,1
                call writeProbingIndex
                cmp ax,0
                jnz block5_cd
                    cmp continueRight,1
                    jnz block4_cd_else_if1_else
                        mov continueRight,0
                        ;char?
                        mov tile_no, 2 ;leftdown unchanged
                        mov currDirection,3 ;RIGHT
                        jmp block5_cd
                
                block4_cd_else_if1_else:
                    mov tile_no, 3 ;downright to rightdown
                    mov currDirection,3 ;RIGHT
                    ;char?
                    jmp block5_cd

        block4_cd_else1out:
            cmp y,1
            jle block4_cd_else2out
                ;char?
                mov tile_no, 4 ;downleft
                mov currDirection,2 ;LEFT
                jmp block5_cd

        block4_cd_else2out:
            cmp y,GRID_HEIGHT - 2
            jge block5_cd
                ;char?
                mov tile_no, 3 ;downright to rightdown
                mov currDirection,3 ;RIGHT
        
    block5_cd:
            cmp currDirection,2 ;LEFT
            jnz block5_cd_else
                call goLeft
                ret 
            
            block5_cd_else:
                cmp currDirection,3 ;RIGHT
                jnz exit_cd
                    call goRight
                    ret

    exit_cd:
    ret
changeDirection endp

checkCurrentDirections PROC 

    ; block #1
    ; if AND block
    cmp currDirection,2 ;LEFT
    jnz continue_block2_ccd
        cmp y,1 
        jl continue_block2_ccd
            ; setting probing scalars
            mov x_probe,0
            mov y_probe,-1
            call writeProbingIndex ;result in ax
            cmp ax,0
            jnz continue_block2_ccd
                dec y
                sub currIndex,GRID_WIDTH ; index should keep up
                ret 

    continue_block2_ccd:

        cmp currDirection,3 ;RIGHT
        jnz continue_block3_ccd
            cmp y,GRID_HEIGHT - 1
            jge continue_block3_ccd
                ; setting probing scalars 
                mov x_probe,0
                mov y_probe,1
                call writeProbingIndex ;result in ax
                cmp ax,0
                jnz continue_block3_ccd
                    INC y 
                    add currIndex,GRID_WIDTH ; index should keep up
                    ret
    
    continue_block3_ccd:
    
        cmp currDirection,0 ;UP
        jnz continue_block4_ccd
            cmp x,1
            jl continue_block4_ccd
                ; setting probing scalars
                mov x_probe,-1
                mov y_probe,0 
                call writeProbingIndex
                cmp ax,0
                jnz continue_block4_ccd
                    ; INSIDE OF BLOCK 3


                        cmp continueLeft,1
                        jnz continue_block3_continue_ccd
                            ; set probes
                            mov x_probe,-1
                            mov y_probe,-1
                            call writeProbingIndex
                            cmp ax,0
                            jnz continue_block3_continue_ccd

                            jmp ccd_block3_if 

                    continue_block3_continue_ccd:
                        cmp continueRight,1
                        jnz continue_block3_else
                            ; set probes
                            mov x_probe,-1
                            mov y_probe,1
                            call writeProbingIndex
                            cmp ax,0
                            jnz continue_block3_else


                    ccd_block3_if:

                        dec x
                        dec currIndex
                        ret

                    continue_block3_else:
                        mov forceDirectionChange,1
                        ret

    continue_block4_ccd:
        cmp currDirection,1 ;DOWN
        jz exit_ccd
            mov forceDirectionChange,1
            ret 

    exit_ccd:
    ret
checkCurrentDirections ENDP

drawSquare proc
    PUSH DI BX CX

    mov ax , x;
    mov bx,CELL_W
    mov dx,0
    mul bx
    mov cx,ax

    mov [START_COLUMN],CX

    mov ax, y;
    mov bx,CELL_H
    mov dx,0
    mul bx
    mov dx,ax

    MOV BX,CX
    ADD BX,CELL_W

    MOV DI,DX
    ADD DI,CELL_H

    MOV AX,DS
    MOV ES,AX

    MOV AH,0CH    
    ; inc color
    DRAW_PIXELS:
        MOV AL,color
        INT 10H
        INC CX
        CMP CX,BX
        JNE DRAW_PIXELS

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE DRAW_PIXELS

    sub dx,CELL_H
    mov cx,[START_COLUMN]
    mov al,border_color

    DRAW_BORDER11:
        int 10h
        inc dx 
        cmp dx,di
    jne DRAW_BORDER11

    sub dx,CELL_H
    mov cx,bx

    DRAW_BORDER12:
        int 10h
        inc dx 
        cmp dx,di
    jne DRAW_BORDER12

    POP CX BX DI
    
    RET
drawSquare endp

drawSquareLeftRight proc
    PUSH DI BX CX

    mov ax , x;
    mov bx,CELL_W
    mov dx,0
    mul bx
    mov cx,ax

    mov [START_COLUMN],CX

    mov ax, y;
    mov bx,CELL_H
    mov dx,0
    mul bx
    mov dx,ax

    MOV BX,CX
    ADD BX,CELL_W

    MOV DI,DX
    ADD DI,CELL_H

    MOV AX,DS
    MOV ES,AX

    MOV AH,0CH    
    ; inc color
    DRAW_PIXELS2:
        MOV AL,color
        INT 10H
        INC CX
        CMP CX,BX
        JNE DRAW_PIXELS2

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE DRAW_PIXELS2

    sub dx,CELL_H
    mov cx,[START_COLUMN]
    mov al,border_color

    DRAW_BORDER21:
        int 10h
        inc cx
        cmp cx,bx
    jne DRAW_BORDER21

    add dx,CELL_H
    mov cx,[START_COLUMN]

    DRAW_BORDER22:
        int 10h
        inc cx 
        cmp cx,bx
    jne DRAW_BORDER22

    POP CX BX DI
    
    RET
drawSquareLeftRight endp

drawSquareLeftDown proc
    PUSH DI BX CX

    mov ax , x;
    mov bx,CELL_W
    mov dx,0
    mul bx
    mov cx,ax

    mov [START_COLUMN],CX

    mov ax, y;
    mov bx,CELL_H
    mov dx,0
    mul bx
    mov dx,ax

    MOV BX,CX
    ADD BX,CELL_W

    MOV DI,DX
    ADD DI,CELL_H

    MOV AX,DS
    MOV ES,AX

    MOV AH,0CH    
    ; inc color
    DRAW_PIXELS3:
        MOV AL,color
        INT 10H
        INC CX
        CMP CX,BX
        JNE DRAW_PIXELS3

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE DRAW_PIXELS3

    sub dx,CELL_H
    mov cx,[START_COLUMN]
    mov al,border_color

    DRAW_BORDER31:
        int 10h
        inc cx
        cmp cx,bx
    jne DRAW_BORDER31

    ;add dx,CELL_H
    mov cx,[START_COLUMN]

    DRAW_BORDER32:
        int 10h
        inc dx 
        cmp dx,di
    jne DRAW_BORDER32

    POP CX BX DI
    
    RET
drawSquareLeftDown endp

drawSquareRightDown proc
    PUSH DI BX CX

    mov ax , x;
    mov bx,CELL_W
    mov dx,0
    mul bx
    mov cx,ax

    mov [START_COLUMN],CX

    mov ax, y;
    mov bx,CELL_H
    mov dx,0
    mul bx
    mov dx,ax

    MOV BX,CX
    ADD BX,CELL_W

    MOV DI,DX
    ADD DI,CELL_H

    MOV AX,DS
    MOV ES,AX

    MOV AH,0CH    
    ; inc color
    DRAW_PIXELS4:
        MOV AL,color
        INT 10H
        INC CX
        CMP CX,BX
        JNE DRAW_PIXELS4

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE DRAW_PIXELS4

    sub dx,CELL_H
    mov cx,[START_COLUMN]
    mov al,border_color

    DRAW_BORDER41:
        int 10h
        inc cx
        cmp cx,bx
    jne DRAW_BORDER41

    ;add dx,CELL_H
    ;mov cx,[START_COLUMN]

    DRAW_BORDER42:
        int 10h
        inc dx 
        cmp dx,di
    jne DRAW_BORDER42

    POP CX BX DI
    
    RET
drawSquareRightDown endp

drawSquareDownLeft proc
    PUSH DI BX CX

    mov ax , x;
    mov bx,CELL_W
    mov dx,0
    mul bx
    mov cx,ax

    mov [START_COLUMN],CX

    mov ax, y;
    mov bx,CELL_H
    mov dx,0
    mul bx
    mov dx,ax

    MOV BX,CX
    ADD BX,CELL_W

    MOV DI,DX
    ADD DI,CELL_H

    MOV AX,DS
    MOV ES,AX

    MOV AH,0CH    
    ; inc color
    DRAW_PIXELS5:
        MOV AL,color
        INT 10H
        INC CX
        CMP CX,BX
        JNE DRAW_PIXELS5

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE DRAW_PIXELS5

    sub dx,CELL_H
    mov cx,bx
    mov al,border_color

    DRAW_BORDER51:
        int 10h
        inc dx 
        cmp dx,di
    jne DRAW_BORDER51

    ;add dx,CELL_H
    ;mov cx,[START_COLUMN]

    DRAW_BORDER52:
        int 10h
        dec cx 
        cmp cx,[START_COLUMN]
    jne DRAW_BORDER52

    POP CX BX DI
    
    RET
drawSquareDownLeft endp

drawSquareDownRight proc
    PUSH DI BX CX

    mov ax , x;
    mov bx,CELL_W
    mov dx,0
    mul bx
    mov cx,ax

    mov [START_COLUMN],CX

    mov ax, y;
    mov bx,CELL_H
    mov dx,0
    mul bx
    mov dx,ax

    MOV BX,CX
    ADD BX,CELL_W

    MOV DI,DX
    ADD DI,CELL_H

    MOV AX,DS
    MOV ES,AX

    MOV AH,0CH    
    ; inc color
    DRAW_PIXELS6:
        MOV AL,color
        INT 10H
        INC CX
        CMP CX,BX
        JNE DRAW_PIXELS6

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE DRAW_PIXELS6

    sub dx,CELL_H
    mov cx,[START_COLUMN]
    mov al,border_color

    DRAW_BORDER61:
        int 10h
        inc dx 
        cmp dx,di
    jne DRAW_BORDER61

    ;add dx,CELL_H
    ;mov cx,[START_COLUMN]

    DRAW_BORDER62:
        int 10h
        inc cx 
        cmp cx,bx
    jne DRAW_BORDER62

    POP CX BX DI
    
    RET
drawSquareDownRight endp

; Updates visited at currIndex in grid
updateVisited proc  

    mov si,offset visited
    add si,currIndex
    add si,currIndex
    mov [si],1


    mov bx,Path_Length
    ADD bx,Path_Length

    mov ax,x
    mov PathX[bx],ax     

    mov ax,y
    mov PathY[bx],ax

    mov ax,tile_no
    mov Path_Tile[bx],ax

    inc Path_Length

    ret
updateVisited endp

chooseDirection proc    
    ; if AND block
    cmp currCount,2 ;if less than
    jge chooseDirection_else
        cmp forceDirectionChange,0
        jnz chooseDirection_else
            inc currCount
            ret

    chooseDirection_else:
        mov Threshold,2
        call genRand

        ; if OR block
        cmp RandNum,1 ;chance to change
        jz chooseDirection_innerBlock

        cmp forceDirectionChange,1
        jz chooseDirection_innerBlock

        cmp currCount,3
        jge chooseDirection_innerBlock

        jmp chooseDirection_skipInnerBlock

        chooseDirection_innerBlock:

            mov currCount,0
            mov forceDirectionChange,0
            call changeDirection

        chooseDirection_skipInnerBlock:

            inc currCount

    ret 
chooseDirection endp 

goUp proc  

    cmp currDirection,2 ;LEFT 
    jnz goUp_else
        mov tile_no, 3 ;downright to rightdown
        call updateMap
        mov continueLeft,1 ;true
        jmp continue_goUp

        ;else
        goUp_else:
        mov tile_no, 4 ;downleft unchanged
        call updateMap
        mov continueRight,1 ;true

    continue_goUp:
    mov currDirection,0 ;UP
    dec x
    dec currIndex
    mov tile_no, 1 ;downpath to leftright
    ret
goUp endp

goLeft proc 
    call updateMap
    dec y
    sub currIndex,GRID_WIDTH
    mov tile_no, 0 ;leftright to downpath
    ret 
goLeft endp 

goRight proc 
    call updateMap
    inc y
    add currIndex,GRID_WIDTH
    mov tile_no, 0 ;leftright to downpath
    RET
goRight endp 

updateMap proc 
    call updateVisited
    ;call drawSquare
    ret 
updateMap endp 


genPowerUps PROC
    PUSH AX
    PUSH Bx
    PUSH DX
    PUSH DI 
    PUSH CX

     MOV CX,Path_Length
    ; SUB CX,1
    MOV AX,CX
    MOV BL,4
    DIV BL
    MOV CL,al
    MOV CH,0

    MOV DI,offset PathX
    ADD DI,2
    MOV BX,offset PathY
    ADD BX,2
   


    LoopOnPath:
    MOV AX,CELL_W
    MUL [DI]
    MOV StartX,AX
    MOV EndX,AX
    ADD EndX,CELL_W

    MOV AX,CELL_H
    MUL [BX]
    MOV StartY,AX
    MOV EndY,AX
    ADD EndY,CELL_H

    CALL RandPowerUp

    ADD DI,8
    ADD BX,8  

    DEC CX
    CMP CX,0
    JNZ LoopOnPath

    POP CX
    POP DI
    POP DX
    POP Bx
    POP AX

    RET
    genPowerUps ENDP


genObstacles PROC
    PUSH AX
    PUSH Bx
    PUSH DX
    PUSH DI 
    PUSH CX

    MOV CX,Path_Length
    SUB CX,2
    MOV AX,CX
    MOV BL,2
    DIV BL
    MOV CL,al
    MOV CH,0

    MOV DI,offset PathX
    ADD DI,4
    MOV BX,offset PathY
    ADD BX,4
   


    LoopOnPath2:
    MOV AX,CELL_W
    MUL [DI]
    MOV StartX,AX
    MOV EndX,AX
    ADD EndX,CELL_W

    MOV AX,CELL_H
    MUL [BX]
    MOV StartY,AX
    MOV EndY,AX
    ADD EndY,CELL_H

    CALL RandObstacles

    ADD DI,4
    ADD BX,4   

    DEC CX
    CMP CX,0
    JNZ LoopOnPath2

    POP CX
    POP DI
    POP DX
    POP Bx
    POP AX

    RET
    genObstacles ENDP

RandObstacles PROC
    PUSH dx
    PUSH CX
    PUSH AX  
    PUSH Bx
    PUSH DI

    AGAINN2: Mov AH, 2CH
    INT 21H
    MOV DH,0
    CMP DL,60
    JC LAB12
    SUB DL,50
    LAB12:
    CMP DL,0
    JNZ LAB22
    ADD DL,10
    LAB22:
    CMP DX,Prev
    JZ AGAINN2
    MOV Prev,DX
    MOV CH,0
    MOV CL,dL



    MOV DX,StartY
    ADD DX,CX

    MOV BX,EndY
    SUB BX,dx
    CMP BX,6  
    JC Skip2


    ADD CX,10
    MOV AX,CX
    MOV CX,StartX
    ADD CX,AX

    MOV BX,EndX
    SUB BX,CX
    CMP BX,6  
    JC Skip2

    MOV DI,DX
    SUB DI,PrevRow
    CMP DI,20
    JNC NoSkip2
    MOV BX,CX
    SUB BX,PrevCol
    CMP BX,20
    JNC NoSkip2
    JMP Skip2 

    NoSkip2:
    MOV PrevRow,DX
    MOV PrevCol,CX

    MOV AL,04

    CALL DrawPower
    Skip2:
    POP DI
    POP BX
    POP AX
    POP CX
    POP DX

    RET
RandObstacles ENDP

RandPowerUp PROC
    PUSH dx
    PUSH CX
    PUSH AX  
    PUSH Bx
    PUSH DI

    AGAINN: Mov AH, 2CH
    INT 21H
    MOV DH,0
    CMP DL,60
    JC LAB1
    SUB DL,50
    LAB1:
    CMP DL,0
    JNZ LAB2
    ADD DL,10
    LAB2:
    CMP DX,Prev
    JZ AGAINN
    MOV Prev,DX
    MOV CH,0
    MOV CL,dL



    MOV DX,StartY
    ADD DX,CX

    MOV BX,EndY
    SUB BX,dx
    CMP BX,6  
    JC Skip


    ADD CX,10
    MOV AX,CX
    MOV CX,StartX
    ADD CX,AX

    MOV BX,EndX
    SUB BX,CX
    CMP BX,6  
    JC Skip

    MOV DI,DX
    SUB DI,PrevRow
    CMP DI,20
    JNC NoSkip
    MOV BX,CX
    SUB BX,PrevCol
    CMP BX,20
    JNC NoSkip
    JMP Skip 

    NoSkip:
    MOV PrevRow,DX
    MOV PrevCol,CX

    CALL ChooseColor

    CALL DrawPower
    Skip:
    POP DI
    POP BX
    POP AX
    POP CX
    POP DX

    RET
RandPowerUp ENDP

ChooseColor proc
    PUSH Bx
    PUSH DX
    PUSH DI 
    PUSH CX
    
    Mov AH, 2CH
    INT 21H
    MOV BL,5
    MOV DH,0
    MOV AX,DX
    DIV bl

    CMP AH,0
    JNE NextColor
    MOV AL,SpeedUpColor
    JMP EndColor
    NextColor:
    CMP AH,4
    JNE NextColor1
    MOV AL,AvoidObstaclColor  
    JMP EndColor
    NextColor1:
    CMP AH,3
    JNE NextColor2
    MOV AL,CreateObstaclColor
    JMP EndColor
    NextColor2:
    CMP AH,2  
    JNE NextColor3
    MOV AL,ObstacleColor
    JMP EndColor
    NextColor3:
    MOV AL,SpeedDownColor
    EndColor: 
    POP CX
    POP DI
    POP DX
    POP Bx

ret
ChooseColor endp

DrawPower   PROC
    PUSH AX
    PUSH Bx
    PUSH DX
    PUSH DI 
    PUSH CX
    
    
    MOV DI,DX 
    ADD DI,6
    
    MOV BX,CX
    ADD BX,6
    
    MOV AH,0CH
    
LOPSEC: 
    LOPSEC2:
        INT 10H
        INC DX
        CMP DX,DI
        JNZ LOPSEC2  
    MOV DX,DI
    SUB DX,6
    INC CX
    CMP CX,BX
    JNZ LOPSEC 

    POP CX
    POP DI
    POP DX
    POP Bx
    POP AX

    RET
    DrawPower ENDP

DrawRandomPowerUp PROC
    PUSH AX
    PUSH Bx
    PUSH DX
    PUSH DI 
    PUSH CX

    MOV BH,DH

    MOV AH,0
    MOV AL,DH
    MOV BL,10
    DIV BL        
    CMP AH,0
    JNE NoDraw   ;IF TIME DIVISBLE BY -- DRAW RANDOM POWER UP

    MOV BL,BH
    MOV BH,0   ;INDEX IN BX

    TryAgain:
    CMP BX,Path_Length
    JC SetStart
    SUB BX,Path_Length
    JMP TryAgain

    SetStart:

    CMP BX,PrevIndex
    JZ NoDraw
    MOV PrevIndex,BX

    MOV CX,BX
    CMP BX,0
    JZ NoDraw
    CMP BX,Path_Length
    JZ NoDraw

    MOV DI,OFFSET PathX
    FindingX:
    ADD DI,2
    DEC CX
    CMP CX,0
    JNZ FindingX

    MOV AX,CELL_W
    MUL [DI]
    MOV StartX,AX
    MOV EndX,AX
    ADD EndX,CELL_W

    MOV DI,OFFSET PathY
    FindingY:
    ADD DI,2
    DEC BX
    CMP BX,0
    JNZ FindingY

    MOV AX,CELL_H
    MUL [DI]
    MOV StartY,AX
    MOV EndY,AX
    ADD EndY,CELL_H

    CALL ChooseColor

    CALL RandPowerUp

    NoDraw:

    POP CX
    POP DI
    POP DX
    POP Bx
    POP AX
    RET
    DrawRandomPowerUp ENDP

ClearPwr    proc
PUSH dx
PUSH CX
PUSH Ax
PUSH DI  
PUSH BX    
    MOV AL,TrackColor
    
    MOV DI,DX 
    ADD DI,powerlength
    sub dx,powerlength
    
    MOV BX,CX
    ADD BX,powerlength
    sub cx,powerlength
    
    MOV AH,0CH
    
ClearOutLoop: 
    ClearInLoop:
        INT 10H
        INC DX
        CMP DX,DI
        JNZ ClearInLoop  
    MOV DX,DI
    SUB DX,powerlength
    sub dx,powerlength
    INC CX
    CMP CX,BX
    JNZ ClearOutLoop

    POP BX
    POP DI
    POP AX
    POP CX
    POP DX

ret
ClearPwr endp

drawFinishLine proc      
    PUSH DI BX CX SI

    ; get last position
    mov bx,Path_Length
    add bx,Path_Length
    sub bx,2

    mov ax,pathx[bx]
    mov x,Ax
    mov ax,pathy[bx]
    mov y,ax 
    mov ax,Path_Tile[bx]  
    mov tile_no,ax     

    mov ax , x;
    mov bx,CELL_W
    mov dx,0
    mul bx
    mov cx,ax

    mov [START_COLUMN],CX

    mov ax, y;
    mov bx,CELL_H
    mov dx,0
    mul bx
    mov dx,ax

    MOV BX,CX
    ADD BX,CELL_W
    ADD CX,2
    ;add bx,10 ;prob change that between h and v

    MOV DI,DX
    ADD DI,CELL_H

    MOV AX,DS
    MOV ES,AX

    MOV AH,0CH    

    cmp tile_no,0 
    jnz drawFinishLineH

        mov bx,cx 
        add bx,10
    drawFinishLineV1:
        mov al,0fh ;draw white first
        int 10h   
        inc dx        
        cmp dx,di 
        jne drawFinishLineV1
        sub dx,CELL_H
        inc cx
        cmp cx, bx      
        jne drawFinishLineV1

        ; black squares
        mov cx,[START_COLUMN]
        add dx,10

        mov si,10 ;counter lol

        drawFinishLineV2:
        mov al,0fh    
        int 10H
        inc dx 
        dec si         
        jnz drawFinishLineV2
        mov si,10
        add dx,10
        cmp dx,di               
        jl drawFinishLineV2
        mov dx,di                
        sub dx,50
        inc cx 
        cmp cx,bx      
        jne drawFinishLineV2
        POP DI BX CX SI
        ret

    drawFinishLineH:

    cmp tile_no,2 
    jnz drawFinishLineY
        mov dx,di                
        sub dx,10
    drawFinishLineH1:
        mov al,0fh     
        int 10h
        inc dx        
        cmp dx,di                
    jne drawFinishLineH1
        sub dx,10
        inc cx 
        cmp cx,bx         
    jne drawFinishLineH1

        mov cx,[START_COLUMN]
        add cx,16

        mov si,2
        mov bx,cx 
        add bx,16
    drawFinishLineH2:
        mov al,0fh    
        int 10h 
        inc dx 
        cmp dx,di 
    jne drawFinishLineH2
        sub dx,10 
        inc cx
        cmp cx,bx 
    jne drawFinishLineH2
        add cx,16 
        add bx,32
        dec si
    jnz drawFinishLineH2
        POP DI BX CX SI
        ret

    drawFinishLineY:
        mov di,dx                   
        add di,10
    drawFinishLineY1:
        mov al,0fh     
        int 10h
        inc dx        
        cmp dx,di                
    jne drawFinishLineY1
        sub dx,10
        inc cx 
        cmp cx,bx         
    jne drawFinishLineY1

        mov cx,[START_COLUMN]
        add cx,16

        mov si,2
        mov bx,cx 
        add bx,16
    drawFinishLineY2:
        mov al,0fh    
        int 10h 
        inc dx 
        cmp dx,di 
    jne drawFinishLineY2
        sub dx,10 
        inc cx
        cmp cx,bx 
    jne drawFinishLineY2
        add cx,16 
        add bx,32
        dec si
    jnz drawFinishLineY2
    
    POP DI BX CX SI
    ret
drawFinishLine endp


CheckEndPower PROC

    MOV AH,2CH  
    INT 21H  

    CMP UseSpeedUp1,1
    JNE NextCheck

    cmp dh,starttimeUP1
    jz NextCheck

    mov starttimeUP1,dh
    inc counterup1
    cmp counterup1,duration
    JNZ NextCheck

    mov counterup1,0
    MOV speed1_X,InitialSpeed
    MOV speed1_Y,InitialSpeed
    MOV UseSpeedUp1,0

    NextCheck:
    CMP UseSpeedDown1,1
    JNE NextCheck1

    CMP DH,starttimeDown1
    JZ NextCheck1
    MOV starttimeDown1,DH
    INC counterDown1
    CMP counterDown1,duration
    JNZ NextCheck1
    MOV counterDown1,0
    MOV speed2_X,InitialSpeed
    MOV speed2_Y,InitialSpeed
    MOV UseSpeedDown1,0

    NextCheck1:
    CMP UseSpeedUp2,1
    JNE NextCheck2

    cmp dh,starttimeUP2
    jz NextCheck2

    mov starttimeUP2,dh
    inc counterup2
    cmp counterup2,duration
    JNZ NextCheck2

    mov counterup2,0
    MOV speed2_X,InitialSpeed
    MOV speed2_Y,InitialSpeed
    MOV UseSpeedUp2,0

    NextCheck2:
    CMP UseSpeedDown2,1
    JNE ENDD

    CMP DH,starttimeDown2
    JZ ENDD
    MOV starttimeDown2,DH
    INC counterDown2
    CMP counterDown2,duration
    JNZ ENDD
    MOV counterDown2,0
    MOV speed1_X,InitialSpeed
    MOV speed1_Y,InitialSpeed
    MOV UseSpeedDown2,0

    ENDD:
    RET
    CheckEndPower ENDP