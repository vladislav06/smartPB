/*********
  Rui Santos - Complete instructions at https://RandomNerdTutorials.com/esp32-ble-server-client/
*********/

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <Wire.h>

//BLE server name
#define bleServerName "VOLT_ESP32"

// Timer variables
unsigned long lastTime = 0;
unsigned long timerDelay = 1000;

bool deviceConnected = false;

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/
#define SERVICE_UUID "91bad492-b950-4226-aa2b-4ede9fa42f59"

// Voltage Characteristic and Descriptor
BLECharacteristic voltageCharacteristics("cba1d466-344c-4be3-ab3f-189f80dd7518", BLECharacteristic::PROPERTY_NOTIFY);
BLEDescriptor voltageDescriptor(BLEUUID((uint16_t)0x2902));

//Setup callbacks onConnect and onDisconnect
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };
    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};
BLEServer *pServer;
void setup() {
  // Start serial communication
  Serial.begin(115200);

  // Create the BLE Device
  BLEDevice::init(bleServerName);

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pinService = pServer->createService(SERVICE_UUID);

  // Create BLE Characteristics and Create a BLE Descriptor
  // Voltage
  pinService->addCharacteristic(&voltageCharacteristics);
  voltageDescriptor.setValue("Voltage");
  voltageCharacteristics.addDescriptor(&voltageDescriptor);

  // Start the service
  pinService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pServer->getAdvertising()->start();
  Serial.println("Waiting a client connection to notify...");
}
bool startAdvertisment = false;
void loop() {
  if (deviceConnected) {
    startAdvertisment = true;
    if ((millis() - lastTime) > timerDelay) {
      // Read temperature as Celsius (the default)
      int voltage = analogRead(36);
      //Notify voltage reading from pin
      //Set voltage Characteristic value and notify connected client
      voltageCharacteristics.setValue(voltage);
      voltageCharacteristics.notify();
      Serial.print("Voltage: ");
      Serial.print(voltage);
      Serial.println(" V");

      lastTime = millis();
      return;
    }
  } else {
    if (startAdvertisment) {
      Serial.println("Waiting a client connection to notify...");
      startAdvertisment = false;
      // Start advertising
      BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
      pAdvertising->addServiceUUID(SERVICE_UUID);
      pServer->getAdvertising()->start();
    }
  }
}
