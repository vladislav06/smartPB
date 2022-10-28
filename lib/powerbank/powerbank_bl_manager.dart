import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:smart_pb/powerbank/powerbank.dart';
import 'package:smart_pb/util/file_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_pb/powerbank/powerbank.dart';

/// Singleton manager, that manages powerbank instance
class PowerbankBLManager {
  PowerbankBLManager.privateConstructor() {
    _powerbank = Powerbank();
  }

  static final PowerbankBLManager _instance =
      PowerbankBLManager.privateConstructor();

  factory PowerbankBLManager() => _instance;

  File? _file;
  static const _fileName = 'saved_presets.json';

  // Get the data file
  Future<File> get file async {
    if (_file != null) return _file!;

    _file = await initFile(_fileName);
    return _file!;
  }

  late Powerbank _powerbank;

  Powerbank get powerbank => _powerbank;

  late FlutterReactiveBle _ble;
  DiscoveredDevice? _device;
  int lastUpdateTime = 0;

  /// Load [powerbank] from storage
  Future<void> loadPowerbank() async {
    final File fl = await file;
    final content = await fl.readAsString();

    try {
      Map<String, dynamic> data = jsonDecode(content);
      _powerbank.fromJson(data);
    } catch (e) {
      print(e);
    }
    _powerbank.totalCapacity = 20000;
    _powerbank.charge = 50;
  }

  Future<void> initBluetooth() async {
    //req permission
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      await Permission.locationWhenInUse.request();
    }
    _ble = FlutterReactiveBle();
    _ble.logLevel=LogLevel.verbose;
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
      requireLocationServicesEnabled: true,
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
