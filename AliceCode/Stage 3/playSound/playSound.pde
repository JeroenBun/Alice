import com.phidgets.*;
import com.phidgets.event.*;
import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;
AudioPlayer Doorplayer;
AudioPlayer Ambientplayer;
Serial myPort;
phidgetIK ik;


int signal;
String filename;
String position_room = "m";
String size_room = "_small";
String words[]={"01", "02","03","04","05"};
String sensor[]={"27", "28", "31", "32", "38", "39", "43", "44", "47", "48", };
String signalString;
int doorClosed = 0;
int currentSignal;
int previousSignal;
int previouspreviousSignal;

void setup(){  
  
  ik = new phidgetIK();
  ik.waitForAttachment( 1000 );
  ik.setRatiometric( true );
  
  minim = new Minim(this); 
  Doorplayer = minim.loadFile("door_closing.wav");
  Ambientplayer = minim.loadFile("drops_small_visitor.wav");
  size(400,400);
  myPort = new Serial (this, Serial.list () [0], 9600);
  background(0,0);
  playAmbient();
  
  
}

void draw() {
  byte i;
 if(myPort.available() > 0){
 signal = myPort.read();
 signalString = str(signal);
 currentSignal = signal;
 
// println(signal);
 
 if(doorClosed == 0 && (signal == 50 || signal == 51 || signal == 46 || signal == 47)){
   doorClosed = 1;
   closeDoor();
 }
 
 for(int j = 0; j<sensor.length;j++){
   if(sensor[j].contains(signalString)){
     position_room = "m";}
   else{position_room = "s";}}
   
 int index = int(random(words.length));
 filename = position_room + words[index] + size_room +".wav";
// println(filename);   
   player = minim.loadFile(filename);
//   println("play sound");
   if ((currentSignal != previousSignal) && (currentSignal != previouspreviousSignal)){
     player.rewind();
     player.play();
//     println("currentstate="+currentSignal);
//     println("previousstate="+previousSignal);
//     println("previouspreviousstate="+previouspreviousSignal);
     previouspreviousSignal = previousSignal;
     previousSignal = currentSignal;
   }
     
 }
}

void playAmbient(){
  Ambientplayer.setGain(-45);
  Ambientplayer.loop();
}

void closeDoor(){
  println("Door closing");
  ik.setOutputState(3, false);
  delay(500);
  ik.setOutputState(3, true);
  Doorplayer.rewind();
  Doorplayer.play();
  delay(500);
  ik.setOutputState(3, false);
  println("Entrance is closing");
  ik.setOutputState(7, false);
  delay(500);
  ik.setOutputState(7, true);
  println("Entrance is closed");
  
  delay(6000);
  
  ik.setOutputState(1, false);
  delay(500);
  ik.setOutputState(1, true);
  println("Door is closed");
  delay(500);
  ik.setOutputState(1, false);
  ik.setOutputState(7, false);
  Ambientplayer.shiftGain(-45, -30, 3000);
}
