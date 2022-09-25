import 'package:flutter/material.dart';

enum UserDeviceType {
  phone,
  earphones,
  smartWatch,
  custom,
  none,
}

extension UserDeviceTypeIcon on UserDeviceType {
  IconData get icon {
    switch (this) {
      case UserDeviceType.phone:
        return Icons.phone_android;
      case UserDeviceType.earphones:
        return Icons.earbuds;
      case UserDeviceType.smartWatch:
        return Icons.watch;
      case UserDeviceType.custom:
        return Icons.devices;
      case UserDeviceType.none:
        return Icons.device_unknown;
    }
  }
}
