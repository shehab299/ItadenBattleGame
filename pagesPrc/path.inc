
getXY proc ;=> put the square index in ax -> result in x , y

    push bx

    mov bl,GRID_WIDTH
    div bl

    dec AL
    dec AH

    mov byte ptr x, ah
    mov byte ptr y,al
    
    pop bx

getXY endp

drawPath proc

    mov x,0
    mov y,0
    call drawSquare

    inc x
    call drawSquare

    inc x
    call drawSquare

    inc y
    call drawSquare

    inc y
    call drawSquare

    dec x
    call drawSquare

    inc y
    call drawSquare

    ret

drawPath endp
