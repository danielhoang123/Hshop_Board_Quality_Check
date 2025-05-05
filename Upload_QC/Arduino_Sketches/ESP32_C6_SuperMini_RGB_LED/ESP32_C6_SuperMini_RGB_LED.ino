/*********
  Rui Santos
  Complete project details at https://randomnerdtutorials.com  
*********/

#include "WiFi.h"
#include "Freenove_WS2812_Lib_for_ESP32.h"

#define LEDS_COUNT 1
#define LEDS_PIN 8
#define CHANNEL 0

Freenove_ESP32_WS2812 strip = Freenove_ESP32_WS2812(LEDS_COUNT, LEDS_PIN, CHANNEL, TYPE_GRB);

TaskHandle_t Task1;
TaskHandle_t Task2;

void setup() {

  Serial.begin(115200);
  pinMode(48, OUTPUT);

  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  delay(100);
  Serial.println("Setup done");
  //create a task that will be executed in the Task1code() function, with priority 1 and executed on core 0
  xTaskCreate(
    Task1code, /* Task function. */
    "Task1",   /* name of task. */
    10000,     /* Stack size of task */
    NULL,      /* parameter of the task */
    1,         /* priority of the task */
    &Task1    /* Task handle to keep track of created task */
    );        /* pin task to core 0 */
  delay(500);

  //create a task that will be executed in the Task2code() function, with priority 1 and executed on core 1
  xTaskCreate(
    Task2code, /* Task function. */
    "Task2",   /* name of task. */
    10000,     /* Stack size of task */
    NULL,      /* parameter of the task */
    1,         /* priority of the task */
    &Task2    /* Task handle to keep track of created task */
    );        /* pin task to core 1 */
  delay(500);
}

//Task1code: blinks an LED every 1000 ms
void Task1code(void* pvParameters) {

  Serial.print("Task1 running on core ");
  Serial.println(xPortGetCoreID());

  strip.begin();
  strip.setBrightness(20);

  for (;;) {
    // digitalWrite(led1, HIGH);
    // delay(1000);
    // digitalWrite(led1, LOW);
    // delay(1000);

    for (int j = 0; j < 255; j += 2) {
      for (int i = 0; i < LEDS_COUNT; i++) {
        strip.setLedColorData(i, strip.Wheel((i * 256 / LEDS_COUNT + j) & 255));
      }
      strip.show();
      delay(8);
    }
  }
}

//Task2code: blinks an LED every 700 ms
void Task2code(void* pvParameters) {
  Serial.print("Task2 running on core ");
  Serial.println(xPortGetCoreID());

  for (;;) {
    Serial.println("Scan start");

    // WiFi.scanNetworks will return the number of networks found.
    int n = WiFi.scanNetworks();
    Serial.println("Scan done");
    if (n == 0) {
      Serial.println("no networks found");
    } else {
      Serial.print(n);
      Serial.println(" networks found");
      Serial.println("Nr | SSID                             | RSSI | CH | Encryption");
      for (int i = 0; i < n; ++i) {
        // Print SSID and RSSI for each network found
        Serial.printf("%2d", i + 1);
        Serial.print(" | ");
        Serial.printf("%-32.32s", WiFi.SSID(i).c_str());
        Serial.print(" | ");
        Serial.printf("%4ld", WiFi.RSSI(i));
        Serial.print(" | ");
        Serial.printf("%2ld", WiFi.channel(i));
        Serial.print(" | ");
        switch (WiFi.encryptionType(i)) {
          case WIFI_AUTH_OPEN: Serial.print("open"); break;
          case WIFI_AUTH_WEP: Serial.print("WEP"); break;
          case WIFI_AUTH_WPA_PSK: Serial.print("WPA"); break;
          case WIFI_AUTH_WPA2_PSK: Serial.print("WPA2"); break;
          case WIFI_AUTH_WPA_WPA2_PSK: Serial.print("WPA+WPA2"); break;
          case WIFI_AUTH_WPA2_ENTERPRISE: Serial.print("WPA2-EAP"); break;
          case WIFI_AUTH_WPA3_PSK: Serial.print("WPA3"); break;
          case WIFI_AUTH_WPA2_WPA3_PSK: Serial.print("WPA2+WPA3"); break;

          case WIFI_AUTH_WAPI_PSK: Serial.print("WAPI"); break;
          default: Serial.print("unknown");
        }
        Serial.println();
        delay(10);
      }
    }
    Serial.println("");

    // Delete the scan result to free memory for code below.
    WiFi.scanDelete();

    // Wait a bit before scanning again.
    delay(5000);
  }
}

void loop() {
}