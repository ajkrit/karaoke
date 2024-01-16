import 'package:flutter/material.dart';
import 'package:karaoke/variables.dart';
import 'package:karaoke/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'playpage.dart';

class GenerateQR extends StatefulWidget {
  final Song song;

  const GenerateQR({Key? key,required this.song}) :super(key:key);

  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  late String qrData = widget.song.id;
  late Song mysong = widget.song;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body:Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Share this song with your friends!',
                style: AppStyles.backgroundText,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.0),
              Container(
                height: 350,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23.0),
                color: AppColors.mainColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    QrImageView(
                      backgroundColor: AppColors.whiteColor,
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 20 ,),
                    IconButton(
                        onPressed:() {
                          try {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PlayPage(song: mysong, handshake: true)),
                            );
                          } catch (e) {
                            print('Error navigating to PlayPage: $e');
                          }
                        },
                        icon: Image.asset('images/play-gold.png',
                          scale: 1,)
                    )
                  ],
                ),
              ),
            ],
          )
      ),
      bottomNavigationBar: const MyAppBar(),
    );
  }
}
