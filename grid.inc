; ;AUTHOR : SHEHAB KHALED & JPASSICA
; ;---------------------------------------
; .MODEL SMALL
; .STACK 32

; ;---------------------------------------
; .DATA


; ; GRID VARS

; START_COLUMN DW ?



; color db 0bh

; SCREEN_WIDTH equ 640
; SCREEN_HEIGHT equ 480

; VIDEO_MODE    EQU 4F02h                                   
; VIDEO_MODE_BX EQU 0101h  

; GRID_WIDTH EQU 8
; GRID_HEIGHT EQU 8

; x DW 0 
; y DW 0

; CELL_W EQU SCREEN_WIDTH/GRID_WIDTH
; CELL_H EQU SCREEN_HEIGHT/GRID_HEIGHT

; ; Arrays used to store the path grid cell coordinates
; PathX dw (GRID_HEIGHT * GRID_WIDTH) dup (0)
; PathY dw (GRID_HEIGHT * GRID_WIDTH) dup (0)
; Path_Length dw 0
; visited dw (GRID_HEIGHT * GRID_WIDTH) dup (0)

; Threshold db GRID_HEIGHT
; RandNum dw ?

; ;RANDOM GENERATOR VARS

; ;PATH GENERATION VARS

; currCount db 0 
; currDirection db 1 ;0 = UP, 1 = DOWN, 2 = LEFT, 3 = RIGHT

; continueLeft db 0 ;bool
; continueRight db 0 ;bool
; forceDirectionChange db 0 ;bool

; ; Array used to mark grid cells as visited
; ; index as (y * GRID_WIDTH + x)


; ; index to use for marking visited
; currIndex dw 0
; ; for checking if a certain cell is visited or not
; probingIndex dw 0




; x_probe db 0
; y_probe db 0

;---------------------------------------
; .code

; GRID_WIDTH EQU 8
; GRID_HEIGHT EQU 8

; x DW 0 
; y DW 0

; CELL_W EQU SCREEN_WIDTH/GRID_WIDTH
; CELL_H EQU SCREEN_HEIGHT/GRID_HEIGHT

; ; Arrays used to store the path grid cell coordinates
; PathX dw (GRID_HEIGHT * GRID_WIDTH) dup (0)
; PathY dw (GRID_HEIGHT * GRID_WIDTH) dup (0)
; Path_Length dw 0
; visited dw (GRID_HEIGHT * GRID_WIDTH) dup (0)

; Threshold db GRID_HEIGHT
; RandNum dw ?



DrawPath proc     
    mov cx,Path_Length
    mov bx,0
    drawTrack:

    mov ax,PathX[bx]
    mov x,ax 

    mov ax,PathY[bx]
    mov y,ax 

    call drawSquare
    inc bx
    inc bx
    loop drawTrack
    ret
DrawPath endp 

Generate proc 
    ;generatePath:

        ;initialize
        call genRand
        mov ax,RandNum
        mov y,0
        mov x,0

        ; the currIndex should keep up with values of x & y
        mov cx,y
        indexLoop:
            add currIndex,GRID_WIDTH
        loop indexLoop

        generatePath:
        ;main subroutine

        cmp x, GRID_WIDTH
        jge exit

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

    exit:   
    ret
Generate endp

genRand PROC ;;CHANGES AX CX

    PUSH AX CX

    mov cx,60000
    loop1:
    loop loop1

    mov cx,60000
    loop2:
    loop loop2

    mov cx,60000
    loop3:
    loop loop3

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
            call updateMap
            jmp block3_cd 

        block2_cd_else:
            cmp currDirection,3 ;RIGHT
            jnz block3_cd
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
            mov currDirection,1 ;DOWN
            ret 

    block4_cd:
        ; OR if block
        cmp continueLeft,1
        jz block4_cd_if1
        
        cmp continueRight,1
        jz block4_cd_if1

        cmp y,1
        jle block4_cd_else1out
            cmp y,GRID_HEIGHT - 2
            jge block4_cd_else1out

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
                jnz block5_cd ; i believe this is where control flow heads

                    cmp continueLeft,1
                    jnz block4_cd_else_if2
                        ;char?
                        mov continueLeft,0
                        mov currDirection,2 ;LEFT
                        jmp block5_cd
                    
                    block4_cd_else_if2:
                        ;char?
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
                        mov currDirection,3 ;RIGHT
                        jmp block5_cd
                
                block4_cd_else_if1_else:
                    mov currDirection,3 ;RIGHT
                    ;char?
                    jmp block5_cd

        block4_cd_else1out:
            cmp y,1
            jle block4_cd_else2out
                ;char?
                mov currDirection,2 ;LEFT
                jmp block5_cd

        block4_cd_else2out:
            cmp y,GRID_HEIGHT - 2
            jge block5_cd
                ;char?
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

    DRAW_PIXELS:
        MOV AL,BackgroundColor
        INT 10H
        INC CX
        CMP CX,BX
        JNE DRAW_PIXELS

    MOV CX,[START_COLUMN]
    INC DX
    CMP DX,DI
    JNE DRAW_PIXELS

    POP CX BX DI
    
    RET
