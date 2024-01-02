import 'package:flutter/material.dart';
import 'package:karaoke/widgets.dart';
import 'package:scratcher/scratcher.dart';
import 'variables.dart';

class SongOfDayPage extends StatefulWidget {
  @override
  _SongOfDayPageState createState() => _SongOfDayPageState();
}

class _SongOfDayPageState extends State<SongOfDayPage> {
  double _opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80.0),
            Image.asset('images/The Band Band.png'),
            Text(
              'Scratch to reveal today\'s pick',
              style: AppStyles.backgroundText,
            ),
            SizedBox(height: 30.0),
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: AppColors.whiteColor, // Adjust background color as needed
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Scratcher(
                color: AppColors.mainColor,
                accuracy: ScratchAccuracy.low,
                threshold: 0,
                brushSize: 40,
                onThreshold: () {
                  setState(() {
                    _opacity = 1;
                  });
                },
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 250),
                  opacity: _opacity,
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'The song of the day is:',
                          style: AppStyles.dailySongText,
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            SizedBox(width: 10.0),
                            Image.asset('images/The Band Standing Microphone.png'),
                            Column(
                              children: [
                                Text(
                                  'Title',
                                  style: AppStyles.listText,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  'Artist',
                                  style: AppStyles.listDesc,
                                  textAlign: TextAlign.left,
                                ),
                              ]
                            ),
                            Spacer(),
                            IconButton(onPressed: () {}, icon: Image.asset('images/play-gold.png')),
                            SizedBox(width: 10.0)
                            ],
                        )
                      ]
                    )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyAppBar(),
    );
  }
}