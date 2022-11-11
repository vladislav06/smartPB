import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_pb/app_theme.dart';
import 'package:smart_pb/powerbank/powerbank_bl_manager.dart';
import 'package:smart_pb/ui/home_screen.dart';
import 'package:smart_pb/user_device/user_device_manager.dart';
import 'package:smart_pb/util/notification_service.dart';

late final PowerbankBLManager pbManager;

void main() {
  pbManager = PowerbankBLManager();
  // init bindings
  //WidgetsFlutterBinding.ensureInitialized();
  Future.delayed(const Duration(milliseconds: 300)).then((value) {
    init();
  });

  runApp(const MyApp());
}

void init() async {
  print('init+++++++++++++++++++++++++++++++++');
  // init notification
  await NotificationService().init();

  //load user devices
  await UserDeviceManager().getUserDevice();
  // init, load and connect to powerbank
  await pbManager.loadPowerbank();
  await pbManager.initBluetooth();
  await pbManager.connect();
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

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}
