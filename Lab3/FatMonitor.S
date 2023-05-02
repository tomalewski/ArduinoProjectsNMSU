################### Import globals from C File:
    .data
    .comm gender, 1
    .global gender
    .comm age, 1
    .global age
    .comm fat, 1
    .global fat

    .extern delay
    
    .text
    .global registers
    .global branch
    
#################### C File Runs these blocks first:

registers:
    lds r18, gender
    lds r19, age
    lds r20, fat
    ret
    
branch:
    cpi r18, 0x0A
    breq malebranch

    cpi r18, 0x0F
    breq femalebranch

    ret

######################GENDER#########################
malebranch:
    cpi r19, 40
    brlo maleYoung

    cpi r19, 60
    brlo maleOld

    cpi r19, 80
    brlo maleOlder
    
    ret 

femalebranch:
    cpi r19, 40
    brlo femaleYoung

    cpi r19, 60
    brlo femaleOld

    cpi r19, 80
    brlo femaleOlder
    
    ret
    
####################AGE CHECKS########################
maleYoung:
    cpi  r20, 25 ;compare immediate
    brsh bridge1 ;use bridge for far instructions

    cpi  r20, 20
    brsh bridge2 ;use bridge for far instructions
    
    cpi  r20, 8
    brsh bridge3 ;use bridge for far instructions

    cpi  r20, 8
    brlo low 

ret
maleOld:
    cpi  r20, 28
    brsh bridge1 ;use bridge for far instructions

    cpi  r20, 22
    brsh bridge2 ;use bridge for far instructions
    
    cpi  r20, 11
    brsh normal 

    cpi  r20, 11
    brlo low 

ret
maleOlder:
    cpi  r20, 30
    brsh bridge1 ;use bridge for far instructions

    cpi  r20, 25
    brsh high
    
    cpi  r20, 13
    brsh normal 

    cpi  r20, 13
    brlo low 

ret
################Bridge
bridge1:         
    jmp  lightup
    ret
bridge2:
    jmp  high
    ret
bridge3:
    jmp  normal
    ret
######################################
femaleYoung:
    cpi  r20, 39
    brsh lightup

    cpi  r20, 33
    brsh high
    
    cpi  r20, 21
    brsh normal 

    cpi  r20, 21
    brlo low  

ret
femaleOld:
    cpi  r20, 40
    brsh lightup

    cpi  r20, 34
    brsh high
    
    cpi  r20, 23
    brsh normal 

    cpi  r20, 23
    brlo low  

ret
femaleOlder:
    cpi  r20, 42
    brsh lightup

    cpi  r20, 36
    brsh high
    
    cpi  r20, 24
    brsh normal 

    cpi  r20, 24
    brlo low  

ret
####################LIGHTS#########################

low:                    ;red light
    ldi  r17, 0b00100000
    jmp  wait
  
    ret
    
normal:                 ;green light
    ldi  r17, 0b00010000
    jmp  wait

    ret
    
high:                   ;blue light
    ldi  r17, 0b00000001
    jmp  wait
    
    ret
    
lightup:

    ldi  r17, 0b00110001                         ;All lights stay on
    out  0x04, r17  ;0x04 is I/O address of DDRB
    out  0x05, r17  ;0x05 is I/O address of PORTB
    ret
###############Blink##########################
wait:
      #ldi    r17, 0b00110001  ; Light color
      out    0x04, r17
      ldi    r16, 50
      #ldi    r17, 0b00110001  ; Light Color
all:  out    0x05, r17
      ldi    r18, 0xff
dl1:  ldi    r19, 0xff
dl2:  nop
      nop
      nop
      nop
      dec    r19
      brne   dl2
      dec    r18
      brne   dl1
      ldi    r20, 0x00
      out    0x05, r20
      ldi    r18, 0xff
dl3:  ldi    r19, 0xff
dl4:  nop
      nop
      nop
      nop
      dec    r19
      brne   dl4
      dec    r18
      brne   dl3
      dec    r16
      brne   all
      ret
