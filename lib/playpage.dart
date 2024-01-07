import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:karaoke/widgets.dart';
import 'variables.dart';
import 'homepage.dart';


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
  RegExp regex = RegExp(r'\[(\d+):(\d+\.\d+)\]"?(.*?)"?');

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

  List<Lyric> _lyrics = [];
  String mp3Url = '';
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _finished = false;
  Duration _duration = Duration();
  Duration _position = Duration();

  int getCurrentLine() {
    for (int i = 0; i < _lyrics.length - 1; i++) {
      if (_position.inMilliseconds >= _lyrics[i].timestamp.inMilliseconds &&
          _position.inMilliseconds < _lyrics[i + 1].timestamp.inMilliseconds) {
        return i;
      }
    }
    return _lyrics.length - 1;
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

      int newCurrentLine = getCurrentLine();
      if (newCurrentLine != _currentLine) {
        setState(() {
          _currentLine = newCurrentLine;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _finished = true;
      });
    });

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
            child: ListView.separated(
              itemCount: _lyrics.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                bool isCurrentLine = index == _currentLine;

                return ListTile(
                  title: Text(
                    _lyrics[index].text,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: isCurrentLine
                          ? AppColors.mainColor
                          : Colors.white,
                      fontWeight: isCurrentLine
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          Slider(
            activeColor: AppColors.mainColor,
            inactiveColor: Colors.purple[50],
            value: _position.inMilliseconds.toDouble(),
            min: 0.0,
            max: _duration.inMilliseconds.toDouble(),
            onChanged: (double value) {
              _audioPlayer.seek(Duration(milliseconds: value.toInt()));
            },
          ),
          Row(
            children: [
              SizedBox(width: 25.0),
              Text(_positionText ?? '0:00', style: AppStyles.listText),
              Spacer(),
              Text(_durationText ?? '0:00', style: AppStyles.listText),
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
          )
        ],
      ),
    );
  }
}
