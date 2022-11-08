#include <Mouse.h>

// https://habr.com/ru/post/691336/
// int loop_interval = 30000;
unsigned int loop_interval = 15000;
int TXLED = 30;
int switch_on_off;

void setup() {
  pinMode(2, INPUT_PULLUP);
  pinMode(RXLED, OUTPUT);
  pinMode(TXLED, OUTPUT);
  digitalWrite(RXLED, HIGH);  //RX LED off
  digitalWrite(TXLED, HIGH);  //TX LED off
  randomSeed(analogRead(0));
  Mouse.begin();
  delay(200);
}

void loop() {
  digitalWrite(TXLED, HIGH);
  switch_on_off = digitalRead(2);
  if (switch_on_off == LOW) {
    digitalWrite(RXLED, LOW);
    int x = random(4) - 2;
    int y = random(4) - 2;
    Mouse.move(x, y, 0);
    digitalWrite(TXLED, LOW);
    delay(100);  //does not work with 50!
    digitalWrite(TXLED, HIGH);
    delay(loop_interval);
  } else {
    digitalWrite(RXLED, HIGH);
    digitalWrite(TXLED, HIGH);
  }
}