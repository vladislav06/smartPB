import 'dart:convert';
import 'dart:io';

import 'package:smart_pb/user_device/user_device.dart';
import 'package:smart_pb/util/file_utils.dart';

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

    _file = await initFile(_fileName);
    return _file!;
  }

  void saveUserDevices() async {
    final File fl = await file;
    await fl.writeAsString(jsonEncode(_userDevices));
    print('saveDevice');
  }

  Future<List<UserDevice>> getUserDevice() async {
    if (_userDevices != null) return _userDevices!;

    print('loadDevice');
    _userDevices = [];
    final File fl = await file;
    final content = await fl.readAsString();

   // try {
      List<dynamic> data = jsonDecode(content);

      _userDevices = data.map((e) {
        UserDevice device = UserDevice();
        device.fromJson(e);
        return device;
      }).toList();
      print(jsonEncode(_userDevices));
    // } on FormatException catch (e) {
    //   print(e);
    //   return [];
    // }
    return _userDevices!;
  }
}
