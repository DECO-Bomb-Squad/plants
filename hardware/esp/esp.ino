#include "secrets.h"
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

#define SERIAL_BAUD 115200 // make sure this is the same in arduino.ino
const char *network = SSID;
const char *password = PASS;
String serialData = "";
String baseUrl = "peclarke.pythonanywhere.com";
String water = "/activity" String notification = "/send_plant_notification" bool previouslyDry = true

	void
	setup(void)
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
	/* while (Serial.available()) {
		char x = Serial.read();
		if (x == '\r')
		continue;
		serialData += x;
	} */
	int rawMoistureData = analogRead(0);
	int scaledMoistureData = map(result, 0, 400, 0, 100)
								 Serial.print("Received: ");
	Serial.println(k);
	delay(1000);
	if (previouslyDry && scaledMoistureData >= 50)
	{
		HTTPClient http;
		previouslyDry = false;
		http.begin(baseUrl + water);
		http.addHeader("apiKey", APIKEY);
		http.
	}
}
