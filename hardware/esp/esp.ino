#include "secrets.h"
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <Arduino_JSON.h>

#define SERIAL_BAUD 115200       // make sure this is the same in arduino.ino
const char *network = SSID;      // from secrets.h
const char *password = PASSWORD; // from secrets.h
bool previouslyDry = true;
String receivedCommand = "";
bool dataIn = false;
WiFiClient client;

void setup(void)
{
  Serial.begin(SERIAL_BAUD);
  // Connect to the WiFi network
  WiFi.begin(network, password);
  Serial.print("...\n");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print("...\n");
  }
  Serial.print("Connected!\n");
}

void loop(void)
{
  while (Serial.available())
  {
    char c = Serial.read();
    if (c == '[')
    {
      // this is the start of the moisture reading from Arduino Serial
      receivedCommand = "";
      dataIn = true;
    }
    else if (dataIn && c != ']')
    {
      // in the middle of reading moisture reading from Arduino Serial
      receivedCommand += c;
    }
    else if (dataIn && c == ']')
    {
      // reached the end of moisture reading from Arduino Serial
      int moisture = receivedCommand.toInt();
      Serial.print("Moisture: ");
      Serial.println(moisture);

      // The plant was dry but is now watered
      if (previouslyDry && moisture > 40)
      {
        /* USE THIS FOR DEBUGGING, UPDATE WEBHOOK ADDRESS IF NOT THE SAME
        Serial.println("Httping");
        HTTPClient httpDebug;
        httpDebug.begin(client, "http://webhook.site/9c5481b4-aece-44c5-ba3f-2a47fdbad73a");
        httpDebug.addHeader("Content-Type", "text/plain");
        String debug = "Watering: " + receivedCommand;
        httpDebug.POST(debug);
        httpDebug.end();*/
        // Send notification that watering has occured
        HTTPClient http;
        http.begin(client, "http://peclarke.pythonanywhere.com/send_plant_notification");
        http.addHeader("apiKey", APIKEY); // from secrets.h
        Serial.println("Attempting Notification API call");
        http.addHeader("Content-Type", "application/x-www-form-urlencoded");
        http.POST("plantId=110&title=Watering%20detected&message=Your%20plant%20has%20just%20been%20watered!");
        http.end();

        // Get the current datetime for logging watering activity
        HTTPClient httpTime;
        httpTime.begin(client, "http://worldtimeapi.org/api/timezone/Australia/Brisbane");
        Serial.println("Attempting get DateTime API call");
        httpTime.GET();
        // Format the time for activity API
        JSONVar timeJson = JSON.parse(httpTime.getString());
        String time = JSON.stringify(timeJson["datetime"]);
        time.remove(time.length() - 1, 1);
        time.remove(0, 1);
        Serial.println(time);
        String form = "plantId=110&time=" + time + "&activityTypeId=0";
        Serial.println(form);
        httpTime.end();

        // Post the new watering activity
        HTTPClient httpWater;
        httpWater.begin(client, "http://peclarke.pythonanywhere.com/activity");
        httpWater.addHeader("apiKey", APIKEY); // from secrets.h
        Serial.println("Attempting API call");
        httpWater.addHeader("Content-Type", "application/x-www-form-urlencoded");
        httpWater.POST(form);
        httpWater.end();
        // Adjust current state to wet
        previouslyDry = false;

        // The plant was watered but is now dry and needs watering
      }
      else if (moisture <= 10 && !previouslyDry)
      {
        /* USE THIS FOR DEBUGGING, UPDATE WEBHOOK ADDRESS IF NOT THE SAME
        Serial.println("Httping");
        HTTPClient httpDebug;
        httpDebug.begin(client, "http://webhook.site/9c5481b4-aece-44c5-ba3f-2a47fdbad73a");
        httpDebug.addHeader("Content-Type", "text/plain");
        String debug = "Requires WATERING: " + receivedCommand;
        httpDebug.POST(debug);
        httpDebug.end();*/

        HTTPClient http;
        http.begin(client, "http://peclarke.pythonanywhere.com/send_plant_notification");
        http.addHeader("apiKey", APIKEY); // from secrets.h
        Serial.println("Attempting API call");
        http.addHeader("Content-Type", "application/x-www-form-urlencoded");
        http.POST("plantId=110&title=Watering%20required&message=Your%20plant%20needs%20to%20be%20watered!");
        http.end();
        previouslyDry = true;
      }
      // The plant state has not changed to trigger a notification
      /* USE THIS FOR DEBUGGING, UPDATE WEBHOOK ADDRESS IF NOT THE SAME
      Serial.println("Httping");
      HTTPClient httpDebug;
      httpDebug.begin(client, "http://webhook.site/9c5481b4-aece-44c5-ba3f-2a47fdbad73a");
      httpDebug.addHeader("Content-Type", "text/plain");
      String debug = "NO CHANGE: " + receivedCommand;
      httpDebug.POST(debug);
      httpDebug.end();*/
    }
  }
}