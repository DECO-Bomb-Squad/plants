#define SERIAL_BAUD 115200
const int sensor_pin = 0;

void setup()
{
  Serial.begin(SERIAL_BAUD); // same as ESP baud
}

void loop()
{
  while (Serial.available())
  {
    // Read the moisture sensor
    int result = analogRead(sensor_pin);
    result = map(result, 0, 400, 0, 100);
    // Send the results to be read by ESP Serial
    Serial.print("[");
    Serial.print(result);
    Serial.println("]");
  }
}