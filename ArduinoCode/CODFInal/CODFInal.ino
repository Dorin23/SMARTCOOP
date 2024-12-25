
#include <LiquidCrystal_I2C.h>
#include <Keypad.h>
#include <limits.h>
//Definire keypad
unsigned long sendDataPrevMillis = 0;
const byte ROWS = 4;
const byte COLS = 3;
char keypad[ROWS][COLS] = {
   {'1','2','3'},
   {'4','5','6'},
   {'7','8','9'},
   {'*','0','#'}
};
byte rowPins[ROWS] = {22,23,24,25};
byte colPins[COLS] = {26,27,28 };

Keypad customKeypad = Keypad(makeKeymap(keypad), rowPins, colPins, ROWS, COLS);
//Logica de histerezis
const int lightON = 890;
const int lightOFF = 830;
bool lightState = false;
unsigned long lastKeyOperationTime = 0;
const unsigned long keyOverrideDuration = 60000;
boolean lastDoorIsClosed = false; 
boolean lastDoorIsOpened = false;
int lastActivationCount = -1;
int lastCount = -1; 
// Definirea pinilor pentru controlul motorului
int in1 = 10;
int in2 = 11;
int lightSensor = A0;

bool inputMode = false;
boolean appControl = false;
// Definirea piilor pentru senzorul barierei optice
int opticSensor = 7;
int opticSensor2 = 13; 
int irSensor = 9;
int irSensor2 = 12;
int interruptCount = 0;
int activationCount = 0;
int count = 0;
int password = 0;
int newPassword = 1111;
unsigned long startTime = 0; 
const unsigned long limitTime = 5000;
unsigned long lastTime = 0; 
unsigned long lastKeyPressTime = 0;
const unsigned long delayMinim = 2000;
boolean sensor1Activated = false;
// Variabilă pentru a indica dacă senzorul 2 a fost activat
boolean sensor2Activated = false;
// Variabilă pentru a indica dacă motorul este pornit sau oprit
boolean motorRunning = false;
boolean inputCode = false;
boolean doorIsOpened = false;
boolean doorIsClosed = true;

//Initializare LCD
boolean tooFast = true;
LiquidCrystal_I2C lcd(0x27,16,2); 

long xorKey = 3456;
long xorEncryptDecrypt(long value, long xorkey) {
    return value ^ xorKey;
}

// Funcții pentru pornirea motorului
void startMotorRight() {
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);
  motorRunning = true;
  doorIsClosed = true;
  doorIsOpened = false;
   Serial.println("Usa se inchide automat!");
}
void startMotorLeft(){
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);
   motorRunning = true;
  doorIsClosed = false;
  doorIsOpened = true;
  Serial.println("Usa se deschide automat!");
}

// Funcție pentru oprirea motorului
void stopMotor() {
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);
   motorRunning = false;
   Serial.println("Motorul se opreste datorita detectiei IR.");
}
//Funcție pentru oprirea motorului la senzorii limitatori
void stopMotorUpandDown(){
   bool doorDetectDown = digitalRead(irSensor) == HIGH;
   bool doorDetectUp = digitalRead(irSensor2) == LOW;

  if(motorRunning){
    if(doorIsClosed && doorDetectDown){
      stopMotor();
      doorIsOpened = false;
    }else if (doorIsOpened && doorDetectUp){
      stopMotor();
      doorIsClosed = false;
    }
  }

}
//Funcție pentru controlul ușii in funcție de senzorul fotorezistiv
void controlDoorSensor(){
  //temporizator keypad
   if(millis() - lastKeyOperationTime < keyOverrideDuration){
    return;
   }

   int level = analogRead(A0);
   bool doorDetectDown = digitalRead(irSensor) == HIGH;
   bool doorDetectUp = digitalRead(irSensor2) == LOW;

  if(!appControl){ 
  if (!motorRunning && level > lightON && !doorIsClosed && activationCount >= count) {
    startMotorRight();  // Închide ușa 
  } else if (!motorRunning && level < lightOFF && !doorIsOpened && activationCount >= count) {
    startMotorLeft();  // Deschide ușa
  }
stopMotorUpandDown();
}
}



