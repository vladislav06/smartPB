import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_pb/app_theme.dart';
import 'package:smart_pb/user_device/user_device.dart';
import 'package:smart_pb/user_device/user_device_type.dart';

class DeviceSettingsScreen extends StatefulWidget {
  const DeviceSettingsScreen({Key? key, required this.device})
      : super(key: key);
  final UserDevice device;

  @override
  State<DeviceSettingsScreen> createState() => _DeviceSettingsScreenState();
}

class _DeviceSettingsScreenState extends State<DeviceSettingsScreen> {
  late TextEditingController nameController;
  late TextEditingController capacityController;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.device.name);
    nameController.addListener(() {
      widget.device.name = nameController.text;
    });

    capacityController =
        TextEditingController(text: widget.device.capacity.toString());
    capacityController.addListener(() {
      widget.device.capacity = int.tryParse(capacityController.text) ?? 0;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Device settings")),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  widget.device.deviceType.icon,
                  size: 80,
                ),
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<UserDeviceType>(
                          value: widget.device.deviceType,
                          items: UserDeviceType.values
                              .map<DropdownMenuItem<UserDeviceType>>(
                                  (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ))
                              .toList(),
                          onChanged: (type) {
                            setState(() {
                              widget.device.deviceType = type!;
                            });
                          }),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "name",
                        ),
                        controller: nameController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: context.appTheme.padding,
              child: TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: "Capacity"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK')),
          ],
        ),
      ),
    );
  }
}
