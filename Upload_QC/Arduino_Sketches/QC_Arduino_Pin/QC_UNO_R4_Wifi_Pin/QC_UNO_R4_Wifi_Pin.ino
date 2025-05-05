#include <WiFiS3.h>
#include <ArduinoGraphics.h>
#include <Arduino_LED_Matrix.h>

ArduinoLEDMatrix matrix;
unsigned long previousMillisLed = 0;
const unsigned long intervalLed = 100;  // 100ms bật 1 LED
bool sendingSerial = false;

bool allPinsGood = true;  // Giữ true, nếu phát hiện lỗi sẽ đổi false

enum State {
  CHECK_GPIO,
  CHECK_GPIO_RUN,
  LED_MATRIX_ON,
  LED_MATRIX_RUN,
  WIFI_SCAN_DONE
};

State currentState = CHECK_GPIO;

unsigned long previousMillisWiFi = 0;
unsigned long previousMillisGPIOPrint = 0;

const unsigned long intervalWiFi = 5000;       // 10s scan WiFi
const unsigned long intervalGPIOPrint = 50;    // 100ms print Serial
const unsigned long gpioCheckDuration = 3000;  // 3s kiểm tra GPIO

unsigned long gpioCheckStartTime = 0;

int ledX = 0;
int ledY = 0;

void setAllPinsInputPullup() {
  for (int pin = 2; pin <= 13; pin++) {
    pinMode(pin, INPUT_PULLUP);
  }
  for (int pin = A0; pin <= A5; pin++) {
    pinMode(pin, INPUT_PULLUP);
  }
}

bool testPinsOnce() {
  // Hàm kiểm tra chân GPIO, trả về false nếu phát hiện lỗi
  int pins[] = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, A0, A1, A2, A3, A4, A5 };
  int numPins = sizeof(pins) / sizeof(pins[0]);
  bool allGood = true;

  for (int i = 0; i < numPins; i++) {
    int testPin = pins[i];

    for (int j = 0; j < numPins; j++) {
      pinMode(pins[j], INPUT_PULLUP);
    }

    pinMode(testPin, OUTPUT);
    digitalWrite(testPin, LOW);

    delay(5);

    bool pinGood = true;
    for (int j = 0; j < numPins; j++) {
      if (pins[j] == testPin) continue;
      int state = digitalRead(pins[j]);
      if (state == LOW) {
        pinGood = false;
        break;
      }
    }

    if (!pinGood) {
      Serial.print("Maybe GPIO ");
      if (testPin >= A0) {
        Serial.print("A");
        Serial.print(testPin - A0);
      } else {
        Serial.print(testPin);
      }
      Serial.println(" is SHORTED or ERROR");
      allGood = false;
    }
  }

  for (int j = 0; j < numPins; j++) {
    pinMode(pins[j], INPUT_PULLUP);
  }
  pinMode(13, OUTPUT);

  return allGood;
}

void scanWiFi() {
  Serial.println("Scanning WiFi networks...");
  int numNetworks = WiFi.scanNetworks();
  if (numNetworks == -1) {
    Serial.println("Scan failed!");
    return;
  }
  Serial.print(numNetworks);
  Serial.println(" network(s) found:");
  for (int i = 0; i < numNetworks; i++) {
    Serial.print("- ");
    Serial.print(WiFi.SSID(i));
    Serial.print(" (RSSI: ");
    Serial.print(WiFi.RSSI(i));
    Serial.println(" dBm)");
  }
}

void setup() {
  Serial.begin(115200);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  Serial.println("--- Hshop GPIO + Built-in Matrix + WiFi Scanner ---");
  Serial.println("Author: Daniel Hoang");

  // check for the WiFi module:
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    // don't continue
    while (true)
      ;
  }

  String fv = WiFi.firmwareVersion();
  if (fv < WIFI_FIRMWARE_LATEST_VERSION) {
    Serial.println("Please upgrade the firmware");
  }

  setAllPinsInputPullup();
  matrix.begin();

  currentState = CHECK_GPIO;
  gpioCheckStartTime = millis();  // Bắt đầu tính thời gian kiểm tra GPIO
}

