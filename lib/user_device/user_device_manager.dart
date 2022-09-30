import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:smart_pb/user_device/user_device.dart';
import 'package:smart_pb/user_device/user_device_type.dart';

/// User device manager, manages user devices, loads and saves them
class UserDeviceManager {
  List<UserDevice>? _userDevices;

  UserDeviceManager.privateConstructor();

  static final UserDeviceManager _instance =
      UserDeviceManager.privateConstructor();

  factory UserDeviceManager() => _instance;

  File? _file;
  static const _fileName = 'saved_presets.json';

  // Get the data file
  Future<File> get file async {
    if (_file != null) return _file!;

    _file = await _initFile();
    return _file!;
  }

  // Initialize file
  Future<File> _initFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/$_fileName');
    //create file if don't exist
    if (!(await file.exists())) {
      await file.create();
    }
    return file;
  }

  void saveUserDevices() async {
    final File fl = await file;
    await fl.writeAsString(jsonEncode(_userDevices));
  }

  Future<List<UserDevice>> getUserDevice() async {
    if (_userDevices != null) return _userDevices!;

    _userDevices = [];
    final File fl = await file;
    final content = await fl.readAsString();

    try {
      List data = jsonDecode(content);
      _userDevices = data.map((e) {
        UserDevice device = UserDevice();
        device.capacity = e['capacity'];
        device.name = e['name'];
        device.deviceType = UserDeviceType.fromJson(e['deviceType']);
        return device;
      }).toList();
    } on FormatException catch (e) {
      print(e);
      return [];
    }
    return _userDevices!;
  }
}
