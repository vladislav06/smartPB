import 'package:flutter_blue/flutter_blue.dart';

class PowerbankBLManager {
  late FlutterBlue bl;
  late BluetoothDevice device;

  void initBluetooth() {
    bl = FlutterBlue.instance;
  }

  Future<void> scan() async {
    // Start scanning
    var devices = await bl.connectedDevices;
    for (BluetoothDevice d in devices) {
      print('${d.name} found! rssi: ${d.type}');
      if (d.name == "VOLT_ESP32") {
        device = d;
        device.connect();
      }
    }
  }

  Future<void> subscribe(void Function(List<int> data) subscriber) async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        List<int> value = await c.read();
        print(value);
        await c.setNotifyValue(true);
        c.value.listen((value) {
          subscriber(value);
        });
      }
    });
  }
}
