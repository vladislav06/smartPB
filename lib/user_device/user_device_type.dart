import 'package:flutter/material.dart';

enum UserDeviceType {
  phone(Icons.phone_android),
  earphones(Icons.earbuds),
  smartWatch(Icons.watch),
  custom(Icons.devices),
  none(Icons.device_unknown);

  final IconData icon;

  const UserDeviceType(this.icon);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  static fromJson(Map<String, dynamic> json) {
    //find type by name
    return UserDeviceType.values.firstWhere(
        (element) => element.name == json['name'],
        orElse: () => UserDeviceType.phone);
  }
}
