#include "secrets.h"
#include <ESP8266WiFi.h>

#define SERIAL_BAUD 115200 // make sure this is the same in arduino.ino
const char *network = SSID;
const char *password = PASS;
String serialData = "";

void setup(void)
{
	Serial.begin(SERIAL_BAUD);
	WiFi.begin(network, password);
  Serial.print("...\n");
	while (WiFi.status() != WL_CONNECTED)
	{
		delay(500);
		Serial.print("...\n");
	}

	for (int i = 0; i < 2; i++)
	{
    Serial.print("Connected!\n");
		digitalWrite(LED_BUILTIN, HIGH);
		delay(1000);
		digitalWrite(LED_BUILTIN, LOW);
		delay(1000);
	}
}

void loop(void)
{
  while (Serial.available())
  {
    char x = Serial.read();
    if (x == '\r')
      continue;
    serialData += x;
  }
  int k = analogRead(0);
  Serial.print("Received: ");
   Serial.println(k);
    delay(1000);
}
