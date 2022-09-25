import 'package:flutter/material.dart';
import 'package:smart_pb/app_theme.dart';
import 'package:smart_pb/main.dart';
import 'package:smart_pb/user_device/user_device.dart';
import 'package:smart_pb/user_device/user_device_type.dart';

class UserDeviceWidget extends StatelessWidget {
  const UserDeviceWidget({Key? key, required this.device}) : super(key: key);

  final UserDevice device;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appTheme.colorScheme.primary,
        borderRadius: context.appTheme.radius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              device.deviceType.icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          Text(
            device.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${(powerbank.capacity / device.capacity).toString()} ',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
