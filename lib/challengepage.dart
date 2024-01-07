import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widgets.dart';
import 'variables.dart';

class ChallengePage extends StatefulWidget {
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    // Request Bluetooth and location permissions
    requestPermissions();

    // Get the list of connected devices at the beginning
    getConnectedDevices();
  }

  Future<void> requestPermissions() async {
    if (await Permission.bluetooth.request().isGranted &&
        await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.location.request().isGranted &&
        await Permission.bluetoothAdvertise.request().isGranted) {
      // Do nothing, permissions are granted
    } else {
      print('Permissions not granted');
    }
  }

  Future<void> getConnectedDevices() async {
    List<BluetoothDevice> connectedDevicesList =
        await flutterBlue.connectedDevices;
    if (connectedDevicesList.isNotEmpty && mounted) {
      setState(() {
        connectedDevice = connectedDevicesList.first;
      });
    }
    print(connectedDevicesList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          connectedDevice != null
              ? Text(
                  'Connected to: ${connectedDevice!.name}',
                  style: AppStyles.backgroundText,
                )
              : Text(
                  'Not connected to any device',
                  style: AppStyles.backgroundText,
                ),
        ],
      ),
      bottomNavigationBar: const MyAppBar(),
    );
  }
}