void setup() {
  Serial.begin(9600);

  // Setarea pinilor ca ieșiri pentru motor
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  
  // Setarea pinilor senzorilor ca intrări
  pinMode(lightSensor,INPUT_PULLUP);
  pinMode(opticSensor, INPUT_PULLUP); 
  pinMode(irSensor, INPUT_PULLUP); 
  pinMode(irSensor2, INPUT_PULLUP);
  pinMode(opticSensor2, INPUT_PULLUP);

  //Initializare lcd cu 16 coloane si 2 randuri
  lcd.init();
  lcd.backlight();
  lcd.setCursor(1-1, 1-1);
  lcd.print("    SmartCoop ");

  // Oprirea motorului inițial
  stopMotor();
}

//Funcție pentru a intra in modul de introducere a paroleu
void passwordMode(){
  inputCode = true;
  password = 0;
  tooFast = true;
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("    SmartCoop");
  lcd.setCursor(0, 1);
  lcd.print("Password: ");
}
//Funcție pentru confirmarea parolei la deschidere
void confirmPasswordOpened(){
  inputCode =false;
  if(password == newPassword && tooFast){
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("The door opens..");
  startMotorLeft(); 
  doorIsOpened = true;
  doorIsClosed = false;
  motorRunning = true;
  delay(3000);
  }else{
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Error");
    stopMotor();
    motorRunning = false;
    delay(3000);
  }
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("    SmartCoop ");
 // stopMotorUpandDown();
}
//Funcție pentru confirmarea parolei la închidere
void confirmPasswordClosed(){
  inputCode =false;
  if(password == newPassword){
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("The door closes..");
  startMotorRight(); 
  doorIsOpened = false;
  doorIsClosed = true;
  motorRunning = true;
  delay(3000);
  }else{
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Error");
    stopMotor();
    motorRunning = false;
    delay(3000);
  }
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("    SmartCoop ");
  //stopMotorUpandDown();
}
//Funcție pentru a intra in modul de introducere al numărului de gaini
void countMode(){
  inputMode = true;
  count = 0;
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Modul Numarare");
  lcd.setCursor(0, 1);
  lcd.print("NrGaini: ");
}
//Funcție pentru confirmarea numărului de gaini introdus
void confirmCount() {
  inputMode = false;
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Numar setat: ");
   lcd.setCursor(0, 1);
  lcd.print(count);
  delay(3000);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("    SmartCoop ");
}
//Funcție care va permite introducerea parolei si numărului e gaini
void inputKey(char key){
  if(inputCode && key >= '0' && key <= '9'){
    password = password * 10 + (key - '0');
    lcd.setCursor(0, 1);
    lcd.print("Password: ");
    for (int i = 0; i < (password > 0 ? (int)log10(password) + 1 : 1); i++) {
        lcd.print("*");
      }
  }else if (inputMode && key >= '0' && key <= '9'){
    count = count * 10 + (key - '0');
    lcd.setCursor(0, 1);
    lcd.print("NrGaini: ");
    lcd.print(count);
  }
}

