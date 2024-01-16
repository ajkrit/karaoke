import 'dart:io';
import 'package:flutter/material.dart';
import 'package:karaoke/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late List<VideoPlayerController> _controllers;
  late bool _vibrations = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _loadVibrations();
  }

  Future<void> _loadVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String videosPath = prefs.getString('videosPath') ?? '';

    Directory videosDir = Directory(videosPath);
    if (videosDir.existsSync()) {
      List<FileSystemEntity> videoFiles = videosDir.listSync();

      // Sort videoFiles based on the last modified time in descending order
      videoFiles.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      _controllers = videoFiles.map((file) {
        return VideoPlayerController.file(File(file.path))..initialize();
      }).toList();
    } else {
      print('Videos path does not exist: $videosPath');
      _controllers = [];
    }

    setState(() {});
  }


  Future<void> _DeleteVideo(int index) async {
    String videoPath = _controllers[index].dataSource!;

    await _controllers[index].dispose();

    _controllers.removeAt(index);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String videosPath = prefs.getString('videosPath') ?? '';
    File videoFile = File(videoPath);

    if (videoFile.existsSync()) {
      await videoFile.delete();
    }

    setState(() {});
  }


  Future<void> _loadVibrations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? vibrations = prefs.getBool('vibrations');
    setState(() {
      _vibrations = vibrations ?? true;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MyAppBar(),
      backgroundColor: AppColors.backgroundColor,
      body: _controllers == null
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          return VideoTile(
            controller: _controllers[index],
            onLongPress: () => _showDeleteVideoDialog(index),
            vibrations: _vibrations,
          );
        },
      ),
    );
  }

  void _showDeleteVideoDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Video', style: AppStyles.purpleBoxText),
          content: Text('Are you sure you want to delete this video?', style: AppStyles.listDesc),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: AppStyles.listText),
            ),
            TextButton(
              onPressed: () async {
                await _DeleteVideo(index);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete', style: AppStyles.listText),
            ),
          ],
        );
      },
    );
  }
}

class VideoTile extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback? onLongPress;
  final bool vibrations;

  VideoTile({required this.controller, this.onLongPress, required this.vibrations});

  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.controller.value.isPlaying) {
          widget.controller.pause();
        } else {
          widget.controller.play();
        }
      },
      onLongPress: () {
        if (widget.onLongPress != null) {
          widget.onLongPress!();
        }
        if (widget.vibrations) Vibration.vibrate(duration: 200);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: VideoPlayer(widget.controller),
          ),
          if (!widget.controller.value.isPlaying)
            Icon(Icons.play_arrow, size: 50.0, color: Colors.white),
        ],
      ),
    );
  }

  @override
  void dispose() {
    //widget.controller.dispose();
    super.dispose();
  }
}
