import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:karaoke/widgets.dart';
import 'variables.dart';
import 'widgets.dart';

class PlayPage extends StatefulWidget {
  final Song song;

  const PlayPage({Key? key, required this.song}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late AudioPlayer _audioPlayer;
  late Source _audioUrl;
  String mp3Url = '';
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioUrl = UrlSource('${drive_path}${widget.song.sound_path}');
    _audioPlayer.play(_audioUrl);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: const MyAppBar(),
      body: Column(
        children: [
          SizedBox(height: 30.0),
          Row(
            children: [
              Image.asset('images/The Band Guitar.png'),
              Text(
                'Lyrics',
                style: AppStyles.backgroundText,
              ),
            ],
          ),
          // Play the MP3 using AudioPlayer
          IconButton(
            onPressed: () {
              if (!_isPlaying) {
                _audioPlayer.resume();
                setState(() {
                  _isPlaying = true;
                });
              }
              else {
                _audioPlayer.pause();
                setState(() {
                  _isPlaying = false;
                });
              }
            },
            icon: Image.asset(_isPlaying ? 'images/pause.png' : 'images/play.png', scale: 0.5),
          ),
        ],
      ),
    );
  }
}
