import 'package:flutter/material.dart';
import 'widgets.dart';
import 'variables.dart';
import 'songspage.dart';

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
            Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: greekGenres.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    child: Container(
                      height: 150.0,
                      width: 150.0,
                      child: SquareButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                SongsPage(
                                    language: 'Greek', genre: greekGenres[index])));},
                          icon: greekGenreIcons[index],
                          label: greekGenres[index]),
                    ),
                  );
                },
              ),

            ),
            SizedBox(height: 50.0),
            const Text(
              'English',
              style: AppStyles.backgroundText,
            ),
            Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: englishGenres.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    child: Container(
                      height: 150.0,
                      width: 150.0,
                      child: SquareButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                SongsPage(
                                    language: 'English', genre: englishGenres[index])));},
                          icon: englishGenreIcons[index],
                          label: englishGenres[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyAppBar(),
    );
  }
}
