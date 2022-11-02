import 'package:smart_pb/user_device/user_device_type.dart';

/// User defined device
class UserDevice {
  UserDevice();

  UserDevice.from(this.name, this.capacity, this.deviceType);

  fromJson(Map<String, dynamic> json) {
    name = json['name'];
    capacity = json['capacity'];
    deviceType = UserDeviceType.fromJson(json['deviceType']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'capacity': capacity,
      'deviceType': deviceType,
    };
  }

  /// Name of device
  String name = '';

  /// Capacity of device
  int capacity = 0;

  /// Type of device, defines icon
  UserDeviceType deviceType = UserDeviceType.none;
}
