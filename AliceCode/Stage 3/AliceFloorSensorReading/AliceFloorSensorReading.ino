// Origonal code from adafruit.com. Adapted by Geert van den Boomen for use in the Alice Installation. 
// More specific; for use in the cave reading 28 floor sensors.
// These sensors operate as switches.
// The result of the reading is send to the serial port

#define DEBOUNCE 10  // button debouncer, how many ms to debounce, 5+ ms is usually plenty

int triggerSound = 1; 
int timerFinished = 1;
int prevtime;
int wait = 1000;

// here is where we define the buttons that we'll use. button "1" is the first, button "6" is the 6th, etc
byte buttons[] = {6, 7, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 34, 36, 38, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, }; // the analog 0-5 pins are also known as 14-19
// This handy macro lets us determine how big the array up above is, by checking the size
#define NUMBUTTONS sizeof(buttons)
// we will track if a button is just pressed, just released, or 'currently pressed' 
volatile byte pressed[NUMBUTTONS], justpressed[NUMBUTTONS], justreleased[NUMBUTTONS];

void setup() {
  byte i;
  
  // set up serial port
  Serial.begin(9600);
//  Serial.print("Button checker with ");
//  Serial.print(NUMBUTTONS, DEC);
//  Serial.println(" buttons");

  // pin13 LED
  pinMode(13, OUTPUT);
 
  // Make input & enable pull-up resistors on switch pins
  for (i=0; i< NUMBUTTONS; i++) {
    pinMode(buttons[i], INPUT);
    digitalWrite(buttons[i], HIGH);
  }

  // Run timer2 interrupt every 15 ms 
  TCCR2A = 0;
  TCCR2B = 1<<CS22 | 1<<CS21 | 1<<CS20;

  //Timer2 Overflow Interrupt Enable
  TIMSK2 |= 1<<TOIE2;

}
// on timer overflow run this code.
SIGNAL(TIMER2_OVF_vect) {
  check_switches();
}

void check_switches()
{
  static byte previousstate[NUMBUTTONS];
  static byte currentstate[NUMBUTTONS];
  static long lasttime;
  byte index;

//  Serial.println(millis());

  if (millis() < lasttime) {
     // we wrapped around, lets just try again
     lasttime = millis();
  }
  
  if ((lasttime + DEBOUNCE) > millis()) {
    // not enough time has passed to debounce
    return; 
  }
  // ok we have waited DEBOUNCE milliseconds, lets reset the timer
  lasttime = millis();
  
  for (index = 0; index < NUMBUTTONS; index++) {
     
    currentstate[index] = digitalRead(buttons[index]);   // read the button
    
    /*     
    Serial.print(index, DEC);
    Serial.print(": cstate=");
    Serial.print(currentstate[index], DEC);
    Serial.print(", pstate=");
    Serial.print(previousstate[index], DEC);
    Serial.print(", press=");
    */
    
    if (currentstate[index] == previousstate[index]) {
      if ((pressed[index] == LOW) && (currentstate[index] == LOW) && (timerFinished == 1)) {
//          Serial.print("call timer");
          timerFinished = 0;
          prevtime = millis();
          int sum = prevtime + wait;
//          Serial.println(sum);
//          Serial.println(millis());
          justpressed[index] = 1;
      }
      }
      else if ((pressed[index] == HIGH) && (currentstate[index] == HIGH)) {
          // just released
          justreleased[index] = 1;
      }
      pressed[index] = !currentstate[index];  // remember, digital HIGH means NOT pressed
    }
    //Serial.println(pressed[index], DEC);
    previousstate[index] = currentstate[index];   // keep a running tally of the buttons
  }

  

void loop() {
  for (byte i = 0; i < NUMBUTTONS; i++) {
    if (justpressed[i]) {
      justpressed[i] = 0;
      Serial.write(buttons[i]);
     //Serial.print(i , DEC);
//      Serial.print("FloorSensor ");
//      Serial.print(i+1, DEC);  // i starts at zero, but sensors are numbered 1...28
//      Serial.print(" Just pressed"); 
//      Serial.print(" (ArduinoInput "); // handy to have the connected input next to it
//      Serial.print(buttons[i]);
//      Serial.println(")"); // just print the final )
      // remember, check_switches() will CLEAR the 'just pressed' flag
    }
    if (justreleased[i]) {
      justreleased[i] = 0;
//      Serial.print(i, DEC);
//      Serial.println(" Just released");
      // remember, check_switches() will CLEAR the 'just pressed' flag
    }
    if (pressed[i]) {
//      Serial.print(i, DEC);
//      Serial.println(" pressed");
      // is the button pressed down at this moment
    }
  }
  
  if (timerFinished == 0){
    if ((prevtime + wait) < millis()){
//            Serial.print("Timer has finished");
            timerFinished = 1;
          }
  }
}

