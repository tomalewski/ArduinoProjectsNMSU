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

;;  AVR code to do the function of the 4 x 7 segment display of Lab 5
;;
;;
;;    Shaun Cooper
;;    CS 273
;;    Semester XXXX , 20XX
;;    Modified by Dr. Joe Song and Sajal Kumar
;;
;;  The basic algorithm is to have the main loop
;;  set some shared variable values
;;  we then use simulataneous arrays (vectors)
;;  to figure out which digit among the 4 segments is desired 
;;  and which number is to be displayed
;;
;;  Since our setup utilizes PORTD and PORTB, we need to maintain
;;  simulataneous vectors for all of the digits/numbers that are neededed
;;
;; main routine does
;;   setup_ports once
;; 
;;   C code to do the following

;;   digit=1
;;   number=9
;;   show_number();; will display 9 on digit 1, for example
;;  
  .data
  .size digit_table, 4
  .size portb_table, 10
  .size portd_table, 10
  
########################### TABLES ##############################

digit_table:  #binary for setting input on PORTB for digit select
    .byte 0b00011100, 0b00011010, 0b00010110, 0b00001110
    
    ;     9           10          11          12
portb_table:  # list of binary numbers for setting port B to be ORed with portd_table
    .byte 0,  0,  1,  1,  1,  1,  1,  0,  1,  1
    
    ;     0   1   2   3   4   5   6   7   8   9
portd_table: # list of binary numbers for setting port D.
    .byte  0b11111100, 0b00011000, 0b01101100, 0b00111100, 0b10011000, 0b10110100, 0b11110000, 0b00011100, 0b11111100, 0b10011100

    ;      0           1           2           3           4           5           6           7           8           9

  
  .comm digit, 1 ;; the common name for digit
  .comm number, 1 ;; the common name for number
  .global number, digit


# --------
  .text
  .global setup_ports
  .global show_number
  .global select_digit

################################ SETUP PORTS #########################################

setup_ports:  ;; routine to set the ports into output mode
  LDI  R16,  0xFF  ; Direction = output
  OUT  0x04, R16   ; PortB
  OUT  0x0A, R16   ; PortD

ret 

############################### SELECT DIGIT ########################################

select_digit:                ; routine to select the correct digit among the four segments
  LDS  R16, digit            ; use "digit" to find the values that need to be sent to PORTB.
  LDI  R30, lo8(digit_table)
  LDI  R31, hi8(digit_table)

Loop:
  LD   R17, Z+     ; Load R17 with digit_table
  CPI  R16, 0      ; Check position
  BREQ End         ; FOUND
  SUBI R16, 1      ; Count down from position
  RJMP Loop        ; Loop
  ret

End:
  OUT  0x05, R17   ; PortB
  ret
ret

################################## Driver Code ####################################
show_number:            
pushall               
  CALL select_digit     ; call select_digit to choose the correct "digit" on the segment
  LDS  R16, number      ; use "number" to find the values that need to be sent to PORTB & PORTD.

  LDI  R26, lo8(portb_table) ; Register X = portB_table
  LDI  R27, hi8(portb_table) ; high
  LDI  R28, lo8(portd_table) ; Register Y = portD_table
  LDI  R29, hi8(portd_table) ; high


Start:
  LD   R17, X+ ; Load R17 with portB_table
  LD   R18, Y+ ; Load R18 with portD_table

  CPI  R16, 0  ; Check position
  BREQ OUTPUT  ; Continue
  SUBI R16, 1  ; Count down from position
  RJMP Start   ; Loop
ret

OUTPUT:
  CPI  R17, 1      ; check portB_table
  BREQ CROSSBAR    ; output with crossbar
  OUT  0x0B,R18    ; output without crossbar
  popall
ret

CROSSBAR:          ; normal output with crossbar high
  SBI  0x05,0      ; set PortB0
  OUT  0x0B,R18
  popall
ret