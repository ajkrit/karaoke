import 'package:flutter/material.dart';
import 'widgets.dart';
import 'styles.dart';

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
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle button 1 press
                        print('Button 1 pressed');
                      },
                      child: Text('Button 1'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle button 2 press
                        print('Button 2 pressed');
                      },
                      child: Text('Button 2'),
                    ),
                  ],
                ),
              ),
              const Text(
                'Karaoke',
                style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0
                ),
              ),
              Expanded(
                child:
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 20
                    ),
                    children: [
                      SquareButton(onPressed: ()  {Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));}, icon: 'images/duel.png', label: 'Song of Day'),
                      SquareButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));}, icon: 'images/duel.png', label: 'Songs'),
                      SquareButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));}, icon: 'images/duel.png', label: 'Favorites'),
                      SquareButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));}, icon: 'images/duel.png', label: 'Challenge')
                    ],
                  ),
                )
              )
            ]
        ),
      ),
      bottomNavigationBar: MyAppBar(),
    );
  }
}