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
  List<BluetoothDevice> devices = [];
  List<BluetoothDevice> connectedDevices = [];
  bool isScanning = false;

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
      // Start scanning once permissions are granted
      scanForDevices();
    } else {
      print('Permissions not granted');
    }
  }

  Future<void> getConnectedDevices() async {
    List<BluetoothDevice> connectedDevicesList =
    await flutterBlue.connectedDevices;
    if (mounted) {
      setState(() {
        connectedDevices = connectedDevicesList;
      });
    }
  }

  Future<void> scanForDevices() async {
    if (mounted && await flutterBlue.isOn) {
      setState(() {
        isScanning = true;
      });

      await flutterBlue.startScan(timeout: Duration(seconds: 5));

      // Listen to scan results using StreamBuilder
      flutterBlue.scanResults.listen((List<ScanResult> results) {
        if (mounted) {
          setState(() {
            devices = results.map((result) => result.device).toList();
          });
        }
      });

      // Delay for a short duration to allow devices to be discovered
      await Future.delayed(Duration(seconds: 2));

      if (mounted) {
        setState(() {
          isScanning = false;
        });
      }
    } else {
      print('Bluetooth is not enabled');
    }
  }

  Future<void> _refreshDevices() async {
    // Check if the widget is mounted before performing any actions
    if (!mounted) {
      return;
    }

    // Clear the existing devices list
    setState(() {
      devices.clear();
      isScanning = true;
    });

    // Perform a new scan
    await flutterBlue.startScan(timeout: Duration(seconds: 5));

    // Delay for a short duration to allow devices to be discovered
    await Future.delayed(Duration(seconds: 2));

    // Check if the widget is mounted before calling setState
    if (mounted) {
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      print('Connected to ${device.name}');
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        color: AppColors.mainColor,
        onRefresh: _refreshDevices,
        child: Column(
          children: [
            Expanded(
              child: isScanning
                  ? const Center(
                child: Text(
                  'Scanning for devices...',
                  style: AppStyles.backgroundText,
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 80.0, bottom: 30.0),
                    child: Text(
                      'Nearby devices',
                      textAlign: TextAlign.center,
                      style: AppStyles.backgroundText,
                    ),
                  ),
                  Container(
                    height: 500,
                    child: ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        return ListItem(
                          text: devices[index].name.isNotEmpty
                              ? devices[index].name
                              : 'Unknown Device',
                          desc: devices[index].id.id,
                          icon: 'images/ok.png',
                          onPressed: () {
                            _connectToDevice(devices[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyAppBar(),
    );
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }
}
