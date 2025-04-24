// Kudos to https://curiousscientist.tech/blog/max6675-thermocouple-module

#include <LiquidCrystal_I2C.h>
#include <SPI.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);
int TCRaw = 0;
float TCCelsius = 0;
float TCFahrenheit = 0;
const byte CS_pin = 10;

void setup() {
  pinMode(CS_pin, OUTPUT);
  digitalWrite(CS_pin, LOW);
  SPI.begin();
  Serial.begin(115200);

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
  delay(200);
  refreshLCD();
}

void printLCD() {
  // These are the values which are not changing during the operation
  lcd.setCursor(0, 0);  // 1st line, 1st block
  lcd.print("C:");      // Text for Celsius
  lcd.setCursor(0, 1);  // 2nd line, 1st block
  lcd.print("F:");      // Text for Fahrenheit
}

void refreshLCD() {
  // These are the values which are changing during the operation
  lcd.setCursor(2, 0);         // 1st line, 3rd block
  lcd.print("             ");  // Clear display
  lcd.setCursor(2, 0);         // 1st line, 3rd block
  lcd.print(TCCelsius);        // Celsius value

  lcd.setCursor(2, 1);         // 2nd line, 3rd block
  lcd.print("             ");  // Clear display
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

  Serial.print("Raw: ");
  Serial.println(TCRaw);  // Print raw data

  TCCelsius = TCRaw * 0.25;                       // Datasheet, 2nd page, resolution
  TCFahrenheit = (TCCelsius * 9.0 / 5.0) + 32.0;  // Convert to Fahrenheit

  Serial.print("Temp C: ");
  Serial.println(TCCelsius);  // Print converted data
  Serial.print("Temp F: ");
  Serial.println(TCFahrenheit);  // Print Fahrenheit data
}