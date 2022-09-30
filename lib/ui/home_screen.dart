import 'package:flutter/material.dart';
import 'package:smart_pb/ui/charge_page.dart';
import 'package:smart_pb/ui/device_page.dart';
import 'package:smart_pb/ui/about_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Widget'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.developer_board_outlined),
              ),
              Tab(
                icon: Icon(Icons.devices),
              ),
              Tab(
                icon: Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ChargerPage(),
            DevicePage(),
            AboutPage(),
          ],
        ),
      ),
    );
  }
}
