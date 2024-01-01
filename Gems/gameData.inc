PATH_LENGTH DB ?
PATH DB GRID_WIDTH * GRID_HEIGHT DUP(?)

PATH_EX_LENGTH DB 7 
PATH_EX DB 0,1,2,7,12,13,14
VAL     DB      1

MovingSQR   DB      0
powercnt    db      1       ;number of powerups on screen
firpower    db      0      ;first player powerups
secpower    db      0
USEPWR      DB      0
USEPWR2     DB      0

powerrow    dw      50
powercol    dw      50

starttime   db      0
endtime     db      0
counter     db      0
duration    equ     5


TIME_AUX DB 0

PreX    DW  0
PreY    DW  0

squareX DW 0
squareY DW 0

PreX2   DW  0
PreY2   DW  30

squareX2 DW 0
squareY2 DW 30

speed1 DW 2
speed2 DW 2

player1Keys DW 0
player2Keys DW 0


;Parameters
squareLength EQU 10
fircolor    EQU  0FH
seccolor    EQU 0ah
powercolor  EQU  04h
upSpeed EQU 3