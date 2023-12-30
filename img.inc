;Logo
logo_width equ 140
logo_height equ 42
logo_name db './bin/LogoS.bin', 0
logo_size equ logo_height * logo_width
logo db logo_size dup(?)


;position of characters
owl_current_row DW 193

first_player EQU 193
second_player EQU 266
third_player EQU 335
fourth_player EQU 402


player1_character DB 1
player2_character DB 1


player1_name db 10, ?, 30 dup('$')
player2_name db 10, ?, 30 dup('$') 


;blank names alert
emptyName_width equ 284
emptyName_height equ 25
emptyName_file_name db '/bin/EmpName.bin', 0
emptyName_file_size equ emptyName_height * emptyName_width
emptyName_file db emptyName_file_size dup(?)
emptyName_starting_row  EQU 366
emptyName_starting_column EQU 178

;blank names alert
firstCharCheck_width equ 272
firstCharCheck_height equ 25
firstCharCheck_file_name db '/bin/chCheck.bin', 0
firstCharCheck_file_size equ emptyName_height * firstCharCheck_width
firstCharCheck_file db emptyName_file_size dup(?)
firstCharCheck_starting_row  EQU 366
firstCharCheck_starting_column EQU 178

;validate names
; Define constants for character ranges
UPPERCASE_MIN_ASCII EQU 65
UPPERCASE_MAX_ASCII EQU 90
LOWERCASE_MIN_ASCII EQU 97
LOWERCASE_MAX_ASCII EQU 122

;list of invalid characters

invalid_char_msg DB 'Names must begin with a letter', '$'
empty_name_msg DB 'Nameless riders get left behind! Pick one fast.', '$'
invalidName_flag DB 0



;Ward FILE
ward_width equ 71
ward_height equ 66
ward_file_name db '/bin/ward.bin', 0
ward_file_size equ ward_height * ward_width
ward_starting_row DW 170
ward_starting_column DW 160


;Samer FILE
samer_width equ 65
samer_height equ 59
samer_file_name db '/bin/samer.bin', 0
samer_file_size equ samer_height * samer_width
samer_starting_row DW 250
samer_starting_column DW 168

;mays FILE
mays_width equ 60
mays_height equ 58
mays_file_name db '/bin/mays.bin', 0
mays_file_size equ mays_height * mays_width
mays_starting_row DW 321
mays_starting_column DW 168

;bassam FILE
bassam_width equ 65
bassam_height equ 62
bassam_file_name db '/bin/bassam.bin', 0
bassam_file_size equ bassam_height * bassam_width
bassam_starting_row DW 387
bassam_starting_column DW 168

;choose character FILE
choose_width equ 272
choose_height equ 47
choose_file_name db '/bin/Choose.bin', 0
choose_file_size equ choose_height * choose_width

;Flame kaiser FILE
FK_width equ 132
FK_height equ 10
FK_file_name db '/bin/FKTxt.bin', 0
FK_file_size equ FK_height * FK_width

;Bloody Fang FILE
BF_width equ 109
BF_height equ 10
BF_file_name db '/bin/BFTxt.bin', 0
BF_file_size equ BF_height * BF_width

;Neptune FILE
Nep_width equ 69
Nep_height equ 10
Nep_file_name db '/bin/NepTxt.bin', 0
Nep_file_size equ Nep_height * Nep_width

;Thunder Emperor FILE
Thun_width equ 148
Thun_height equ 10
Thun_file_name db '/bin/ThunTxt.bin', 0
Thun_file_size equ Thun_height * Thun_width

;selected character
owlS_width equ 26
owlS_height equ 37
owlS_file_name db '/bin/owlS.bin', 0
owlS_file_size equ owlS_height * owlS_width
owlS_file db owlS_file_size dup(?)


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

;Start FILE
chatBtn_width equ 78
chatBtn_height equ 18
chatBtn_file_name db '/bin/chat.bin', 0
chatBtn_file_size equ chatBtn_height * chatBtn_width

;Exit FILE
exitBtn_width equ 70
exitBtn_height equ 16
exitBtn_file_name db '/bin/Exit.bin', 0
exitBtn_file_size equ exitBtn_height * exitBtn_width

;Player1 Name TEXT

player1_width equ 179
player1_height equ 15
player1_file_name db '/bin/P1name.bin', 0
player1_file_size equ player1_height * player1_width 

;Player2 Name TEXT

player2_width equ 179
player2_height equ 15
player2_file_name db '/bin/P2name.bin', 0
player2_file_size equ player1_height * player1_width 


