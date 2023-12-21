;AUTHOR : SHEHAB KHALED & JPASSICA
;---------------------------------------
.MODEL SMALL
.STACK 32

;---------------------------------------
.DATA


; GRID VARS

x DW 0 
y DW 0

color db 0bh

SCREEN_WIDTH EQU 640
SCREEN_HEIGHT EQU 480

GRID_WIDTH EQU 8
GRID_HEIGHT EQU 8

CELL_W EQU SCREEN_WIDTH/GRID_WIDTH
CELL_H EQU SCREEN_HEIGHT/GRID_HEIGHT

;RANDOM GENERATOR VARS

Threshold db GRID_HEIGHT
RandNum dw ?

;PATH GENERATION VARS

currCount db 0 
currDirection db 1 ;0 = UP, 1 = DOWN, 2 = LEFT, 3 = RIGHT

continueLeft db 0 ;bool
continueRight db 0 ;bool
forceDirectionChange db 0 ;bool

; Array used to mark grid cells as visited
; index as (y * GRID_HEIGHT + x)
visited dw (GRID_HEIGHT * GRID_WIDTH) dup (0)

; index to use for marking visited
currIndex dw 0
; for checking if a certain cell is visited or not
probingIndex dw 0
; ASSUMING INDEX COULD NOT BE GREATER THAN 64K

x_probe db 0
y_probe db 0

VIDEO_MODE    EQU 4F02h                          
VIDEO_MODE_BX EQU 0101h       
START_COLUMN DW ?

;---------------------------------------
.code

MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX


    mov ax,VIDEO_MODE
    mov bx,VIDEO_MODE_BX
    int 10h
    
    ;generatePath:

        ;initialize
        call genRand
        mov ax,RandNum
        mov y,0
        mov x,0

        generatePath:
        ;main subroutine

        cmp y, GRID_HEIGHT
        jge exit

            call checkCurrentDirections
            call chooseDirection

            cmp y,GRID_HEIGHT
            jge continue_generatePath
                call updateMap
            
            continue_generatePath:

            cmp currDirection,1 ;DOWN
            jnz generatePath
                inc y

        jmp generatePath

    exit: 

    ;waits for keystroke without stopping exec
    MOV AH,0
    INT 16H

    ;terminates program and rets control to os
    MOV AH,4CH
    INT 21H

MAIN ENDP


genRand PROC ;;CHANGES AX CX

    PUSH AX CX

    mov cx,60000
    loop1:
    loop loop1

    mov cx,60000
    loop2:
    loop loop2

    ;mov cx,60000
    ;loop3:
    ;loop loop3

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
    call setCurrIndex 

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

            ; + 1 * GRID_HEIGHT
            add probingIndex, GRID_HEIGHT
            jmp skip_y_probe

        neg_y_probe:

            ; - 1 * GRID_HEIGHT
            sub probingIndex, GRID_HEIGHT

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
            cmp x,1
            jle continue_block1_cd

                jmp block1_cd_if

    continue_block1_cd:
        cmp RandNum,0
        jnz block2_cd
            cmp currDirection,3 ;RIGHT
            jnz block2_cd
                cmp x,GRID_WIDTH -2
                jge block2_cd

    block1_cd_if:
        cmp y,1
        jl block2_cd
            ;set scalars
            mov x_probe,0
            mov y_probe,-1
            call writeProbingIndex
            cmp ax,0
            jnz block2_cd
                mov x_probe,-1
                mov y_probe,-1
                call writeProbingIndex
                cmp ax,0
                jnz block2_cd
                    mov x_probe,1
                    mov y_probe,-1
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
            inc y
            mov currDirection,1 ;DOWN
            ret 

    block4_cd:
        ; OR if block
        cmp continueLeft,1
        jz block4_cd_if1
        
        cmp continueRight,1
        jz block4_cd_if1

        cmp x,1
        jle block4_cd_else1out
            cmp x,GRID_WIDTH - 2
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
                mov x_probe,-1
                mov y_probe,0
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
                mov x_probe,1
                mov y_probe,0
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
            cmp x,1
            jle block4_cd_else2out
                ;char?
                mov currDirection,2 ;LEFT
                jmp block5_cd

        block4_cd_else2out:
            cmp x,GRID_WIDTH - 2
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
        cmp x,1 
        jl continue_block2_ccd
            ; setting probing scalars
            mov x_probe,-1 
            mov y_probe,0
            call writeProbingIndex ;result in ax
            cmp ax,0
            jnz continue_block2_ccd
                dec x 
                ret 

    continue_block2_ccd:

        cmp currDirection,3 ;RIGHT
        jnz continue_block3_ccd
            cmp x,GRID_WIDTH - 1
            jge continue_block3_ccd
                ; setting probing scalars 
                mov x_probe,1
                mov y_probe,0
                call writeProbingIndex ;result in ax
                cmp ax,0
                jnz continue_block3_ccd
                    INC x 
                    ret
    
    continue_block3_ccd:
    
        cmp currDirection,0 ;UP
        jnz continue_block4_ccd
            cmp y,1
            jl continue_block4_ccd
                ; setting probing scalars
                mov x_probe,0
                mov y_probe,-1 ; probe y -1 
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
                            mov x_probe,1
                            mov y_probe,-1
                            call writeProbingIndex
                            cmp ax,0
                            jnz continue_block3_else


                    ccd_block3_if:

                        dec y
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


drawGrid PROC ;;CHANGES CX

    MOV CX,GRID_HEIGHT
    LOOPY:
        PUSH CX
        MOV CX,GRID_WIDTH
        LOOPX:
            call drawSquare
            INC color
            ADD x,CELL_W
        LOOP LOOPX
        MOV x,0
        ADD y,CELL_H
        POP CX
    LOOP LOOPY
drawGrid ENDP


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
    inc color
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

    POP CX BX DI
    
    RET
drawSquare endp

; Updates visited at currIndex in grid
updateVisited proc  
    call setCurrIndex

    mov si,offset visited
    add si,currIndex
    add si,currIndex
    mov [si],1

    ret
updateVisited endp

; sets currIndex = y * grid-height + x
setCurrIndex proc 
    mov ax,x 
    mov currIndex,0
    add currIndex,ax

    mov ax,y 
    mov bx,GRID_HEIGHT
    mul bx ;assume dx empty

    add currIndex,ax
    ret
setCurrIndex endp

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
    dec y 
    ret
goUp endp

goLeft proc 
    call updateMap
    dec x 
    ret 
goLeft endp 

goRight proc 
    call updateMap
    inc x 
    RET
goRight endp 

updateMap proc 
    call updateVisited
    call drawSquare
    ret 
updateMap endp 


END MAIN