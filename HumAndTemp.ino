
// initialize the library with the numbers of the interface pins
#include <LiquidCrystal.h>
#include <dht11.h>

//Setup LCD
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

//Setup DHT
dht11 DHT;
//sensor
const int dht11_data = 6;
int temp = 0;
int hum = 0;

void setup()                                                                                     
{

// set up the LCD's number of columns and rows:
  lcd.begin(16,2);
  Serial.begin(9600);
  
  String output = "Hum and Temp...";
  lcd.print(output);
  lcd.setCursor(0,1);  //Display position
}

void loop(){
  // Serial.println(analogRead(A0));
  // delay(2);
  DHT.read(dht11_data);

  temp = DHT.temperature;
  hum = DHT.humidity;

  //print humidity
  lcd.clear();
  lcd.print("Hum=%");
  lcd.print(hum);

  lcd.setCursor(0 , 1);

  //print temp
  lcd.print("Temp=");
  lcd.print(temp);
  lcd.write(0xDF);
  lcd.print("C");

  //Put data into Serial Port
  //float value = map(hum, 0, 100, 200, 400);
  Serial.println(hum);//put humidity on serial first
  Serial.println(temp);
  //Serial.println(temp);//put temp on serial next
  
  
  
  // Serial.print("Temp:");
  // Serial.print(temp);
  // Serial.print("\t"); // print a tab
  // Serial.print("Humidity:");
  // Serial.print(hum);
  // Serial.print("\n");
  
  delay(2);
}


