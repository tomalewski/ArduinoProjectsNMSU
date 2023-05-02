# Eureka.S
.extern delay

.data
    .comm iterate, 1

.text
    .global eureka
    .global iterate
    .global start1


.EQU  DDRB, 0x04
.EQU  PORTB, 0x05

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

###########################################################



start1:
    LDS  R16, iterate
    ret

eureka: 
    
    call longDelay  ; wait 7 units
    call longDelay
    call shortDelay ; 1 unit

    E:
    call shortBlink ; 1 unit

    call longDelay  ; 3 units

    U:
    call shortBlink 
    call shortBlink
    call longBlink  ; 3 units

    call longDelay

    R:
    call shortBlink
    call longBlink
    call shortBlink

    call longDelay

    #E:
    call shortBlink

    call longDelay

    K:
    call longBlink
    call shortBlink
    call longBlink

    call longDelay

    A:
    call shortBlink
    call longBlink

    call longDelay


    DEC  R16      ; keep repeating until R16 == 0
    BRNE eureka
ret


    ############### LED ################

    lightOn:
    LDI  R18, 0xFF
    OUT  DDRB, R18
    LDI  R18, 0xFF
    OUT  PORTB, R18
    

    ret

    lightOff:
    LDI  R18, 0xFF
    OUT  DDRB, R18
    LDI  R18, 0x00
    OUT  PORTB, R18


    ret

    ############### Blinks ################

    shortBlink:
    call  lightOn
    call  shortDelay
    call  lightOff
    call  shortDelay

    ret

    longBlink:
    call  lightOn
    call  longDelay
    call  lightOff
    call  shortDelay

    ret

    ############### Delays ################

    shortDelay:    ; 1 unit
    pushall
    LDI  R22, 0xFA ; 250 Miliseconds
    LDI  R23, 0x00
    LDI  R24, 0x00
    LDI  R25, 0x00

    call delay
    popall

    ret

    longDelay:     ; 3 units
    pushall
    LDI  R22, 0xEE ; 750 Miliseconds
    LDI  R23, 0x02
    LDI  R24, 0x00
    LDI  R25, 0x00

    call delay
    popall

    ret
    