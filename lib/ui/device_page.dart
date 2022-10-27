import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_pb/app_theme.dart';
import 'package:smart_pb/powerbank/powerbank.dart';
import 'package:smart_pb/ui/device_settings_screen.dart';
import 'package:smart_pb/user_device/user_device.dart';
import 'package:smart_pb/user_device/user_device_manager.dart';
import 'package:smart_pb/user_device/user_device_widget.dart';
import 'package:provider/provider.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          openEditor(UserDevice()).then((dev) async {
            var list = await UserDeviceManager().getUserDevice();
            list.add(dev);
            setState(() {});
            UserDeviceManager().saveUserDevices();
          });
        },
      ),
      extendBody: true,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<Powerbank>(
              builder: (context, powerbank, child) => FutureBuilder(
                future: UserDeviceManager().getUserDevice(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Spacer();
                  var devices = snapshot.data as List<UserDevice>;
                  return Column(
                    children: devices
                        .map((dev) => Padding(
                              padding: context.appTheme.padding,
                              child: UserDeviceWidget(
                                device: dev,
                                onTap: () {
                                  openEditor(dev).then((value) {
                                    setState(() {});
                                    UserDeviceManager().saveUserDevices();
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<UserDevice> openEditor(UserDevice device) {
    Completer<UserDevice> completer = Completer();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DeviceSettingsScreen(
            device: device,
          );
        },
      ),
    ).then((value) {
      completer.complete(device);
    });
    return completer.future;
  }
}
