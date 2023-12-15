;Ward FILE
ward_width equ 71
ward_height equ 66
ward_file_name db '/bin/ward.bin', 0
ward_file_size equ ward_height * ward_width

;Samer FILE
samer_width equ 65
samer_height equ 59
samer_file_name db '/bin/samer.bin', 0
samer_file_size equ samer_height * samer_width

;mays FILE
mays_width equ 60
mays_height equ 58
mays_file_name db '/bin/mays.bin', 0
mays_file_size equ mays_height * mays_width

;bassam FILE
bassam_width equ 65
bassam_height equ 62
bassam_file_name db '/bin/bassam.bin', 0
bassam_file_size equ bassam_height * bassam_width

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


