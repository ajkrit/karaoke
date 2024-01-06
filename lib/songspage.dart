import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'widgets.dart';
import 'variables.dart';
import 'homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Song {
  final int id;
  final String title;
  final String artist;

  Song({
    required this.id,
    required this.title,
    required this.artist,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as int,
      title: json['title'] as String,
      artist: json['artist'] as String,
    );
  }
}

Future<List<Song>> fetchSongs({String? id, String? language, String? genre}) async {
  try {
    final response = await http.get(Uri.parse(
        'http://192.168.1.245:5000/api/getSongs?id=$id&language=$language&genre=$genre'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Song> songs = data.map((item) => Song.fromJson(item)).toList();
      return songs;
    } else {
      throw Exception('Failed to load data. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching songs: $e');
    return [];
  }
}


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
    final List<Song> songs = await fetchSongs(id: id, language: language, genre: genre);
    setState(() {
      _songs = songs;
    });
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
                      textAlign: TextAlign.center,
                      _genre,
                      style: AppStyles.backgroundText
                  ),
                ]
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
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));},
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
