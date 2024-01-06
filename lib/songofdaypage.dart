import 'package:flutter/material.dart';
import 'package:karaoke/widgets.dart';
import 'package:scratcher/scratcher.dart';
import 'variables.dart';
import 'package:intl/intl.dart';
import 'songspage.dart';

class SongOfDayPage extends StatefulWidget {
  @override
  _SongOfDayPageState createState() => _SongOfDayPageState();
}

class _SongOfDayPageState extends State<SongOfDayPage> {
  List<Song> _songs = [];
  double _opacity = 0.0;
  late int _random;

  int _generate(int len) {
    if (len > 0) {
      DateTime currentDate = DateTime.now();
      String formattedDate = DateFormat('yyyyMMdd').format(currentDate);

      int dateAsInteger = int.parse(formattedDate);
      int sumOfDigits =
      dateAsInteger.toString().split('').map(int.parse).reduce((a, b) => a + b);

      int randomId = sumOfDigits % len;
      return randomId;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      _songs = await fetchSongs(id: '0', language: '', genre: '');
      print('Songs loaded successfully: $_songs');
      setState(() {
        _random = _generate(_songs.length);
        _opacity = 1;
      });
    } catch (error) {
      print('Error loading songs: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80.0),
            Image.asset('images/The Band Band.png'),
            const Text(
              'Scratch to reveal today\'s pick',
              style: AppStyles.backgroundText,
            ),
            const SizedBox(height: 30.0),
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
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
                  duration: Duration(),
                  opacity: _opacity,
                  child: Container(
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
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
                                        _songs.isEmpty ? "Loading..." : _songs[_random].title,
                                        style: AppStyles.listText,
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        _songs.isEmpty ? "Loading..." : _songs[_random].artist,
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
