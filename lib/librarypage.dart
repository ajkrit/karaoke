import 'package:flutter/material.dart';
import 'package:karaoke/widgets.dart';
import 'downloadpage.dart';
import 'variables.dart';
import 'videopage.dart';


class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: const MyAppBar(),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose what to display',
                style: AppStyles.backgroundText,
              ),
              SizedBox(height: 40.0),
              Container(
                height: 150.0,
                width: 150.0,
                child: SquareButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPage()));},
                    icon: 'images/camera-photo.png',
                    label: 'Videos'),
              ),
              SizedBox(height: 30.0),
              Container(
                height: 150.0,
                width: 150.0,
                child: SquareButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => DownloadPage()));},
                    icon: 'images/mic.png',
                    label: 'Songs'),
              ),
            ]
        ),
      ),
    );
  }
}
