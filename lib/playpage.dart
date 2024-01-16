import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:karaoke/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'variables.dart';
import 'homepage.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:gal/gal.dart';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';


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
  final bool handshake;

  const PlayPage({Key? key, required this.song, this.handshake = false}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late CameraController _cameraController;
  late AudioPlayer _audioPlayer;
  late AudioRecorder _audioRecord;
  late Source _audioUrl;
  late String _positionText = '';
  late String _durationText;
  late int _currentLine;
  late Duration _recordStartTime;
  late Duration _recordStopTime;
  late bool handshake = widget.handshake;

  Timer? _timer;
  List<Lyric> _lyrics = [];
  String mp3Url = '';
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _finished = false;
  bool _isRecording = false;
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
    _initPlayer();
    _initCamera();
    _audioRecord = AudioRecorder();
  }


  Future<void> _initCamera() async {
    List<CameraDescription> cameras = await availableCameras();

    CameraDescription selectedCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(selectedCamera, ResolutionPreset.medium);
    await _cameraController.initialize();
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (!_isRecording) {
      if (await Permission.camera.request().isGranted &&
          await Permission.microphone.request().isGranted) {

        Directory appCacheDir = await getApplicationCacheDirectory();
        String folderPath = appCacheDir.path;
        String filePath = '$folderPath/audio_recording.wav';

        RecordConfig config = RecordConfig();

        await _cameraController.startVideoRecording();
        await _audioRecord.start(config, path: filePath);

        _recordStartTime = _position;

        setState(() {
          _isRecording = true;
        });
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecording) {
      _recordStopTime = _position;

      print("\n\n\n\nSTOPPING\n\n\n\n");

      XFile videoFile = await _cameraController.stopVideoRecording();
      await _audioRecord.stop();

      print('\n\n\n\n\n\n\n\nVideo recorded at: ${videoFile.path}\n\n\n\n\n\n\n\n');

      Directory appCacheDir = await getApplicationCacheDirectory();
      String folderPath = appCacheDir.path;
      String audioPath = '$folderPath/audio_recording.wav';

      print('\n\n\n\n\n\n\n\nAudio recorded at: ${audioPath}\n\n\n\n\n\n\n\n');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? videosPath = await prefs.getString('videosPath');
      //String mp3Path = '$folderPath/karaoke/${widget.song.sound_path}.mp3';

      String timestamp = DateTime.now().toIso8601String().replaceAll(':', '');
      String videoFileName = '$videosPath/$timestamp.mp4';
      String audioFileName = '$videosPath/$timestamp.wav';


      try {
        await File(videoFile.path).rename(videoFileName);

        //await File(audioPath).rename(audioFileName);

        print('\n\n\nSUCCESS\n\n\n');
      }
      catch (e) {
        print('\n\n\nERROR\n\n\n');
      }

      //String outputPath = await mergeVideoAndAudio(videoPath, filePath, mp3Path);

      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<String> mergeVideoAndAudio(String videoPath, String audioPath, String mp3Path) async {
    print("\n\n\n\nMERGING\n\n\n\n\n");
    final FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? videosPath = prefs.getString('videosPath');

    Directory tempDir = await getTemporaryDirectory();
    String tempAudioPath = '${tempDir.path}/audio_recording.wav';
    String tempSongPath = '${tempDir.path}/song.wav';

    int startMillis = _recordStartTime.inMilliseconds;
    int stopMillis = _recordStopTime.inMilliseconds;
    print('$startMillis \n\n\n\n $stopMillis');

    /*String extractCommand =
        '-i $mp3Path -ss ${startMillis / 1000} -to ${stopMillis / 1000} -c copy $tempSongPath';
    int extractResult = await flutterFFmpeg.execute(extractCommand);

    if (extractResult != 0) {
      print('Failed to extract portion from MP3 file');
      return '';
    }*/

    String timestamp = DateTime.now().toIso8601String().replaceAll(':', '');

    String outputPath = '$videosPath/$timestamp.mp4';

    String mergeCommand = '-i $videoPath -i $tempAudioPath -c:v copy -c:a aac -strict experimental $outputPath';
    int mergeResult = await flutterFFmpeg.execute(mergeCommand);

    if (mergeResult == 0) {
      print('\n\n\n\nVideo and audio merged successfully\n\n\n\n\n');
      print(outputPath);
      return outputPath;
    } else {
      print('Failed to merge video and audio');
      return '';
    }
  }


  void _initPlayer() async {
    AudioPlayer cricketPlayer = AudioPlayer();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool vibrations = prefs.getBool('vibrations') ?? true;
    bool sounds = prefs.getBool('sounds') ?? true;


    if (sounds) {
      String audioAsset = "sounds/cricket.mp3";

      Uint8List soundBytes = (await rootBundle.load(audioAsset)).buffer.asUint8List();

      await cricketPlayer.play(
        BytesSource(Uint8List.fromList(soundBytes)),
      );
      print("\n\n\n\nCRICKET\n\n\n\n");
    }

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
        if (sounds) {cricketPlayer.stop();}
        _position = position;
        _positionText = _formatDuration(position);
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _finished = true;
        if (vibrations) Vibration.vibrate(duration: 500);
      });
    });

    if (vibrations) Vibration.vibrate(duration: 500);

    String? folderPath = prefs.getString('folderPath');
    var file = File('$folderPath/${widget.song.sound_path}.mp3');
    print(file);

    if (file.existsSync()) {
      print("\n\n\n\nPlaying locally...\n\n\n\n");
      _audioPlayer.play(DeviceFileSource(file.path));
    } else {
      print("\n\n\n\nPlaying from URL...\n\n\n\n");
      _audioPlayer.play(_audioUrl);
    }

    await _audioPlayer.pause();

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                _finished
                    ? Container(
                  width: 24.0,
                  height: 24.0,
                )
                    : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset('images/back.png'),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    if (_finished) {
                      if (!handshake) {Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );}
                      else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ShakePopup();
                          },
                        );
                      }
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
                    _finished
                        ? 'images/ok.png'
                        : (_isPlaying ? 'images/pause.png' : 'images/play.png'),
                    scale: 0.5,
                  ),
                ),
                Spacer(),
                _finished
                    ? Container(
                  width: 24.0,
                  height: 24.0,
                )
                    : IconButton(
                  onPressed: () {
                    if (!_isRecording) {_startRecording();}
                    else {_stopRecording();}
                  },
                  icon: Image.asset(!_isRecording ? 'images/camera-photo.png' : 'images/save.png'),
                )
              ],
            ),
          ),
          SizedBox(height: 20.0)
        ],
      ),
    );
  }
}



class ShakePopup extends StatefulWidget {

  @override
  _ShakePopupState createState() => _ShakePopupState();
}

class _ShakePopupState extends State<ShakePopup> {
  late bool _vibrations;
  final shakeThreshold = 10.0;
  int cnt = 0;
  late StreamSubscription<AccelerometerEvent> accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    startShakeDetection();
  }

  void startShakeDetection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _vibrations = prefs.getBool('vibrations') ?? true;

    accelerometerSubscription = accelerometerEvents.listen((event) {
      final delta = event.x;
      if (delta.abs() > shakeThreshold) {
        print("Shake detected!");
        cnt += 1;
        if (cnt == 5) {
          stopShakeDetection();
          if (_vibrations) Vibration.vibrate(duration: 500);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    });
  }

  void stopShakeDetection() {
    accelerometerSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            title: Text("${handshakePhrases[Random().nextInt(handshakePhrases.length)]}", style: AppStyles.scoreText),
          ),
          SizedBox(height: 40.0),
          AlertDialog(
            icon: Image.asset('images/shake.png'),
            title: Text("Shake your phone", style: AppStyles.backgroundText),
          )
        ]
    );
  }

  @override
  void dispose() {
    stopShakeDetection();
    super.dispose();
  }
}
