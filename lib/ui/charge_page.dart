import 'package:flutter/material.dart';
import 'package:smart_pb/app_theme.dart';
import 'package:smart_pb/user_device/user_device.dart';
import 'package:smart_pb/user_device/user_device_manager.dart';
import 'package:smart_pb/user_device/user_device_widget.dart';

class ChargePage extends StatefulWidget {
  const ChargePage({Key? key}) : super(key: key);

  @override
  State<ChargePage> createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  @override
  void initState() {
    UserDeviceManager().getUserDevice().then((devices) {
   
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('alax'),
        FutureBuilder(
          future: UserDeviceManager().getUserDevice(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Spacer();
            var devices = snapshot.data as List<UserDevice>;
            return Column(
              children: devices
                  .map((dev) => Padding(
                        padding: context.appTheme.padding,
                        child: UserDeviceWidget(device: dev),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
