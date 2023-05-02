#include <string.h>

extern byte val;
extern byte width;
extern byte ascii;
extern byte iterate;

extern "C" { 
  void start1();
  void eureka();
  void decode_morse();

}

//
// function to read a 2-digit decimal value from user
//
byte read2DigitValue()
{
  byte inch; int val;
  Serial.println("Enter a 2-digit decimal value:");
  while (!Serial.available()) delay(100);
  inch = Serial.read();
  val = (inch - '0') * 10;
  while (!Serial.available()) delay(100);
  inch = Serial.read();
  val += (inch - '0');
  Serial.print("The value entered is ");
  Serial.println(val,DEC);
  return (byte) val;
}

void flashEureka() 
{

  iterate = read2DigitValue(); // Number entered in serial
  start1();                    // Load R16 with Serial Input
  eureka();                    // Blink eureka with Serial Input

  Serial.println("Eureka Finished, Decoding Morse...\n");

}

void decodeMorse(const String& string, char message[])
{
  // Write your code below.
  // string contains the input binary string separated by single spaces
  // message contains the decoded English characters and numbers    
  // You will call the assembly function decode_morse()

  // CHECK flashEureka()

  char index;
  val = 0;
  width = 0;
  int x = 0;

  for (int i = 0; i < string.length(); ++i){
    index = string.charAt(i);

    if (index == '0'){
      val *= 2;
      width += 1;
    }

    if (index == '1'){
      val = val * 2 + 1;
      width += 1;
    }

    if (index == ' ' || index == '\0'){

      decode_morse();

      message[x] = ascii;
      x++;

      val = 0;
      width = 0;
    }

    message[x] = '\0';         // clean up garbage


  }
}

void decodeMorse() 
{
  Serial.println("Input a Morse code string (separate the code for characters by a space):\nMUST BE A SPACE AT THE END OF STRING ENTERED\n");

  while (!Serial.available()) delay(100);
  String string = Serial.readString();

  Serial.print("The Morse code string is: ");
  Serial.println(string);

  //string = "1000 100 0"; // "01 1000";
  char message[100];

  decodeMorse(string, message);

  if(strlen(message) > 0) {
    Serial.print("The decoded message is: ");
    Serial.println(message);
  } else {
    Serial.print("Failure in decoding the input Morse code\n");
  }  
}

void setup() {
  //
  // Initialize serial communications
  //
  Serial.begin(9600);

  flashEureka();

  decodeMorse();
  
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(20000); // 20,000 millisecs == 20 seconds
  Serial.println("*");
}
