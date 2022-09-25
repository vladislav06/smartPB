import 'package:smart_pb/user_device/user_device_type.dart';

/// User defined device
class UserDevice {
  /// Name of device
  String name = '';

  /// Capacity of device
  int capacity = 0;

  /// Type of device, defines icon
  UserDeviceType deviceType = UserDeviceType.none;
}
