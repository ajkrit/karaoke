import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets.dart';
import 'variables.dart';
import 'playpage.dart';
import 'dart:io';
import 'dart:convert';
import 'generateQRcode.dart';

class DownloadPage extends StatefulWidget {

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<Song> _songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    List<Song> songs = await _loadSongsFromFiles();
    setState(() {
      _songs = songs;
    });
  }

  Future<List<Song>> _loadSongsFromFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? folderPath = prefs.getString('folderPath');

    try {
      final List<Song> songs = await _readSongsFromFiles(folderPath!);
      return songs;
    } catch (e) {
      print('\n\n\n\nError reading songs from files: $e\n\n\n\n');
      return [];
    }
  }

  Future<List<Song>> _readSongsFromFiles(String folderPath) async {
    List<Song> songs = [];
    print(folderPath);
    try {
      final List<FileSystemEntity> files = Directory(folderPath).listSync();

      for (var file in files) {
        print(file.path);
        //print(File(file.path).existsSync() ? 'true' : 'false');
        if (file.path.endsWith('.json')) {
          String jsonContent = await File(file.path).readAsString();
          print(jsonContent);
          Map<String, dynamic> songInfo = jsonDecode(jsonContent);

          print('ID Type: ${songInfo['id'].runtimeType}');
          print('ID Value: ${songInfo['id']}');

          print('songInfo: $songInfo');

          Song song = Song(
              id: songInfo['id'],
              title: songInfo['title'],
              artist: songInfo['artist'],
              language: songInfo['language'],
              genre: songInfo['genre'],
              lyrics: songInfo['lyrics'],
              sound_path: songInfo['sound_path']
          );
          print(song);

          songs.add(song);
        }
      }
    } catch (e) {
      print('\n\n\n\nError reading songs from JSON files: $e\n\n\n\n');
    }

    return songs;
  }


  Future<void> _removeSong(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? folderPath = prefs.getString('folderPath');

    var file1 = File('$folderPath/${_songs[index].sound_path}.mp3');
    var file2 = File('$folderPath/${_songs[index].sound_path}.json');
    if (file1.existsSync()) {
      try {
        file1.deleteSync();
        file2.deleteSync();
        print('File deleted successfully: ${file1.path}');

        setState(() {
          _songs.removeAt(index);
        });

      } catch (e) {
        print('Error deleting file: $e');
      }
      return;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: const MyAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Image.asset('images/The Band Show.png', scale: 1.5),
                SizedBox(width: 50.0),
                Text(
                  'Downloads',
                  textAlign: TextAlign.center,
                  style: AppStyles.backgroundText,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                return ListItem(
                  text: _songs[index].title,
                  desc: _songs[index].artist,
                  icon: 'images/play.png',
                  onPressed: () {
                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlayPage(song: _songs[index])),
                      );
                    } catch (e) {
                      print('Error navigating to PlayPage: $e');
                    }
                  },
                  icon2: 'images/delete.png',
                  onPressed2: () => _removeSong(index),
                  icon3: 'images/qr-code-small.png',
                  onPressed3: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateQR(song: _songs[index])))}
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
