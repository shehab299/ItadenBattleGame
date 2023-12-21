openFile PROC FAR ;DX => FILE_NAME_OFFSET  ;DI => FILE_HANDLE_OFFSET

    mov ah,03Dh ;Open File and Get File Handle
    mov al,0
    INT 21h

    MOV [DI],AX

    RET
    
openFile ENDP ;BX

ReadFileToMemory PROC FAR ;CX => BUFFER_SIZE ;DX => FILE_OFFSET ;BX=> FILE_HANDLE

    mov ah,03Fh       ;Read File To Memory
    INT 21h

    mov ah, 3Eh       ; DOS function: close file
    INT 21H

    RET    
ReadFileToMemory ENDP

