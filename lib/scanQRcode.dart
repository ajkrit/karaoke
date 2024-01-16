import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:karaoke/variables.dart';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {

  var qrCodeResult = "Not Yet Scanned";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text("Scan QR Code"),
        backgroundColor:AppColors.mainColor,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Message displayed over here
            Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),

            //Button to scan QR code
            TextButton(
              onPressed: () async {
                var status = await Permission.camera.request();
                if (status.isGranted){
                  var codeSanner = (await BarcodeScanner
                      .scan()); //barcode scanner
                  setState(() {
                    qrCodeResult = codeSanner.rawContent;
                  }
                );}
              },
              child: Text("Open Scanner",style: TextStyle(color: Colors.indigo[900]),),
            ),

          ],
        ),
      ),
    );
  }
}