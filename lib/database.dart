import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class Song {
  final String title;
  final String artist;

  const Song({
    required this.title,
    required this.artist,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
    };
  }

  @override
  String toString() {
    return 'Dog{title: $title, artist: $artist}';
  }
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    'http://192.168.1.245:3306/karaoke.db',
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE songs(id INTEGER PRIMARY KEY AUTO_INCREMENT, title TEXT, artist TEXT)',
      );
    },
    version: 1,
  );

  Future<void> insertSong(Song song) async {
    final db = await database;

    await db.insert(
      'songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Song>> songs() async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query('songs');

    return List.generate(maps.length, (i) {
      return Song(
        title: maps[i]['title'] as String,
        artist: maps[i]['artist'] as String,
      );
    });
  }
}