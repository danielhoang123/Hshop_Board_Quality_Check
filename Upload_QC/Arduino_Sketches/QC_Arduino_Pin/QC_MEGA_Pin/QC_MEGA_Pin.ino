bool allPinsGood = false;           // Biến lưu trạng thái sau kiểm tra
bool ledState = false;              // Trạng thái bật/tắt LED
unsigned long previousMillis = 0;   // Để điều khiển thời gian 100ms
bool sendingSerial = false;

void setAllPinsInputPullup() {
  // Chân digital 2 -> 53
  for (int pin = 2; pin <= 53; pin++) {
    pinMode(pin, INPUT_PULLUP);
  }
  // Chân analog A0 -> A15
  for (int pin = A0; pin <= A15; pin++) {
    pinMode(pin, INPUT_PULLUP);
  }
}

void readAllPins() {
  // Đọc digital pins
  for (int pin = 2; pin <= 53; pin++) {
    int state = digitalRead(pin);
    Serial.print("Pin ");
    Serial.print(pin);
    Serial.print(": ");
    Serial.println(state == HIGH ? "HIGH" : "LOW");
  }

  // Đọc analog pins
  for (int pin = A0; pin <= A15; pin++) {
    int state = digitalRead(pin);
    Serial.print("Pin A");
    Serial.print(pin - A0);
    Serial.print(": ");
    Serial.println(state == HIGH ? "HIGH" : "LOW");
  }
}

void testPins() {
  int numDigitalPins = 53 - 2 + 1; // 52 pins
  int numAnalogPins = A15 - A0 + 1; // 16 pins
  int numPins = numDigitalPins + numAnalogPins;

  // Mảng chứa tất cả các chân digital và analog
  int pins[numPins];
  
  // Thêm chân digital 2->53 vào mảng
  for (int i = 0; i < numDigitalPins; i++) {
    pins[i] = 2 + i;
  }
  // Thêm chân analog A0->A15 vào mảng
  for (int i = 0; i < numAnalogPins; i++) {
    pins[numDigitalPins + i] = A0 + i;
  }

  allPinsGood = true;

  for (int i = 0; i < numPins; i++) {
    int testPin = pins[i];

    // Đặt tất cả chân là INPUT_PULLUP
    for (int j = 0; j < numPins; j++) {
      pinMode(pins[j], INPUT_PULLUP);
    }

    // Set chân testPin thành OUTPUT và LOW
    pinMode(testPin, OUTPUT);
    digitalWrite(testPin, LOW);

    delay(5); // chờ ổn định

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

  // Phục hồi các chân về INPUT_PULLUP
  for (int j = 0; j < numPins; j++) {
    pinMode(pins[j], INPUT_PULLUP);
  }
  pinMode(13, OUTPUT); // LED báo trạng thái
}

void setup() {
  Serial.begin(115200);
  delay(25);
  Serial.println("--- Hshop GPIO TESTING Sketch for MEGA2560 ---");
  setAllPinsInputPullup();
  testPins();
}

void loop() {
  if (allPinsGood) {
    unsigned long currentMillis = millis();
    if (currentMillis - previousMillis >= 100) {
      previousMillis = currentMillis;
      sendingSerial = !sendingSerial;

      if (sendingSerial) {
        Serial.println("--- --- --- ||| All GPIO Pin is OKAY! ||| --- --- ---");
        digitalWrite(13, LOW);  // Tắt LED13 khi TX sáng
      } else {
        digitalWrite(13, HIGH); // Bật LED13 khi TX tắt
      }
    }
  }
}
