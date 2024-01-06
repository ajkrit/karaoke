import 'package:flutter/material.dart';

List<String> greekGenres = [
  'Rock', 'Entechno', 'Rembetiko', 'Laiko'
];

List<String> englishGenres = [
  'Rock', 'Pop', 'Party', 'Disney'
];

List<String> greekGenreIcons = [
  'images/The Band Torso-1.png',
  'images/The Band Torso-4.png',
  'images/The Band Torso-3.png',
  'images/The Band Torso-2.png',
  'images/The Band Torso-5.png'
];

List<String> englishGenreIcons = [
  'images/The Band Torso-5.png',
  'images/The Band Torso-1.png',
  'images/The Band Torso-2.png',
  'images/The Band Torso-4.png',
  'images/The Band Torso-3.png'
];

List<String> pitchList = [
  'Default', 'C', 'D', 'E'
];

List<String> handshakePhrases = [
  "Compete with integrity, finish with a handshake.",
  "Fair play is our foundation—seal it with a handshake.",
  "Play hard, play fair, and extend a handshake in the end.",
  "In the game of life, fair play prevails. Conclude with a handshake.",
  "Compete fiercely, but remember the handshake of respect.",
  "True champions embody fair play. Seal your victories with a handshake.",
  "Every competition deserves fair play and a final handshake.",
  "Victory is sweetest when earned with fair play. End it with a handshake.",
  "Compete with honor, end with a handshake of sportsmanship.",
  "The essence of fair play—complete it with a handshake.",
];

class AppColors {
  static const Color backgroundColor = Color(0xFFFDFBB9);
  static const Color mainColor = Color(0xFFD06ECC);
  static const Color whiteColor = Colors.white;
}

class AppStyles {
  static const TextStyle mainButtonText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle scoreText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle scorePoints = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.mainColor,
  );

  static const TextStyle purpleBoxText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 23.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle listText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle listDesc = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static const TextStyle backgroundText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 23.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle lyrics = TextStyle(
    fontFamily: 'Inter',
    fontStyle: FontStyle.italic,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle dailySongText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle dailySongDesc = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
}