import 'package:flutter/material.dart';
import 'package:smart_pb/app_theme.dart';
import 'package:smart_pb/main.dart';
import 'package:smart_pb/user_device/user_device_manager.dart';

class ChargerPage extends StatefulWidget {
  const ChargerPage({Key? key}) : super(key: key);

  @override
  State<ChargerPage> createState() => _ChargerPageState();
}

class _ChargerPageState extends State<ChargerPage> {
  @override
  void initState() {
    UserDeviceManager().getUserDevice().then((devices) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current charge: ${powerbank.charge}%',
            style: context.appTheme.largeText,
          ),
          Text(
            'Current capacity: ${powerbank.capacity} mAh',
            style: context.appTheme.largeText,
          ),
          Text(
            'Total capacity: ${powerbank.totalCapacity} mAh',
            style: context.appTheme.largeText,
          ),
          Text(
            'Connection: ${powerbank.isConnected ? 'ok' : 'disconnected'}',
            style: context.appTheme.largeText,
          ),
          Text(
            'Last connection: ${powerbank.lastPacketTime} ms',
            style: context.appTheme.largeText,
          ),
        ],
      ),
    );
  }
}
