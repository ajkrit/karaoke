import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets.dart';
import 'variables.dart';
import 'playpage.dart';
import 'dart:io';
import 'dart:convert';
import 'generateQRcode.dart';
import 'variables.dart';

class SongsPage extends StatefulWidget {
  final String language;
  final String genre;

  SongsPage({
    required this.language,
    required this.genre,
  });

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  late String _language;
  late String _genre;
  List<Song> _songs = [];

  @override
  void initState() {
    super.initState();
    _language = widget.language;
    _genre = widget.genre;
    _loadSongs(id: '0', language: _language, genre: _genre);
  }

  Future<void> _loadSongs({String? id, String? language, String? genre}) async {
    try {
      final List<Song> songs = await fetchSongs(id: id, language: language, genre: genre);
      setState(() {
        _songs = songs;
        //print(songs);
      });
    } catch (e) {
      print('\n\n\n\nError fetching songs from the database: $e\n\n\n\n');
    }
  }


  Future<int> _downloadSong(int index) async {
    try {
      int ret = 1;
      var response = await http.get(
          Uri.parse('https://drive.google.com/uc?export=download&id=${_songs[index].sound_path}'));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? folderPath = prefs.getString('folderPath');

      var file = File('$folderPath/${_songs[index].sound_path}.mp3');
      if (file.existsSync()) ret = 0;
      await file.writeAsBytes(response.bodyBytes, flush: true);

      var jsonFile = File('$folderPath/${_songs[index].sound_path}.json');
      var songInfo = {
        'id': _songs[index].id,
        'title': _songs[index].title,
        'artist': _songs[index].artist,
        'genre': _songs[index].genre,
        'language': _songs[index].language,
        'lyrics': _songs[index].lyrics,
        'sound_path': _songs[index].sound_path,
      };
      await jsonFile.writeAsString(jsonEncode(songInfo), flush: true);

      print('\n\n\n\nDownloaded/Updated MP3 file\n\n\n\n');
      print("\n\n\n\nFile at: ${folderPath}/${_songs[index].sound_path}.mp3\n\n\n\n");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Download successful', style: AppStyles.scoreText),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );

      return ret;
    } catch (e) {
      print('\n\n\n\nError downloading MP3 file: $e\n\n\n\n');
      return 2;
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
                  _genre,
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
                  icon2: 'images/download.png',
                  onPressed2: () => _downloadSong(index),
                  icon3: 'images/qr-code-small.png',
                  onPressed3: () =>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerateQR(song: _songs[index])),
                  )
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
