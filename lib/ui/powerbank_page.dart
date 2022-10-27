import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_pb/app_theme.dart';
import 'package:smart_pb/main.dart';
import 'package:smart_pb/powerbank/powerbank.dart';
import 'package:smart_pb/user_device/user_device_manager.dart';
import 'package:provider/provider.dart';

class PowerbankPage extends StatefulWidget {
  const PowerbankPage({Key? key}) : super(key: key);

  @override
  State<PowerbankPage> createState() => _PowerbankPageState();
}

class _PowerbankPageState extends State<PowerbankPage> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current charge: ${pbManager.powerbank.charge.toStringAsFixed(1)}%',
            style: context.appTheme.largeText,
          ),
          Text(
            'Current capacity: ${pbManager.powerbank.capacity} mAh',
            style: context.appTheme.largeText,
          ),
          Text(
            'Total capacity: ${pbManager.powerbank.totalCapacity} mAh',
            style: context.appTheme.largeText,
          ),
          Text(
            'Connection: ${pbManager.powerbank.isConnected ? 'ok' : 'disconnected'}',
            style: context.appTheme.largeText,
          ),
          Text(
            'Last update: ${DateTime.now().millisecondsSinceEpoch - pbManager.powerbank.lastUpdateTime < 5000 ? 'now' : '${((DateTime.now().millisecondsSinceEpoch - pbManager.powerbank.lastUpdateTime) / (1000 * 3600)).toStringAsFixed(1)} hr'}',
            style: context.appTheme.largeText,
          ),
        ],
      ),
    );
  }
}
