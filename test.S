    .file "test.S"
    .text
    .global testf


testf:
      ldi    r17,  0xFF
      out    0x04, r17   ;on

      LDI    R21, 1
      LDI    R20,  50
      STS    0x340, R20

      LDI    ZH,  hi8(0x340 << 1)
      LDI    ZL,  lo8(0x340 << 1)

      LPM    R21, Z
      CPI    R21, 50
      BREQ   end

      
      
      ldi r17, 0xFF
      out 0x05, r17

      end:
      ret