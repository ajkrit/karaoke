import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'variables.dart';
import 'playpage.dart';

class ScanQRCodePage extends StatefulWidget {
  const ScanQRCodePage({Key? key});

  @override
  State<ScanQRCodePage> createState() => _ScanQRCodePageState();
}

class _ScanQRCodePageState extends State<ScanQRCodePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _scan() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      var codeScanner = await BarcodeScanner.scan();
      if (codeScanner != null && codeScanner.rawContent.isNotEmpty) {
        var songId = codeScanner.rawContent;
        var scannedSong = await fetchSongs(
          id: songId,
          language: "",
          genre: "",
        );
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlayPage(song: scannedSong[0], handshake: true),
          ),
        );
      } else {
        Navigator.pop(context); // Close the page.
      }
    } else {
      Navigator.pop(context); // Close the page.
    }
  }

  @override
  Widget build(BuildContext context) {
    _scan();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.purple[50],
              color: AppColors.mainColor,
            ),
          ],
        ),
      ),
    );
  }
}
