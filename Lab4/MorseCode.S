# MorseCode.S
.extern delay

.macro pushall
push r16
push r17
push r18
push r19
push r20
push r21
push r22
push r23
push r24
push r25
push r26
push r27
push r28
push r29
push r30
push r31
.endm ; of pushall

.macro popall
pop r31
pop r30
pop r29
pop r28
pop r27
pop r26
pop r25
pop r24
pop r23
pop r22
pop r21
pop r20
pop r19
pop r18
pop r17
pop r16
.endm ; of popall

#--------------------------------------------------------------------
    .data

# binary representation of Morse code: 0: dot; 1: dash
morse_table: 
    .byte 0b01, 0b1000, 0b1010, 0b100, 0b0, 0b0010, 0b110, 0b0000, 0b00, 0b0111, 0b101, 0b0100, 0b11, 0b10, 0b111, 0b0110, 0b1101, 0b010, 0b000, 0b1, 0b001, 0b0001, 0b011, 0b1011, 0b1100, 0b11111, 0b01111, 0b00111, 0b00011, 0b00001, 0b00000, 0b10000, 0b11000, 0b11100, 0b11110

# the number of binary digits in each character 
morse_width: 
    .byte 2, 4, 4, 3, 1, 4, 3, 4, 2, 4, 3, 4, 2, 2, 3, 4, 4, 3, 3, 1, 3, 4, 3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5

# the English symbols encoded by the above Morse code 
ascii_table: 
    .byte 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
table_length:
    .byte 36

    .comm val, 1
    .comm width, 1
    .comm ascii, 1
    .global val, ascii, width

#---------------------------------------------------------------------

.text
    .global decode_morse

decode_morse:
    pushall
    
    LDI R31, hi8(morse_table) ; initialize high byte of Z
    LDI R30, lo8(morse_table) ; initialize low byte of Z
    
    LDI R29, hi8(ascii_table) ; initialize high byte of Y
    LDI R28, lo8(ascii_table) ; initialize low byte of Y

    LDI R27, hi8(morse_width) ; initialize high byte of X
    LDI R26, lo8(morse_width) ; initialize low byte of X

#---------------------------- Serial ------------------------------

    LDS R21, val     ; val
    LDS R22, width   ; width

    LDI R24, 36      ; Table Length 
                       
    
  CHECK:

    CP    R21, R20               ; If Val == morse_table
    BREQ  CHECK2                 ; Branch to CHECK2 
    RJMP  UP                     ; Jump to UP

    ret

  CHECK2:

    CP    R22, R18               ; If width == morse_width
    BREQ  PRINT                  ; Branch to PRINT
    RJMP  UP                     ; Jump to UP if check failed

    ret

#---------------------------INCREMENT-------------------------------

  UP:
    LD R18, X+                   ;morse_width 2 -> 4
    LD R19, Y+                   ;ascii_table 'A' -> 'B'
    LD R20, Z+                   ;morse_table 0b01 -> 0b1000

    DEC   R24
    CPI   R24, 0                 ; Check table counter
    BREQ  NONE

    RJMP  CHECK                  ; Increment pointers, Restart at CHECK
    ret

#---------------------------NO MATCHES------------------------------

  NONE:

    LDI   R17,   0               ; Output 0 if no matches found
    STS   ascii, R17             ; ascii = 0
    LDI   R24,   36              ; Reset Table Counter
 
    popall
    ret

#--------------------------STORE ASCII-------------------------------

  PRINT:
    LDI R24,   36    ; Reset Table Counter
    STS ascii, R19   ; Store ascii = "A" = 65
    
    popall
    RET
