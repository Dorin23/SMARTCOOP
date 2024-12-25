#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>

#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define WIFI_SSID "iPhone - Dorin"
#define WIFI_PASSWORD "caine100"
#define API_KEY "AIzaSyAv5el3_1-VupqqL8NkNDD-4A19jPYjNog"
#define DATABASE_URL "https://fir-esp-3a314-default-rtdb.firebaseio.com/"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signupOK = false;

void setup(){
  Serial.begin(9600);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  config.token_status_callback = tokenStatusCallback; 
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}
void loop(){
if (Firebase.ready() && signupOK) {
    if (Serial.available()) {
    unsigned long currentMillis = millis();
    if (currentMillis - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0) {
      sendDataPrevMillis = currentMillis;
      Serial.println("Checking for type A data...");
        char type = Serial.peek();
        Serial.print("Data type received: ");
        Serial.println(type);
        if (type == 'A') {
          Serial.read(); 
          int lightValue = Serial.parseInt();
          Serial.print("Sending light value: ");
          Serial.println(lightValue);
          sendToFirebase("sensor/light", lightValue);
        }
      }
    }
    
      processSerialData();
      
  }
  if (Firebase.RTDB.getString(&fbdo, "/motorControl/direction")) {
    if (fbdo.dataType() == "string") {
      String direction = fbdo.stringData();
      Serial.println(direction);
      delay(2000); 
    }
  }
  else {
    Serial.println(fbdo.errorReason());  /
  }

  delay(1000);  
}
  

void processSerialData() {
    while (Serial.available() > 0) {
        char type = Serial.peek(); // Pre-citește tipul pentru a decide cum să procedeze

        if (type == 'B' || type == 'C') {
            Serial.read(); // Consumă tipul
            int value = Serial.parseInt(); // Parsează întregul ce urmează
            String path = (type == 'B' ? "sensor/activationCount" : "sensor/count");
            sendToFirebase(path, value); // Trimitere la Firebase pentru valori numerice
        }
        else if (type == 'D' || type == 'E') {
            Serial.read(); // Consumă tipul
            String valueStr = Serial.readStringUntil('\n'); // Citește șirul până la newline
            valueStr.trim(); // Curăță spațiile albe din șirul primit
            bool value = (valueStr == "true"); // Converteste șirul în valoare booleană
            String path = (type == 'D' ? "motorControl/doorIsClosed" : "motorControl/doorIsOpened");
            sendToFirebase2(path, value); // Trimitere la Firebase pentru valori booleane
        }
        else {
            Serial.read(); // Consumă tipul necunoscut pentru a preveni blocarea buclei
        }
    }
}


void sendToFirebase(String path, int value) {
  if (Firebase.RTDB.setInt(&fbdo, path, value)) {
    Serial.print("Sent ");
    Serial.print(path);
    Serial.print(": ");
    Serial.println(value);
  } else {
    Serial.print("Failed to send ");
    Serial.print(path);
    Serial.print(": ");
    Serial.println(fbdo.errorReason());
  }
}
void sendToFirebase2(String path, bool value) {
  if (Firebase.RTDB.setBool(&fbdo, path, value)) { 
    Serial.print("Sent ");
    Serial.print(path);
    Serial.print(": ");
    Serial.println(value ? "true" : "false"); 
  } else {
    Serial.print("Failed to send ");
    Serial.print(path);
    Serial.print(": ");
    Serial.println(fbdo.errorReason());
  }
}

  
  