void loop() {
  unsigned long currentMillis = millis();

  switch (currentState) {

    case CHECK_GPIO:
      Serial.println("/*** Test GPIO START ***/");
      currentState = CHECK_GPIO_RUN;
      break;
    case CHECK_GPIO_RUN:

      // Kiểm tra GPIO trong 3 giây
      if (currentMillis - gpioCheckStartTime <= gpioCheckDuration) {
        // Kiểm tra từng vòng
        allPinsGood = testPinsOnce();
        if (!allPinsGood) {
          Serial.println("GPIO check failed! Stopping.");
          // Dừng tại đây, không chuyển state
          while (true) {
            // Dừng luôn chương trình, hoặc bạn có thể thêm cơ chế khác
          }
        }

        // In thông báo mỗi 100ms nếu GPIO OK
        if (currentMillis - previousMillisGPIOPrint >= intervalGPIOPrint) {
          previousMillisGPIOPrint = currentMillis;
          sendingSerial = !sendingSerial;

          if (sendingSerial) {
            Serial.println("--- --- --- ||| All GPIO Pin is OKAY! ||| --- --- ---");
            digitalWrite(13, LOW);
          } else {

            digitalWrite(13, HIGH);
          }
        }
      } else {
        // Hết 3 giây, chuyển qua bật LED ma trận
        Serial.println("/*** Test GPIO END ***/");
        Serial.println("-----------------------");
        currentState = LED_MATRIX_ON;
      }
      break;

    case LED_MATRIX_ON:
      Serial.println("/*** Test Matrix LED START ***/");
      Serial.println("...");
      currentState = LED_MATRIX_RUN;
      break;
    case LED_MATRIX_RUN: 
      matrix.beginDraw();
      for (int y = 0; y <= ledY; y++) {
        int maxX = (y == ledY) ? ledX : 11;
        for (int x = 0; x <= maxX; x++) {
          matrix.stroke(0xFF0000);  // Màu đỏ
          matrix.point(x, y);
        }
      }
      matrix.endDraw();

      ledX++;
      if (ledX > 11) {
        ledX = 0;
        ledY++;
      }

      if (ledY > 7) {
        Serial.println("/*** Test Matrix LED END ***/");
        Serial.println("-----------------------------");
        Serial.println("/*** Test Wifi START ***/");
        currentState = WIFI_SCAN_DONE;
        previousMillisWiFi = currentMillis;
      }

      delay(25);
      break;

    case WIFI_SCAN_DONE:
      byte mac[6];
      // scan for existing networks:
      Serial.println("Scanning available networks...");
      listNetworks();
      WiFi.macAddress(mac);
      Serial.println();
      Serial.print("Your MAC Address is: ");
      printMacAddress(mac);
      delay(10000);
      
      break;
  }
}

void listNetworks() {
  // scan for nearby networks:
  Serial.println("** Scan Networks **");
  int numSsid = WiFi.scanNetworks();
  if (numSsid == -1) {
    Serial.println("Couldn't get a WiFi connection");
    while (true)
      ;
  }

  // print the list of networks seen:
  Serial.print("number of available networks:");
  Serial.println(numSsid);

  // print the network number and name for each network found:
  for (int thisNet = 0; thisNet < numSsid; thisNet++) {
    Serial.print(thisNet);
    Serial.print(") ");
    Serial.print(WiFi.SSID(thisNet));
    Serial.print(" Signal: ");
    Serial.print(WiFi.RSSI(thisNet));
    Serial.print(" dBm");
    Serial.print(" Encryption: ");
    printEncryptionType(WiFi.encryptionType(thisNet));
  }
}

void printEncryptionType(int thisType) {
  // read the encryption type and print out the name:
  switch (thisType) {
    case ENC_TYPE_WEP:
      Serial.println("WEP");
      break;
    case ENC_TYPE_WPA:
      Serial.println("WPA");
      break;
    case ENC_TYPE_WPA2:
      Serial.println("WPA2");
      break;
    case ENC_TYPE_WPA3:
      Serial.println("WPA3");
      break;
    case ENC_TYPE_NONE:
      Serial.println("None");
      break;
    case ENC_TYPE_AUTO:
      Serial.println("Auto");
      break;
    case ENC_TYPE_UNKNOWN:
    default:
      Serial.println("Unknown");
      break;
  }
}


void printMacAddress(byte mac[]) {
  for (int i = 0; i < 6; i++) {
    if (i > 0) {
      Serial.print(":");
    }
    if (mac[i] < 16) {
      Serial.print("0");
    }
    Serial.print(mac[i], HEX);
  }
  Serial.println();
}