drawSquare endp

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
    inc Path_Length

    ret
updateVisited endp

chooseDirection proc    
    ; if AND block
    cmp currCount,3 ;if less than
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

        cmp currCount,7
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
        call updateMap
        mov continueLeft,1 ;true
        jmp continue_goUp

        ;else
        goUp_else:
        call updateMap
        mov continueRight,1 ;true

    continue_goUp:
    mov currDirection,0 ;UP
    dec x
    dec currIndex
    ret
goUp endp

goLeft proc 
    call updateMap
    dec y
    sub currIndex,GRID_WIDTH
    ret 
goLeft endp 

goRight proc 
    call updateMap
    inc y
    add currIndex,GRID_WIDTH
    RET
goRight endp 

updateMap proc 
    call updateVisited
    ;call drawSquare
    ret 
updateMap endp 

carSearchDraw proc 
    MOV DX,0
    MOV ax,X_POS 
    MOV BX,CELL_W
    div Bx
    mov x,ax

    MOV DX,0
    MOV ax,Y_POS
    MOV BX,CELL_H
    div BX
    mov y,ax

    mov cx,0 
    search_loop:
    MOV DX,x
    MOV BX,CX
    cmp [pathx+BX],DX
    jnz skip_search
        MOV DX,y
        cmp [pathy+BX],DX
        jnz skip_search
            ;found 
            call drawSquare
            cmp cx,0
            jle skip_back_step

            dec cx ; go back one square
            MOV BX,CX
            mov ax,[pathx+BX]
            mov x,ax 

            mov ax,[pathy+BX]
            mov y,ax

            call drawSquare

            skip_back_step:
            cmp cx,Path_Length
            jge skip_fwd_step
            add cx,2
            MOV BX,CX
            mov ax,[pathx+BX]
            mov x,ax 

            mov ax,[pathy+BX]
            mov y,ax

            call drawSquare
            skip_fwd_step:

            ret
    skip_search:
    inc cx
    cmp cx,Path_Length
    jl search_loop

    ret
carSearchDraw endp

genPowerUps PROC
    PUSH AX
    PUSH Bx
    PUSH DX
    PUSH DI 
    PUSH CX

    MOV DI,offset PathX
    MOV BX,offset PathY
    MOV CX,Path_Length

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

    ADD DI,2
    ADD BX,2   

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
    
    CALL ChooseColor
    
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
    MOV BL,5
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
    MOV AL,BackgroundColor
    
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
    JNE ENDD

    CMP DH,starttimeDown1
    JZ ENDD
    MOV starttimeDown1,DH
    INC counterDown1
    CMP counterDown1,duration
    JNZ ENDD
    MOV counterDown1,0
    MOV speed2_X,InitialSpeed
    MOV speed2_Y,InitialSpeed
    MOV UseSpeedDown1,0


    ; CMP UseSpeedUp2,1
    ; JNE CHECKSDOWN

    ; cmp dh,starttimeUP2
    ; jz ENDD
    ; mov starttimeUP2,dh

    
    ; inc counterup2
    ; cmp counterup2,duration
    ; JNZ CHECKSDOWN
    ; MOV counterup2,0
    ; MOV speed2,3
    ; INC powercnt
    ; DEC UseSpeedUp2
    ; CALL RANDPOS

    ; CHECKSDOWN:
    

    ; CHECKSDOWN2:
    ; CMP UseSpeedDown2,1
    ; JNE ENDD

    ; CMP DH,starttimeDOWN2
    ; JZ ENDD
    ; MOV starttimeDOWN2,DH
    ; INC counterdown2
    ; CMP counterdown2,duration
    ; JNZ ENDD
    ; MOV counterdown2,0
    ; MOV speed1,3
    ; DEC UseSpeedDown2

    ENDD:
    RET
    CheckEndPower ENDP