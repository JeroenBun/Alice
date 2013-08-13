// phidgetIK -phidget interface kit object


// phidgetIK
//
// Constructors
//
//  phidgetIK() - open with first available phidget IK
//
//  phidgetIK( int serial ) - open phidget with given serial number
//
//
// Methods
//
//  void close() - close the phidget IK
//
//  boolean isAttached() - returns true if IK is attached
//
//  void waitForAttachment( int timeout ) - wait for IK to attach with timeout in miliseconds
//
//  void waitForAttachment( ) - wait indefinitely for IK to attach
//
//  int serial() - return serial number of IK if attached, 0 otherwise
//
//  int version() - return IK revision no if attached, 0 otherwise
//
//  void setRatiometric( boolean state ) - set ratiometric mode for IK
//
//  int getSensorCount() - returns number of A/D convertors (sensor channels) available
//
//  int getSensorValue( int index ) - returns sensor value for A/D convertor coresponding to index
//
//  int getInputCount() - returns number of digital inputs available
//
//  boolean getInputState( int index ) - returns state of digital input coresponding to index
//
//  int getOutputCount() - returns number of digital outputs available
//
//  void setOutputState( int index, boolean state ) - sets state of digital output coresponding to index
//



import com.phidgets.*;
import com.phidgets.event.*;


class phidgetIK {
  InterfaceKitPhidget ik;
  
  
  // constructors
  // open first available interface kit
  phidgetIK() {
    try {
      ik = new InterfaceKitPhidget();
      ik.openAny();
    }
    catch(Exception e) {}
  }
  
  // open interface kit for given serial number
  phidgetIK( int serial ) {
    try {
      ik = new InterfaceKitPhidget();
      ik.open( serial );
    }
    catch(Exception e) {}
  }
  
  // close the ik
  void close() {
    try {
      ik.close();
    }
    catch(Exception e) {}
  }
  
  // check if interface kit is attached
  boolean isAttached() {
    boolean result;
    
    try {
      result = ik.isAttached();
    }
    catch(Exception e) {
      result = false;
    }
    return result;
  }
  
  // wait for phidget to attach - with time out
  void waitForAttachment( int timeout ) {
    try {
      ik.waitForAttachment(timeout);
    }
    catch( Exception e) {
    }
  }
  
  
  // sait for phidget to attach - indefinitely
  void waitForAttachment( ) {
    try {
      ik.waitForAttachment();
    }
    catch( Exception e) {
    }
  }
  

  // get serial number of attached phidget, return -1 if not attached
  int serial() {
    int s;
    
    try {
      s = ik.getSerialNumber();
    }
    catch( Exception e ) {
      s = -1;
    }
    return s;
  }
  
  // get device version
  int version() {
    int v;
    
    try {
      v = ik.getDeviceVersion();
    }
    catch( Exception e ) {
      v = -1;
    }
    return v;
  }
  
  // set/reset ratiometric mode
  void setRatiometric( boolean state ) {
    try {
      ik.setRatiometric(state);
    }
    catch( Exception e ) {
    }
  }
  
  
  // get numaber of analog sensors
  int getSensorCount() {
    int count;
    try {
      count = ik.getSensorCount( );
      return count;
    }
    catch( Exception e ) {
      return 0;
    }
  }
  
  // get value for analog sensor
  int getSensorValue( int index ) {
    int v;
    try {
      v = ik.getSensorValue( index );
      return v;
    }
    catch( Exception e ) {
      return 0;
    }
  }
  
  // get the number of digital inputs
  int getInputCount() {
    int count;
    try {
      count = ik.getInputCount( );
      return count;
    }
    catch( Exception e ) {
      return 0;
    }
  }


  
  // get digital input
  boolean getInputState( int index ) {
    boolean state;
    try {
      state = ik.getInputState( index );
      return state;
    }
    catch( Exception e ) {
      return false;
    }
  }

  
  // get the number of digital outputs
  int getOutputCount() {
    int count;
    try {
      count = ik.getOutputCount( );
      return count;
    }
    catch( Exception e ) {
      return 0;
    }
  }


  
  // set digital outputs
  void setOutputState( int index, boolean state ) {
    try {
      ik.setOutputState( index, state );
    }
    catch( Exception e ) {
    }
  }


}


