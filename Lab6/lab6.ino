#include "avr/interrupt.h"
#include <avr/io.h>

extern "C"{
  void initSensor();
  void waitOneSecond();
  byte readSensor(byte x);
}
volatile uint8_t intrs;   // global var to count interrupt events

void setup() 
{    
  Serial.begin(9600);    
  initSensor();             // call assembly to initialize the sensor 

//UNCOMMENT FOR INTERRUPT TIMER:

  TCNT1 = 0x0BDB;           // Timer 1 to count from 0x0BDB to 0xFFFF (1s using prescaler 1:256)
  TCCR1A = 0x0;             // Timer 1 Normal Mode
  TCCR1B = 4;               // Timer 1 Select Prescaler 1:256

  TIMSK1 = 1;               // enables interrupt
  sei();                    // enables interrupts AFTER PROLOGE

  while(1){                 // wait for interrupt
    intrs++;
  }

}


void loop() {               //  UNCOMMENT FOR POLLING TIMER
  /*
  byte v;
  v = readSensor(2);        // call assembly to read sensor value, A/D pin #2         
  Serial.print(" light = ");
  Serial.println(v,HEX);

  waitOneSecond();          // Polling
  */
}


ISR(TIMER1_OVF_vect) {       // this ISR is called when TIMER1 overflows 
byte v;
v = readSensor(2);           // call assembly to read sensor value, A/D pin #2         
Serial.print(" light = ");
Serial.println(v,HEX);       // _BV is a macro _BV(5) is same as (1<<5)
} 