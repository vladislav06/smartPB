import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_pb/powerbank/powerbank.dart';
import 'package:smart_pb/util/file_utils.dart';
import 'package:smart_pb/util/notification_service.dart';

/// Singleton manager, that manages powerbank instance
class PowerbankBLManager {
  PowerbankBLManager.privateConstructor() {
    _powerbank = Powerbank();
  }

  final Random _rnd = Random();

  static final PowerbankBLManager _instance =
      PowerbankBLManager.privateConstructor();

  factory PowerbankBLManager() => _instance;

  File? _file;
  static const _fileName = 'powerbank.json';
  final List<String> goofyAhNotifications = [
    'Please feed me, daddy!',
    'Senpai... Stick your charger inside of me!',
    'I need that energy drink up my ass right now!',
    'This robotized powerbank is in heat. Please, insert your cable.',
    'Fill my nasty port with your filthy USBick!',
    'Breed me with your energy, master!',
    'I\'m a whore for your big cable! Stick it in me right now!',
  ];

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

  Future<void> savePowerbank() async {
    final File fl = await file;
    await fl.writeAsString(jsonEncode(_powerbank));
  }

  /// Load [powerbank] from storage
  Future<void> loadPowerbank() async {
    print('loadPowerbank');
    final File fl = await file;
    final content = await fl.readAsString();

    try {
      Map<String, dynamic> data = jsonDecode(content);
      _powerbank.fromJson(data);
    } catch (e) {
      print(e);
    }
    _powerbank.totalCapacity = 20000;
    _powerbank.addListener(() async {
      await fl.writeAsString(jsonEncode(_powerbank));
    });
  }

  Future<void> initBluetooth() async {
    //req permission
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      await Permission.locationWhenInUse.request();
    }
    _ble = FlutterReactiveBle();
    _ble.logLevel = LogLevel.verbose;
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
          savePowerbank();
          if (powerbank.charge < 20) {
            NotificationService().showNotifications(
                'SmartPB',
                goofyAhNotifications[
                    _rnd.nextInt(goofyAhNotifications.length - 1)]);
          }
        }, onError: (dynamic error) {});
      }
    }, onError: (dynamic error) {
      // Handle a possible error
    });
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
}