void loop() {
  controlDoorSensor();

  char key = customKeypad.getKey();
  if(key != NO_KEY){
    unsigned long currentTime = millis();
    if(key == '#' && !inputCode && !inputMode){
      startTime = millis();
      lastTime = currentTime;
      tooFast = true;
      passwordMode();
     lastKeyPressTime = currentTime;
    }else if(key == '#' && inputCode && doorIsClosed && !doorIsOpened){
       if ((currentTime - lastKeyPressTime <= delayMinim) && (millis() - startTime <= limitTime) && tooFast)
        { 
          confirmPasswordOpened();
          lastKeyOperationTime = millis();
        }else{
        lcd.clear();
        lcd.setCursor(0, 0);
        lcd.print("Error");
        delay(3000);
        lcd.setCursor(1-1, 1-1);
        lcd.print("    SmartCoop ");
        lcd.setCursor(1-1, 2-1);
        lcd.print("   Gaini: ");
        lcd.setCursor(11-1, 2-1);
        lcd.print(activationCount);
        inputCode = false;
      }
      lastKeyPressTime = currentTime;
      lastTime = ULONG_MAX;
    }else if(key == '#' && inputCode && !doorIsClosed && doorIsOpened){
      confirmPasswordClosed();
      lastKeyOperationTime = millis();
    }
    if(key == '*' && !inputMode && !inputCode){
      countMode();
    }else if(key == '*' && inputMode){
      confirmCount();
    }
    if(inputCode || inputMode){
      if(currentTime - lastTime > delayMinim){
        tooFast = false;
      }
      inputKey(key);
      lastTime = currentTime;
    }
  }
  static bool lastActivatedSensor1 = false; 
  static bool lastActivatedSensor2 = false;  
if (digitalRead(opticSensor2) == LOW && !sensor1Activated && !sensor2Activated && !lastActivatedSensor2) {
    sensor2Activated = true;
    lastActivatedSensor2 = true;
    lastActivatedSensor1 = false;
    Serial.println("Senzorul 2 activat.");
  }else if(digitalRead(opticSensor2) == LOW && sensor1Activated && !sensor2Activated && !lastActivatedSensor2)
  {
    sensor2Activated = true;
    lastActivatedSensor2 = true;
    lastActivatedSensor1 = false;
    Serial.println("Senzorul 2 activat.");
  }

  if (digitalRead(opticSensor) == LOW && !sensor2Activated && !sensor1Activated && !lastActivatedSensor1) {
    sensor1Activated = true;
    lastActivatedSensor1 = true;
    lastActivatedSensor2 = false;
    Serial.println("Senzorul 1 activat.");
  }else if(digitalRead(opticSensor) == LOW && sensor2Activated && !sensor1Activated && !lastActivatedSensor1)
  {
    sensor1Activated = true;
    lastActivatedSensor1 = true;
    lastActivatedSensor2 = false;
    Serial.println("Senzorul 1 activat.");
  }

  // Dacă ambii senzori au fost activați, incrementăm sau decrementăm contorul și resetăm stările senzorilor
  if (sensor1Activated && sensor2Activated) {
    if (digitalRead(opticSensor) == HIGH && digitalRead(opticSensor2) == LOW) {
      if(activationCount < count){
      activationCount++;
     // Serial.println("Senzorul 1 activat după Senzorul 2, incrementare.");
     // Serial.print("Count: ");
     // Serial.println(activationCount);
      delay(2000);
      }
      
    } else if (digitalRead(opticSensor) == LOW && digitalRead(opticSensor2) == HIGH) {
      if(activationCount > 0){
      activationCount--;
     // Serial.println("Senzorul 2 activat după Senzorul 1, decrementare.");
      //Serial.print("Count: ");
      //Serial.println(activationCount);
      delay(2000);
      }
    }
    sensor1Activated = false;
    sensor2Activated = false;
    lastActivatedSensor1 = false; 
    lastActivatedSensor2 = false; 
    //Serial.println(activationCount);
  }
  if(!inputMode && !inputCode){
  //Afisare valori pe LCD
  lcd.setCursor(1-1, 1-1);
  lcd.print("    SmartCoop ");
  lcd.setCursor(1-1, 2-1);
  lcd.print("   Gaini: ");
  lcd.setCursor(11-1, 2-1);
  lcd.print(activationCount);

   for (int i = 10 + String(activationCount).length(); i < 16; i++) {
    lcd.setCursor(i, 1);
    lcd.print(" ");
  }
  }
  
int value; 
unsigned long currentMillis = millis();
 if(currentMillis - sendDataPrevMillis >= 60000){
  sendDataPrevMillis = currentMillis;
  long Lightvalue = analogRead(A0);
   value = xorEncryptDecrypt(Lightvalue, xorKey);
  Serial.print("A");
  Serial.println(value);
 }
   if(activationCount >= 0 && activationCount != lastActivationCount){
    Serial.print("B");
    Serial.println(activationCount);
    
  }
  if(count >= 0 && count != lastCount){
    Serial.print("C");
    Serial.println(count);
  }
 if(doorIsClosed != lastDoorIsClosed) {
    Serial.print("D");
    Serial.println(doorIsClosed ? "true" : "false");
  }
  if(doorIsOpened != lastDoorIsOpened) {
    Serial.print("E");
    Serial.println(doorIsOpened ? "true" : "false");
  }
  lastDoorIsClosed = doorIsClosed;
  lastDoorIsOpened = doorIsOpened;
  lastActivationCount = activationCount;
  lastCount = count;

if (Serial.available()) {
    String direction = Serial.readStringUntil('\n');
    direction.trim(); // Curăță orice spațiu sau caractere noi de linie

    // Verifică dacă comanda este "stop"
    if (direction == "stop" && appControl) {
        appControl = false;
    }
    // Altfel, verifică pentru direcțiile "backward" și "forward"
    else if (direction == "backward" || direction == "forward") {
        appControl = true; // Activează controlul aplicației
        if (direction == "backward" && !motorRunning && appControl) {
            startMotorLeft();
        } else if (direction == "forward" && !motorRunning && appControl) {
            startMotorRight();
        }

}
 
 }
 stopMotorUpandDown();
}

