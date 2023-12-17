x DW 0 
y DW 0

color db 8


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
; index as (y * GRID_WIDTH + x)
visited dw (GRID_HEIGHT * GRID_WIDTH) dup (0)

; index to use for marking visited
currIndex dw 0
; for checking if a certain cell is visited or not
probingIndex dw 0

; Arrays used to store the path grid cell coordinates
PathX dw (GRID_HEIGHT * GRID_WIDTH) dup (0)
PathY dw (GRID_HEIGHT * GRID_WIDTH) dup (0)
Path_Length dw 0


x_probe db 0
y_probe db 0

StartX  dw  0
StartY  dw  0
EndX    dw  0
EndY    dw  0
Prev    dw  0
PrevRow     dw      0
PrevCol     dw      0
CurrRow     dw      0
CurrCol     dw      0
