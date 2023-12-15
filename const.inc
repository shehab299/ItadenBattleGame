;KEYBOARD KEYS

EnterKey EQU 1CH
EscKey EQU 01H

;Player1Keys
W EQU 11h
s EQU 1Fh
d EQU 20h
a EQU 1Eh
q EQU 10H
;-----------

;Player2Keys
upArrow     EQU     48H 
downArrow   EQU     50h
rightArrow  EQU     4DH
leftArrow   EQU     4BH
p           EQU     19H
;-----------


;SCREEN PARAMETERS

SCREEN_WIDTH equ 640
SCREEN_HEIGHT equ 480

VIDEO_MODE    EQU 4F02h                                   
VIDEO_MODE_BX EQU 0101h  

BackgroundColor EQU 42H

;CHOOSING PLAYERS PARAMETERS

CharHeight EQU 16
CharWidth EQU 8

player1_x EQU 68
player1_y EQU 272

player2_x EQU 369
player2_y EQU 272

score1_x EQU 128
score1_y EQU 346

score2_x EQU 447
score2_y EQU 346

;GRID PARAMETERS
GRID_WIDTH EQU 5
GRID_HEIGHT EQU 5

CELL_W EQU SCREEN_WIDTH/GRID_WIDTH
CELL_H EQU SCREEN_HEIGHT/GRID_HEIGHT

