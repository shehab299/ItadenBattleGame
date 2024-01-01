;KEYBOARD KEYS


EnterKey EQU 1CH
EscKey EQU 01H
F1  EQU   3Bh
F2  EQU   3CH
F3  EQU   3DH
F    EQU  21h
G    EQU  22H
Mkey    EQU   32h
Nkey    EQU   31h        
Rkey EQU  13h  
Tkey EQU  14h         
Ykey EQU  15h       
Ukey EQU  16h         
Ikey EQU  17h    

Hkey  EQU  23h
Jkey  EQU  24h       
Ckey  EQU  2Eh                      
Vkey  EQU  2Fh                      
Bkey  EQU  30h        
SpaceKey   EQU   39H


;Player1Keys
W       EQU 11h
s       EQU 1Fh
d       EQU 20h
a       EQU 1Eh
q       EQU 10H
e       equ 12H
z       equ 2ch

xkey    equ 2Bh
;-----------

;Player2Keys
upArrow     EQU   48H 
downArrow   EQU   50h
rightArrow  EQU   4DH
leftArrow   EQU   4BH
p           EQU   19H
o           EQU   18h  
l           EQU   26H
Kkey           EQU   25H
;-----------


;SCREEN PARAMETERS

SCREEN_WIDTH equ 640
SCREEN_HEIGHT equ 480

SCREEN_HEIGHT_DEC equ 410

;GRID PARAMETERS
GRID_WIDTH EQU 8
GRID_HEIGHT EQU 6

CELL_W EQU SCREEN_WIDTH/GRID_WIDTH 
CELL_H EQU SCREEN_HEIGHT_DEC/GRID_HEIGHT

;VIDEO MODE
VIDEO_MODE    EQU 4F02h                                   
VIDEO_MODE_BX EQU 0101h  

BackgroundColor EQU 42H
TrackColor      EQU 08H

;CHOOSING PLAYERS PARAMETERS


SpeedUpColor    EQU     2   ;green

InitialSpeed    EQU     5
IncreasedSpeed  EQU     10
DecreasedSpeed  EQU     3
duration        equ     5

SpeedDownColor    EQU     1  ;blue
ObstacleColor    EQU     4  ;red 
CreateObstaclColor  EQU     6  
AvoidObstaclColor  EQU     5  ;purple

powerlength     EQU     6

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



;CARS PARAMETERS

verti_width equ 17
verti_height equ 29
verti_size equ verti_width * verti_height

horiz_width equ 29
horiz_height equ 17
horiz_size equ horiz_width * horiz_height

diag_width equ 33
diag_height equ 33
diag_size equ diag_width * diag_height

; Define constants for character ranges
UPPERCASE_MIN_ASCII EQU 65
UPPERCASE_MAX_ASCII EQU 90
LOWERCASE_MIN_ASCII EQU 97
LOWERCASE_MAX_ASCII EQU 122