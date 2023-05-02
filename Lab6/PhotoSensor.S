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


.equ ADCH,   0x79
.equ ADCSRA, 0x7A
.equ ADMUX,  0x7C
.equ DIDR0,  0x7E

.equ TIFR1,  0x16  ; IO address
.equ TCCR1A, 0x80  ; Memory addresses:
.equ TCCR1B, 0x81
.equ TCNT1H, 0x85
.equ TCNT1L, 0x84

.data
.text

.global initSensor
.global waitOneSecond
.global readSensor


################################## Init ######################################
initSensor:
  LDI  R18, 0b00111111
  STS  DIDR0, R18     ; Set DIDR0

  LDI  R20, 0b10000111
  STS  ADCSRA, R20    ; Set ADCSRA

ret

################################## Conversion ################################

readSensor:
  LDI  R18, 0b01100000 ; MUX NOT SET YET 
  MOV  R19, R24        ; Load R19 with input pin
  OR   R18, R19        ; Add MUX
  STS  ADMUX, R18      ; Set REFS1-REFS0, ADLAR, and MUX

  LDS  R18, ADCSRA     ; Load ADCSRA
  LDI  R19, 0b01000000 ; Start Conversion
  OR   R18, R19        ; Add Conversion Bit
  STS  ADCSRA, R18     

  RJMP CheckADSC
ret


CheckADSC:
  LDS  R18, ADCSRA     ; Load ADCSRA
  SBRC R18, 6          ; Skip if bit 6 cleared on ADCSRA
  RJMP CheckADSC       ; Loop

  LDS  R24, ADCH       ; Load result
  CLR  R25             ; Clear 

ret

################################## Delay (POLLING) #####################################

waitOneSecond:
#pushall
  LDI  R20, 0x0B       ; Initialize Timer -- 1 s/16 μs = 62,500 cycles using scaler 256 -- 0x0BDB == 1s
  STS  TCNT1H, R20     ; Load Timer1 High
  LDI  R20, 0xDB       ; Load Low
  STS  TCNT1L, R20     ; Load Timer1 Low

  LDI  R20, 0x00
  STS  TCCR1A, R20     ; Normal Mode

  LDI  R20, 4          ; 256 Prescaler
  STS  TCCR1B, R20     ; Internal Clock

  CALL Loop            ; Loop

#popall
ret

Loop:
  IN   R20, TIFR1      ; Read TIFR1
  SBRS R20, 0          ; Check TOV1
  RJMP Loop            ; Loop

  LDI  R20, 0x00
  STS  TCCR1B, R20     ; Stop Timer1

  LDI  R20, 1          ; TOV1
  OUT  TIFR1, R20      ; Clear TOV1
  
ret

################################## Delay (INTERRUPT) NOT IMPLEMENTED ##################################### 
#TIMER1_OVF_vect: