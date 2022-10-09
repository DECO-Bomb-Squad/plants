#define SERIAL_BAUD 115200

/*******************************************
	In this code we have used "[]" to surround our command codes
	As a bit of a proof of concept for how to use the XC4411 board
*********************************************/
const int sensor_pin = 0;

String receivedCommand = "";
bool dataIn = false;
int result = 0;
String serialData = "";

void setup()
{
	// put your setup code here, to run once:

	Serial.begin(SERIAL_BAUD); // same as ESP baud
}

void loop()
{
	while (Serial.available())
	{ 
    char x = Serial.read();
    if (x == '\r')
      continue;
    serialData += x;
		result = analogRead(sensor_pin);
   result = map(result, 0, 400, 0, 100);
   Serial.println(result);
	}
 
 
	delay(1000);
}
