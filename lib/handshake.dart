import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShakeDetector(),
    );
  }
}

class ShakeDetector extends StatefulWidget {
  @override
  _ShakeDetectorState createState() => _ShakeDetectorState();
}

class _ShakeDetectorState extends State<ShakeDetector> {
  final shakeThreshold = 10.0; // Adjust the threshold as needed
  late AccelerometerEvent _lastEvent = AccelerometerEvent(0, 0, 0);
  int shakeCount = 0;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((event) {
      print('Accelerometer Event: $event');
      if (_lastEvent != null) {
        final delta = event.x - _lastEvent.x;
        print('Delta: $delta');
        if (delta.abs() > shakeThreshold) {
          // Shake detected!
          print("Shake detected!");
          shakeCount++;
          if (shakeCount >= 5) {

          }
        }
      }
      _lastEvent = event;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shake Detector App'),
      ),
      body: Center(
        child: Text('Shake the device to see the detection in the console.'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
