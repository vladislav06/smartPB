import 'package:flutter/material.dart';
import 'package:smart_pb/app_theme.dart';
import 'package:smart_pb/powerbank/powerbank.dart';
import 'package:smart_pb/powerbank/powerbank_bl_manager.dart';
import 'package:smart_pb/ui/home_screen.dart';
import 'package:smart_pb/user_device/user_device.dart';
import 'package:smart_pb/user_device/user_device_manager.dart';
import 'package:smart_pb/user_device/user_device_type.dart';

late final PowerbankBLManager pbManager;
void main() {
  pbManager = PowerbankBLManager();

  //load user devices and init bluetooth after binding initialization
  Future.delayed(const Duration(milliseconds: 200)).then((value) async {
    UserDeviceManager().getUserDevice();
  //  pbManager.loadPowerbank();
    pbManager.initBluetooth();
    pbManager.connect();
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
