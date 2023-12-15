;Logo
logo_width equ 140
logo_height equ 42
logo_name db './bin/LogoS.bin', 0
logo_size equ logo_height * logo_width
logo db logo_size dup(?)
