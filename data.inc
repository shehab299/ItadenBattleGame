waittime db 4
goaltime db ?

DataOut DB ?
DataIn  DB '8'
SRX     db 0
SRY     db 17
SSendX  db 0
SSendY  db 1
RecieveFlag  db    0
sendflag     db    0

TimeRow     dw      0
TimeCol     dw      0
TimeMin     dw      0
TimeSec     dw      0
TimeDur     dw      120
TimeCounter dw      0
LastTime    dw      0

PrevX1      dw      200
PrevY1      dw      200

PrevX2      dw      400
PrevY2      dw      400

MovingCar       db      0

CornerTLRow     DW      0
CornerTLCol     DW      0
CornerBLRow     DW      0
CornerBLCol     DW      0
CornerTRRow     DW      0
CornerTRCol     DW      0
CornerBRRow     DW      0
CornerBRCol     DW      0

CornerTLRow2     DW      0
CornerTLCol2     DW      0
CornerBLRow2     DW      0
CornerBLCol2     DW      0
CornerTRRow2     DW      0
CornerTRCol2     DW      0
CornerBRRow2     DW      0
CornerBRCol2     DW      0

FirstVertical   db      0
FirstHorizontal   db      0
SecondVertical   db      0
SecondHorizontal   db      0
CarIntersect        db      0


;PLAYER CARS

player1_up  db verti_size dup(?)
player1_down db verti_size dup(?)
player1_left  db horiz_size dup(?)
player1_right  db horiz_size dup(?)
player1_up_left db diag_size dup(?)
player1_up_right db diag_size dup(?)
player1_down_left db diag_size dup(?)
player1_down_right db diag_size dup(?)

player2_up  db verti_size dup(?)
player2_down db verti_size dup(?)
player2_left  db horiz_size dup(?)
player2_right  db horiz_size dup(?)
player2_up_left db diag_size dup(?)
player2_up_right db diag_size dup(?)
player2_down_left db diag_size dup(?)
player2_down_right db diag_size dup(?)
file_handle DW ?

SUB_WIDTH DW ?
SUB_HEIGHT DW ? 

;VALIDATION_BOOLEANS

OUT_OF_SCREEN_BOOL DB ?
OUT_OF_PATH_BOOL DB ?



MovingSQR DB 0
TIME_AUX DB 0

;PLAYER 1

X_POS DW 200
Y_POS DW 200
DIRS DB 4

AUX_X DW ?
AUX_Y DW ?
AUX_DIR db 4


speed1_X DW 5
speed1_Y DW 5

PrevState db 0
CurrentState db 0

;PLAYER 2

X_POS_2 DW 400
Y_POS_2 DW 400 
DIRS2 DB 4

AUX_X_2 DW ?
AUX_Y_2 DW ? 
AUX_DIR_2 DB 4

speed2_X DW 5
speed2_Y DW 5

PrevState2 db 0 
CurrentState2 db 0

;CAR DIRECTIONS

Up_and equ 1
Down_and equ 16
Left_and equ 64
Right_and equ 4
Up_Left_and equ 128
Up_Right_and equ 2
Down_Right_and equ 8
Down_Left_and equ 32

START_COLUMN DW ?
IN_PATH DB 0
;VALIDATIONS


;DURATION 
SEC_AUX DB ?
TIME_COUNTER DB 0
GAME_DURATION EQU 120


;POWER UPS


;POWER UPS

;POWERUPS PLAYER1
FoundSpeedUp    db      0
FoundSpeedDown1    db      0

SpeedUp1        DB      0 ;NUMBER OF SPEED UPS FOR PLAYER1
SpeedDown1        DB      0;NUMBER OF SPEED DOWNS FOR PLAYER2

starttimeUP1    DB      0
starttimeDown1    DB      0

UseSpeedUp1     DB      0 ;IF THE SPEED UP IS ON 1
UseSpeedDown1     DB      0; IF THE SPEED DOWN IS ON 1 

counterup1      DB      0
counterDown1      DB      0

Avoid1      db      0 ;GHOST COUNT FOR PLAYER 1
UseAvoid1   db      0

CreationPower1        db      0

;POWERUPS PLAYER 2
FoundSpeedUp2    db      0
FoundSpeedDown2    db      0

SpeedUp2        DB      0 ;NUMBER OF SPEED UPS FOR PLAYER 2
SpeedDown2        DB      0; NUMBER OF SPEED DOWNS FOR PLAYER 2

starttimeUP2    DB      0
starttimeDown2    DB      0

