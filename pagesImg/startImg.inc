;SECOND FILE
owl_width equ 117
owl_height equ 167
owl_file_name db '/bin/owl.bin', 0
owl_file_size equ owl_height * owl_width

;HeroText FILE
hey_width equ 438
hey_height equ 45
hey_file_name db '/bin/Hey.bin', 0
hey_file_size equ hey_height * hey_width

;Start FILE
startBtn_width equ 98
startBtn_height equ 18
startBtn_file_name db '/bin/Start.bin', 0
startBtn_file_size equ startBtn_height * startBtn_width

;Exit FILE
exitBtn_width equ 70
exitBtn_height equ 16
exitBtn_file_name db '/bin/Exit.bin', 0
exitBtn_file_size equ exitBtn_height * exitBtn_width

;Player1 Name TEXT

player1_width equ 179
player1_height equ 15
player1_file_name db '/bin/P1name.bin'
player1_file_size equ player1_height * player1_width 

;Player2 Name TEXT

player2_width equ 179
player2_height equ 15
player2_file_name db '/bin/P2name.bin'
player2_file_size equ player1_height * player1_width 

;SCORE TEXT

score_width equ 74
score_height equ 11
score_file_name db '/bin/score.bin'
score_file_size equ player1_height * player1_width 