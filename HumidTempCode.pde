import processing.serial.*;

Serial myPort;

//Set Starting Values 
int xPos = 1;
float humIn = 0;
float tempIn = 0;
float trueVal = 0;
boolean doHumid = true; //grab the humidity first

//Set Humidity Coordinates
int humX = xPos;
float humY = height/4;

//Set Temperature Coordinates
int tempX = xPos;
float tempY = height/2 + height/4; // get to the upper 'quarter'

void setup() {
  size(400, 400);
  background(0);
  
  myPort = new Serial(this, Serial.list()[1], 9600); //myPort now "contains" COM3 
  myPort.bufferUntil('\n'); //wait until we get new data

  drawLabels();
}

void draw() {
  //Draw the graph lines
  stroke(255, 0, 0);
  line(humX, humY, xPos, height - humIn); //humid line
  line(tempX, tempY, xPos, height - tempIn); //temp line

  humX = xPos; //update the 'last' position
  tempX = xPos;

  //Update the corresponding Y-axis value based
  //on the current Serial-in value
  if (doHumid){
    humY = height - humIn;
    
    //Update the display value
    fill(0);
    stroke(0);
    rect(width/2, height - 25,  width/8, height/16);
    fill(255, 0, 0);
    text(trueVal, width/2, height - 10);
    fill(255);
  }else{
    tempY = height - tempIn;
    
    //update the display value
    fill(0);
    stroke(0);
    rect(width/2, height/2 - 20,  width/8, height/32);
    fill(255, 0, 0);
    text(trueVal, width/2, height/2 - 10);
    fill(255);
  }
  
  if (xPos >= width) { //The graph has gone off the side!
    xPos = 0;
    humX = xPos;//reset the x positions
    tempX = xPos;
    background(0);
    
    drawLabels();
  } else 
    xPos++;
}

//Called when the Serial port is updated
void serialEvent(Serial myPort) {
  String inVal = myPort.readStringUntil('\n');//read the value
  trueVal = float(inVal);

  if (inVal != null) {
    
    // Put inVal into the correct variable
    if (doHumid) {
      humIn = float(inVal);
      humIn = map(humIn, 0, 100, height/2, height); //map to humid specifications
      doHumid = false;
    } else {
      tempIn = float(inVal);
      tempIn = int(map(tempIn, -40, 40, 0, height/2)); //map to temp specifications
      doHumid = true;
    }
    
    //Print values to console
    print("Humid: ");
    print(humIn);
    print("  Temp:  ");
    println(tempIn);
  }
}

/*
// drawLabels
//  - Called when the humidity and temperature
//    graph labels must be set
*/
void drawLabels() {
  textSize(13);
  fill(255);
  text("Humidity (0 - 100): ", 10, height/2 - 10);
  text("Temperature (-40 - +40): ", 10, height - 10);
  
  //Humid Value Points
  int humHalf = height/2 - height/4;
  text("50%", width - 25, humHalf);
  text("75%", width - 25, humHalf - height/8);
  text("25%", width - 25, humHalf + height/8);
  
  //Temp Value Points
  int tempHalf = height/2 + height/4;
  text("0", width - 20, tempHalf);
  text("20", width - 20, tempHalf - height/8);
  text("-20", width - 25, tempHalf + height/8);
 
  //Draw a dividing line
  stroke(255);
  line(0, height/2, width, height/2);
}