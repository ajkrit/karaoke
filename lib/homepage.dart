import 'package:flutter/material.dart';
import 'package:karaoke/playpage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'widgets.dart';
import 'variables.dart';
import 'profilepage.dart';
import 'settingspage.dart';
import 'songofdaypage.dart';
import 'genrepage.dart';
import 'scanQRcode.dart';
import 'librarypage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ElevatedButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));},
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      shape: const CircleBorder(),
                    ),
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.whiteColor,
                      ),
                      child: Center(
                        child: Image.asset('images/account-large.png'),
                      ),
                    ),
                  ),
                    const SizedBox(width: 20.0), // Adjust the width as needed for the desired spacing
                    ElevatedButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));},
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      shape: const CircleBorder(),
                    ),
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.whiteColor,
                      ),
                      child: Center(
                        child: Image.asset('images/settings-large.png'),
                      ),
                    ),
                  )
                ],
                ),
              ),
              const Text(
                'Karaoke',
                style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0
                ),
              ),
              Expanded(
                child:
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 20
                    ),
                    children: [
                      SquareButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SongOfDayPage()));}, icon: 'images/cup.png', label: 'Song of Day'),
                      SquareButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => GenrePage()));}, icon: 'images/mic.png', label: 'Songs'),
                      SquareButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => LibraryPage()));}, icon: 'images/favorites.png', label: 'Library'),
                      SquareButton(onPressed: () async {
                        var status = await Permission.camera.request();
                        if (status.isGranted){
                          var codeSanner = (await BarcodeScanner
                              .scan()); //barcode scanner
                          if (codeSanner != null && codeSanner.rawContent.isNotEmpty) {
                            var songid = codeSanner.rawContent;
                            var scannedSong = await fetchSongs(
                                id: songid, language: "", genre: "");
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    PlayPage(song: scannedSong[0])));
                          }
                          };
                        },
                          icon: 'images/qr-scan.png', label: 'Scan Qr')
                    ],
                  ),
                )
              )
            ]
        ),
      ),
    );
  }
}