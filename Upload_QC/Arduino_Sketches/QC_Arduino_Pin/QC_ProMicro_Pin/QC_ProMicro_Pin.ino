bool allPinsGood = false;           // Biến lưu trạng thái sau kiểm tra
bool ledState = false;              // Trạng thái bật/tắt LED
unsigned long previousMillis = 0;   // Để điều khiển thời gian 100ms
unsigned long previousMillis1 = 0;  // Để điều khiển thời gian 100ms
bool sendingSerial = false;

void setAllPinsInputPullup() {

  for (int pin = 2; pin <= 12; pin++) {
    pinMode(pin, INPUT_PULLUP);
  }

  for (int pin = A0; pin <= A4; pin++) {
    pinMode(pin, INPUT_PULLUP);
  }
}

void readAllPins() {

  for (int pin = 2; pin <= 12; pin++) {
    int state = digitalRead(pin);
    Serial.print("Pin ");
    Serial.print(pin);
    Serial.print(": ");
    Serial.println(state == HIGH ? "HIGH" : "LOW");
  }

  // Đọc các chân analog từ A0 đến A5
  for (int pin = A0; pin <= A4; pin++) {
    int state = digitalRead(pin);
    Serial.print("Pin A");
    Serial.print(pin - A0);
    Serial.print(": ");
    Serial.println(state == HIGH ? "HIGH" : "LOW");
  }
}

void testPins() {

  int pins[] = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, A0, A1, A2, A3, A4 };
  int numPins = sizeof(pins) / sizeof(pins[0]);

  allPinsGood = true;

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
      allPinsGood = false;
    }
  }


  for (int j = 0; j < numPins; j++) {
    pinMode(pins[j], INPUT_PULLUP);
  }
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  delay(25);
  Serial.println("--- Hshop GPIO TESTING Sketch for ProMicro ---");
  Serial.println("Author: Daniel Hoang");
  setAllPinsInputPullup();
  // readAllPins();
  testPins();
}

void loop() {
  // put your main code here, to run repeatedly:
  if (allPinsGood) {
    unsigned long currentMillis = millis();
    if (currentMillis - previousMillis >= 250) {  // Đủ 100ms
      previousMillis = currentMillis;
      Serial.println("--- --- --- ||| All GPIO Pin is OKAY! ||| --- --- ---");
    }
  }
}
