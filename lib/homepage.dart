import 'package:flutter/material.dart';
import 'widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Text(
          'Karaoke',
          style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0
          ),
        ),
      ),
      bottomNavigationBar: MyAppBar(),
    );
  }
}