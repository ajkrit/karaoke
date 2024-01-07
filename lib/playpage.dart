import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:karaoke/widgets.dart';
import 'variables.dart';
import 'homepage.dart';
import 'dart:async';


class Lyric {
  final Duration timestamp;
  final String text;

  Lyric({required this.timestamp, required this.text});
}

List<Lyric> parseLRC(String lrcText) {
  List<Lyric> lyrics = [];

  // Replace 2 or more consecutive newlines with a single newline
  lrcText = lrcText.replaceAll(RegExp(r'\n{2,}'), '\n');

  // Remove leading and trailing newlines
  lrcText = lrcText.trim();

  // Regular expression to match timestamp and lyrics
  RegExp regex = RegExp(r'^"?\[(\d+):(\d+\.\d+)\]"?(.*?)"?$');

  for (String line in lrcText.split('\n')) {
    // Try to match the line with the regular expression
    Match? match = regex.firstMatch(line);

    if (match != null) {
      // Extract timestamp and lyrics
      int minutes = int.parse(match.group(1)!);
      double seconds = double.parse(match.group(2)!);

      // Split seconds into integer part and decimal part
      int secondsIntegerPart = seconds.toInt();
      int milliseconds = ((seconds - secondsIntegerPart) * 1000).round();

      Duration timestamp = Duration(
        minutes: minutes,
        seconds: secondsIntegerPart,
        milliseconds: milliseconds,
      );

      String lyricsText = match.group(3)!;

      // Create Lyric object and add to the list
      Lyric lyric = Lyric(timestamp: timestamp, text: lyricsText.trim());
      print(lyric.text);
      lyrics.add(lyric);
    }
  }

  return lyrics;
}


String _formatDuration(Duration duration) {
  int minutes = duration.inMinutes;
  int seconds = (duration.inSeconds % 60);
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}



class PlayPage extends StatefulWidget {
  final Song song;

  const PlayPage({Key? key, required this.song}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late AudioPlayer _audioPlayer;
  late Source _audioUrl;
  late String _positionText = '';
  late String _durationText;
  late int _currentLine;

  Timer? _timer;
  List<Lyric> _lyrics = [];
  String mp3Url = '';
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _finished = false;
  Duration _duration = Duration();
  Duration _position = Duration();

  void _startTimer() {
    const Duration checkInterval = Duration(milliseconds: 50);

    _timer = Timer.periodic(checkInterval, (timer) {
      if (_position >= _lyrics[_currentLine].timestamp) {
        setState(() {
          _currentLine += 1;
        });
        //print('Current Line: $_currentLine, Timestamp: ${_lyrics[_currentLine].timestamp}, Lyric: ${_lyrics[_currentLine].text}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _lyrics = parseLRC(widget.song.lyrics);
    _audioPlayer = AudioPlayer();
    _audioUrl = UrlSource('${drive_path}${widget.song.sound_path}');
    _currentLine = 0;

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      if (duration.inMilliseconds > 0) {
        setState(() {
          _isLoading = false;
          _isPlaying = true;
          _duration = duration;
          _durationText = _formatDuration(duration);
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
        _positionText = _formatDuration(position);
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _finished = true;
      });
    });

    _audioPlayer.play(_audioUrl);

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: const MyAppBar(),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.purple[50],
          color: AppColors.mainColor,
        ),
      )
          : Column(
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
          Expanded(
            child: ListView.builder(
              itemCount: _lyrics.length,
              itemBuilder: (context, index) {
                bool isCurrentLine = (index + 1) == _currentLine;

                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        _lyrics[index].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isCurrentLine ? 18.0 : 16.0,
                          color: isCurrentLine
                              ? AppColors.mainColor
                              : Colors.white,
                          fontWeight: isCurrentLine
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isCurrentLine)
                      Divider(
                        height: 0,
                        thickness: 0,
                      ),
                  ],
                );
              },
            ),
          ),
          Slider(
            activeColor: AppColors.mainColor,
            inactiveColor: Colors.purple[50],
            value: _position.inMilliseconds.toDouble().clamp(0.0, _duration.inMilliseconds.toDouble()),
            min: 0.0,
            max: _duration.inMilliseconds.toDouble(),
            onChanged: (double value) {
              _audioPlayer.seek(Duration(milliseconds: value.toInt()));
            },
          ),
          Row(
            children: [
              SizedBox(width: 25.0),
              Text(_positionText, style: AppStyles.listText),
              Spacer(),
              Text(_durationText, style: AppStyles.listText),
              SizedBox(width: 25.0),
            ],
          ),
          IconButton(
            onPressed: () {
              if (_finished) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else {
                if (_isPlaying) {
                  _audioPlayer.pause();
                } else {
                  _audioPlayer.resume();
                }
                setState(() {
                  _isPlaying = !_isPlaying;
                });
              }
            },
            icon: Image.asset(
              _finished ? 'images/ok.png' : (_isPlaying ? 'images/pause.png' : 'images/play.png'),
              scale: 0.5,
            ),
          ),
          SizedBox(height: 20.0)
        ],
      ),
    );
  }
}