UseSpeedUp2     DB      0 ;IF THE SPEED UP IS ON 2
UseSpeedDown2     DB      0 ;IF THE SPEED DOWN IS ON 2

counterup2      DB      0
counterDown2      DB      0

Avoid2      db      0; GHOST COUNT FOR PLAYER 2
UseAvoid2   db      0

CreationPower2        db      0

;status bar power ups
;greenPowerUp FILE
greenPower_width equ 15
greenPower_height equ 11
greenPower_file_name db '/bin/GPower.bin', 0
greenPower_file_handle dw ?
greenPower_file_size equ greenPower_height * greenPower_width
greenPower_file db greenPower_file_size dup(?)
starting_row dw 450
starting_column dw 600

;---------------------------------------
;red powerup
redPower_width equ 14
redPower_height equ 11
redPower_file_name db '/bin/RPower.bin', 0
redPower_file_size equ redPower_height * redPower_width
redPower_file db redPower_file_size dup(?)
red_powerup_starting_row dw 450
red_powerup_starting_column dw 510

;---------------------------------------
;blue powerup
bluePower_width equ 15
bluePower_height equ 11
bluePower_file_name db '/bin/BPower.bin', 0
bluePower_file_size equ bluePower_height * bluePower_width
bluePower_file db bluePower_file_size dup(?)
blue_powerup_starting_row dw 450
blue_powerup_starting_column dw 570

;---------------------------------------
;evil powerup
evilPower_width equ 12
evilPower_height equ 11
evilPower_file_name db '/bin/EPower.bin', 0
evilPower_file_size equ evilPower_height * evilPower_width
evilPower_file db evilPower_file_size dup(?)
evil_powerup_starting_row dw 450
evil_powerup_starting_column dw 540


;Display players' names
player1_name_text    DB     'player1', '$'
player2_name_text    DB     'player2', '$'
percentage_Text      DB     '0', '$'


WIN_1_TEXT DB 'WINNER IS ', '$'
WIN_2_TEXT DB 'WINNER IS ', '$'
TIE_TEXT DB 'YOU BOTH LOSE', '$'


PLAYER1_WIN DB 0
PLAYER2_WIN DB 0

num dw ?

x DW 0 
y DW 0

color db TrackColor
border_color db 35h
tile_no dw 1 ; 0 = updown, 1 = leftright, 2 = leftdown
;3 = rightdown 4 = downleft 5 = downright
;RANDOM GENERATOR VARS

Threshold db GRID_HEIGHT
RandNum dw ?
carIndex dw ?
;PATH GENERATION VARS

currCount db 0 
currDirection db 1 ;0 = UP, 1 = DOWN, 2 = LEFT, 3 = RIGHT

continueLeft db 0 ;bool
continueRight db 0 ;bool
forceDirectionChange db 0 ;bool

; Array used to mark grid cells as visited
; index as (y * GRID_WIDTH + x)
visited dw (GRID_HEIGHT * GRID_WIDTH) dup (0)

; index to use for marking visited
currIndex dw 0
; for checking if a certain cell is visited or not
probingIndex dw 0

; Arrays used to store the path grid cell coordinates
PathX dw (GRID_HEIGHT * GRID_WIDTH) dup (0)
PathY dw (GRID_HEIGHT * GRID_WIDTH) dup (0)
Path_Tile dw (GRID_HEIGHT * GRID_WIDTH) dup (0)
Path_Length dw 0


Path_Length_aux dw 0 
Path_Length_aux_2 dw 0
Path_Length_dec dw 0


x_probe db 0
y_probe db 0

StartX  dw  0
StartY  dw  0
EndX    dw  0
EndY    dw  0
Prev    dw  0
PrevRow     dw      0
PrevCol     dw      0
PrevIndex     dw      0
CurrRow     dw      0
CurrCol     dw      0



;position of characters
first_player EQU 193
second_player EQU 266
third_player EQU 335
fourth_player EQU 402


;blank names alert
emptyName_width equ 284
emptyName_height equ 25
emptyName_file_size equ emptyName_height * emptyName_width
emptyName_starting_row  EQU 366
emptyName_starting_column EQU 178

;blank names alert
firstCharCheck_width equ 272
firstCharCheck_height equ 25
firstCharCheck_file_size equ emptyName_height * firstCharCheck_width
firstCharCheck_starting_row  EQU 366
firstCharCheck_starting_column EQU 178

;END POINT

AUX_BOOL DB 0
END_END_X DW ?
END_END_Y DW ?
END_START_X DW ?
END_START_Y DW ?