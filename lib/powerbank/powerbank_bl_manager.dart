import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_pb/powerbank/powerbank.dart';

class PowerbankBLManager {
  late Powerbank powerbank;
  late FlutterReactiveBle _ble;
  DiscoveredDevice? _device;
  int lastUpdateTime = 0;

  PowerbankBLManager() {
    powerbank = Powerbank();
    powerbank.totalCapacity = 20000;
    powerbank.charge = 50;
  }

  Future<void> initBluetooth() async {
    //req permission
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      await Permission.locationWhenInUse.request();
    }
    _ble = FlutterReactiveBle();
  }

  Future<void> connect() async {
    while (!await _find()) {}
    _ble
        .connectToDevice(
      id: _device!.id,
      connectionTimeout: const Duration(seconds: 30),
    )
        .listen((connectionState) {
      print(connectionState);
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        final characteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("91bad492-b950-4226-aa2b-4ede9fa42f59"),
            characteristicId:
                Uuid.parse("cba1d466-344c-4be3-ab3f-189f80dd7518"),
            deviceId: _device!.id);
        _ble.subscribeToCharacteristic(characteristic).listen((data) {
          print('data:[${data[0]},${data[1]},${data[2]},${data[3]}]');
          print("decoded value: ${(data[1] << 8) | data[0]}");

          powerbank.lastUpdateTime = DateTime.now().millisecondsSinceEpoch;
          powerbank.voltage = (data[1] << 8) | data[0];
        }, onError: (dynamic error) {});
      }
    }, onError: (dynamic error) {
      // Handle a possible error
    });

    await _subscribe(_parser);
  }

  Future<bool> _find() async {

    Completer<bool> completer = Completer();

    //scan for devices, until appropriate one is found
    late StreamSubscription<DiscoveredDevice> devStream;
    devStream = _ble.scanForDevices(
      withServices: [],
      scanMode: ScanMode.lowLatency,
    ).listen((device) {
      print('Found "${device.name}",${device.id}');
      if (device.name == "VOLT_ESP32") {
        _device = device;
        completer.complete(true);
        devStream.cancel();
      }
    }, onError: (obj) {
      completer.complete(false);
    });

    return completer.future;
  }

  Future<void> _subscribe(void Function(List<int> data) subscriber) async {}

  void _parser(List<int> data) {
    print(data);
  }
}
