import 'package:flutter/material.dart';
import 'widgets.dart';
import 'variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({Key? key}) : super(key: key);

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100.0),
            Text(
              'Choose a genre',
              style: AppStyles.backgroundText,
            ),
            SizedBox(height: 50.0),
            Text(
              'Greek',
              style: AppStyles.backgroundText,
            ),
            SizedBox(
              height: 200.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 16.0),
                    Container(
                      height: 150.0,
                      width: 150.0,
                      child: SquareButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => HomePage()
                              )
                          );
                        },
                        icon: 'images/The Band Torso.png',
                        label: 'Rock',
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Container(
                      height: 150.0,
                      width: 150.0,
                      child: SquareButton(
                        onPressed: () {},
                        icon: 'images/The Band Torso-2.png',
                        label: 'Entechno',
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Container(
                      height: 150.0,
                      width: 150.0,
                      child: SquareButton(
                        onPressed: () {},
                        icon: 'images/The Band Torso-3.png',
                        label: 'Rembetiko',
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Container(
                      height: 150.0,
                      width: 150.0,
                      child: SquareButton(
                        onPressed: () {},
                        icon: 'images/The Band Torso-4.png',
                        label: 'Laiko',
                      ),
                    ),
                    SizedBox(width: 16.0),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.0),
            const Text(
              'English',
              style: AppStyles.backgroundText,
            ),
            SizedBox(
              height: 200.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 16.0),
                    Container(
                      height: 150.0,
                      width: 150.0,
                      child: SquareButton(
                        onPressed: () {},
                        icon: 'images/The Band Torso-1.png',
                        label: 'Rock',
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Container(
                      height: 150.0,
                      width: 150.0,
                      child: SquareButton(
                        onPressed: () {},
                        icon: 'images/The Band Torso-5.png',
                        label: 'Pop',
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Container(
                      height: 150.0,
                      width: 150.0,
                      child: SquareButton(
                        onPressed: () {},
                        icon: 'images/The Band Torso-4.png',
                        label: 'Party',
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Container(
                      height: 150.0,
                      width: 150.0,
                      child: SquareButton(
                        onPressed: () {},
                        icon: 'images/The Band Torso-2.png',
                        label: 'Disney',
                      ),
                    ),
                    SizedBox(width: 16.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyAppBar(),
    );
  }
}
