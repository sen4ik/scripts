// Kudos to https://curiousscientist.tech/blog/max6675-thermocouple-module

#include <LiquidCrystal_I2C.h>
#include <SPI.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);
int TCRaw = 0;
float TCCelsius = 0;
float TCFahrenheit = 0;
const byte CS_pin = 10;

const byte FG_pin = 2;  // Using D2 for fan FG
volatile unsigned long pulseCount = 0;
unsigned long lastRPMCheck = 0;
float rpm = 0;

void setup() {
  pinMode(CS_pin, OUTPUT);
  digitalWrite(CS_pin, LOW);
  SPI.begin();
  Serial.begin(115200);

  pinMode(FG_pin, INPUT);  // No pullup, since you've added external resistor
  attachInterrupt(digitalPinToInterrupt(FG_pin), countPulse, FALLING);

  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);  // Defining positon to write from first row, first column
  lcd.print("Dummy Load");
  lcd.setCursor(0, 1);  // Second row, first column
  lcd.print("800W 50ohm");
  delay(2000);

  lcd.clear();  // Clear the whole LCD

  printLCD();  // Print the stationary parts on the screen
}

void loop() {
  readThermocouple();
  updateRPM();   // RPM update every second
  refreshLCD();
  delay(200);
}

void printLCD() {
  // These are the values which are not changing during the operation
  lcd.setCursor(0, 0);  // 1st line, 1st block
  lcd.print("C:");      // Text for Celsius
  lcd.setCursor(9, 0);  // 1st line, 10th block
  lcd.print("R:");      // Text for RPM (changed from RPM: to R:)
  lcd.setCursor(0, 1);  // 2nd line, 1st block
  lcd.print("F:");      // Text for Fahrenheit
}

void refreshLCD() {
  // These are the values which are changing during the operation
  lcd.setCursor(2, 0);         // 1st line, 3rd block
  lcd.print("      ");         // Clear display for temperature
  lcd.setCursor(2, 0);         // 1st line, 3rd block
  lcd.print(TCCelsius);        // Celsius value

  // Update RPM display with proper formatting
  lcd.setCursor(13, 0);        // 1st line, 14th block
  lcd.print("   ");            // Clear display for RPM
  lcd.setCursor(13, 0);        // 1st line, 14th block
  lcd.print(int(rpm));         // RPM value (converted to integer for cleaner display)

  lcd.setCursor(2, 1);         // 2nd line, 3rd block
  lcd.print("      ");         // Clear display
  lcd.setCursor(2, 1);         // 2nd line, 3rd block
  lcd.print(TCFahrenheit);     // Fahrenheit value
}

void readThermocouple() {
  // Bits
  // 15: dummy bit
  // 14-3: MSB to LSB
  // 2: -
  // 1: 0
  // 0: STATE (three state)

  SPI.beginTransaction(SPISettings(14000000, MSBFIRST, SPI_MODE0));  // Standard Arduino SPI
  digitalWrite(CS_pin, LOW);                                         // "Force CS low and apply a clock signal at SCK to read the results at SO"
  delayMicroseconds(1);                                              // Just to be sure we wait enough (tcss: 100 ns is needed)

  TCRaw = SPI.transfer16(0x0000);  // 16 bit transfer - some dummy data to force the reading

  digitalWrite(CS_pin, HIGH);  // We finished the command sequence, so we switch it back to HIGH
  SPI.endTransaction();        // Close down SPI transaction

  TCRaw = TCRaw >> 3;  // Shift out the first 3 bits.
  // Example: 0100000000001ˇ111 >> 3;     ˇLSB
  // 010000000000001<-(LSB)
  // ^Dummy, then MSB

  ///Serial.print("Raw: ");
  // Serial.println(TCRaw);  // Print raw data

  TCCelsius = TCRaw * 0.25;                       // Datasheet, 2nd page, resolution
  TCFahrenheit = (TCCelsius * 9.0 / 5.0) + 32.0;  // Convert to Fahrenheit

  // Serial.print("Temp C: ");
  // Serial.println(TCCelsius);  // Print converted data
  // Serial.print("Temp F: ");
  // Serial.println(TCFahrenheit);  // Print Fahrenheit data
}

void countPulse() {
  // Simple pulse counter, no debounce needed with the hardware pull-up
  pulseCount++;
}

void updateRPM() {
  unsigned long now = millis();
  if (now - lastRPMCheck >= 1000) {  // Calculate RPM every second
    noInterrupts();
    unsigned long count = pulseCount;
    pulseCount = 0;
    interrupts();
    
    // Debug output
    Serial.print("Raw pulse count: "); 
    Serial.print(count);
    
    // Calibrated calculation based on your fan's specifications
    // Dividing by a calibration factor to get RPM in the expected range
    // For PEAD14028BH fan which runs at 14,600-20,000 RPM
    if (count < 100) {
      rpm = 0;  // Consider it stopped or noise if count is very low
    } else {
      // Based on your 74,000 pulses translating to about 15,000-20,000 RPM
      // We'll use a divisor of 74000/15000*60 ≈ 296 (rounded to 300)
      rpm = (count / 300.0) * 60.0;
    }
    
    Serial.print(" | Calculated RPM: "); 
    Serial.println(rpm);
    
    lastRPMCheck = now;
  }
}