import 'package:flutter/material.dart';
import 'package:smart_pb/app_theme.dart';
import 'package:smart_pb/powerbank/powerbank.dart';
import 'package:smart_pb/ui/home_screen.dart';
import 'package:smart_pb/user_device/user_device.dart';
import 'package:smart_pb/user_device/user_device_manager.dart';
import 'package:smart_pb/user_device/user_device_type.dart';

final Powerbank powerbank = Powerbank();

void main() {
  powerbank.totalCapacity = 20000;
  powerbank.charge = 50;

  UserDevice device = UserDevice();
  device.capacity = 2000;
  device.name = 'phone';
  device.deviceType = UserDeviceType.phone;
  Future.delayed(const Duration(milliseconds: 200)).then((value) {
    UserDeviceManager().getUserDevice();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppTheme(
        child: MaterialApp(
      title: "SmartPB",
      theme: AppThemeData(context).materialTheme,
      home: const HomeScreen(),
    ));
  }
}
