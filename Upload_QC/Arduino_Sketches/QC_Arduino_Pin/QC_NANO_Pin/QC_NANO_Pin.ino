const int samples = 100;
const int threshold = 30;  // Ngưỡng số lần trùng để đánh giá không tốt

bool allPinsGood = false;           // Biến lưu trạng thái chung
bool ledState = false;              // Trạng thái LED
unsigned long previousMillis = 0;  // Thời gian cho LED
bool sendingSerial = false;

void setAllPinsInputPullup() {
  for (int pin = 2; pin <= 12; pin++) {
    pinMode(pin, INPUT_PULLUP);
  }
  for (int pin = A0; pin <= A5; pin++) {
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
  for (int pin = A0; pin <= A5; pin++) {
    int state = digitalRead(pin);
    Serial.print("Pin A");
    Serial.print(pin - A0);
    Serial.print(": ");
    Serial.println(state == HIGH ? "HIGH" : "LOW");
  }
}

bool isPinGood(int pin) {
  int values[samples];
  for (int i = 0; i < samples; i++) {
    values[i] = analogRead(pin);
    delay(5);
  }
  for (int i = 0; i < samples; i++) {
    int count = 1;
    for (int j = i + 1; j < samples; j++) {
      if (values[i] == values[j]) {
        count++;
      }
    }
    if (count >= threshold) {
      return false;  // Không tốt
    }
  }
  return true;  // Tốt
}

bool testPins() {
  int pins[] = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, A0, A1, A2, A3, A4, A5 };
  int numPins = sizeof(pins) / sizeof(pins[0]);

  bool allGood = true;

  for (int i = 0; i < numPins; i++) {
    int testPin = pins[i];

    // Đặt tất cả chân INPUT_PULLUP trước
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

  // Kiểm tra chân analog A6 và A7
  if (!isPinGood(A6)) {
    Serial.println("Maybe Analog Pin A6 is NOT GOOD");
    allGood = false;
  } else {
    // Serial.println("Analog Pin A6 is GOOD");
  }

  if (!isPinGood(A7)) {
    Serial.println("Maybe Analog Pin A7 is NOT GOOD");
    allGood = false;
  } else {
    // Serial.println("Analog Pin A7 is GOOD");
  }

  // Reset chân 2–13 và A0–A5 về INPUT_PULLUP
  for (int j = 0; j < numPins; j++) {
    pinMode(pins[j], INPUT_PULLUP);
  }
  pinMode(13, OUTPUT);

  return allGood;
}

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("--- Hshop GPIO TESTING Sketch for NANO ---");
  Serial.println("Author: Daniel Hoang");

  setAllPinsInputPullup();
  allPinsGood = testPins();
}

void loop() {
  if (allPinsGood) {
    unsigned long currentMillis = millis();
    if (currentMillis - previousMillis >= 100) {
      previousMillis = currentMillis;
      sendingSerial = !sendingSerial;

      if (sendingSerial) {
        Serial.println("--- --- --- ||| All GPIO Pin is OKAY! ||| --- --- ---");
        digitalWrite(13, LOW);
      } else {
        digitalWrite(13, HIGH);
      }
    }
  }
  // Nếu không tốt thì không làm gì trong loop
}
