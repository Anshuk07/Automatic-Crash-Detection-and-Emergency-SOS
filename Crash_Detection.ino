#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <SoftwareSerial.h>

// Define RX and TX pins for SoftwareSerial
int bluetoothRX = 1;
int bluetoothTX = 0;

SoftwareSerial bluetooth(bluetoothRX, bluetoothTX);
LiquidCrystal_I2C lcd(0x27, 16, 2); // Set the I2C address for your LCD (change to your actual address)

int FSR_PIN = A0;
int R0 = 1000; // Replace with the measured resistance when no force is applied
int Rf = 500;  // Replace with the measured resistance when a known force is applied
float F_known = 10.0; // Replace with the known force applied (in Newtons)

float maxForce = 0.0; // Variable to store the maximum force applied
String maxForceType = "None"; // Variable to store the type of crash of the max force applied
unsigned long lastResetTime = 0; // Variable to store the time of the last reset
const unsigned long resetInterval = 15000; // Interval in milliseconds before resetting maxForceType to "None"
int ledPin = 13; // Define the pin for the LED

bool dangerDisplayed = false; // Flag to track if danger message has been displayed

void setup() {
  Wire.begin();
  lcd.init();
  lcd.backlight();
  lcd.begin(16, 2); // Specify the number of columns and rows
  pinMode(ledPin, OUTPUT);

  // Initialize Serial communication for debugging
  Serial.begin(9600);

  // Initialize SoftwareSerial for Bluetooth communication
  bluetooth.begin(9600);
}

void loop() {
  int Force_VAL = analogRead(FSR_PIN);

  // Apply the calibration
  float force = (Force_VAL - R0) * F_known / (Rf - R0);

  lcd.clear();

  if (force > maxForce) {
    maxForce = force; // Update maxForce if a greater force is detected
    if (maxForce <= 5) {
      maxForceType = "Mild Crash";
    } else if (maxForce > 5 && maxForce <= 12) {
      maxForceType = "Moderate Crash";
    } else {
      maxForceType = "Severe Crash";
    }
    lastResetTime = millis(); // Update the last reset time
  }

  // Check if it's time to reset maxForceType to "None"
  if (millis() - lastResetTime > resetInterval) {
    maxForceType = "None";
  }

  lcd.setCursor(0, 0);
  lcd.print("Max Force: ");
  lcd.print(maxForce, 2); // Display the maximum force applied

  lcd.setCursor(0, 1);
  lcd.print(maxForceType); // Display the type of crash of the max force applied

  Serial.println(force); // Print force to the serial monitor for debugging

  // Toggle the LED based on maxForce value
  if (maxForce > 0) {
    // Blink the LED when maxForce is greater than zero
    for (int i = 0; i < 5; i++) {
      digitalWrite(ledPin, HIGH); // Turn on the LED
      delay(500); // LED on for 500ms
      digitalWrite(ledPin, LOW); // Turn off the LED
      delay(500); // LED off for 500ms
    }
  } else {
    digitalWrite(ledPin, LOW); // Turn off the LED if maxForce is not greater than zero
  }

  // Check if the force exceeds 10 and danger message has not been displayed
  if (force > 10 && !dangerDisplayed) {
    Serial.println("DANGER"); // Print "DANGER" message to the Serial Monitor
    dangerDisplayed = true; // Set flag to true to indicate the danger message has been displayed
  }

  delay(100); // Add a delay to stabilize readings
}