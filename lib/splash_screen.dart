import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'widgets.dart';
import 'variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String username = '';
  String email = '';

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loadedUsername = prefs.getString('username') ?? '';
    String loadedEmail = prefs.getString('email') ?? '';
    double loadedScore = prefs.getDouble('score') ?? 0.0;

    if (loadedUsername.isNotEmpty) {
      setState(() {
        username = loadedUsername;
      });
      _usernameController.text = username;
    }

    if (loadedEmail.isNotEmpty) {
      setState(() {
        email = loadedEmail;
      });
      _emailController.text = email;
    }

    try {
      Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

      Directory appDataFolder = Directory('${appDocumentsDirectory.path}/karaoke');
      await appDataFolder.create(recursive: true);

      print('AppData folder created at: ${appDataFolder.path}');
    } catch (e) {
      print('Error creating AppData folder: $e');
    }
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('email', email);
    prefs.setBool('splash', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 150.0),
            const Text('Welcome!', style: AppStyles.backgroundText),
            SizedBox(height: 50.0),
            Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _usernameController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16.0),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  username = _usernameController.text;
                                });
                                _saveUserData();
                              },
                              icon: Image.asset('images/edit.png'),
                            ),
                          ),
                        ),
                        const Text(
                          'Username',
                          textAlign: TextAlign.left,
                          style: AppStyles.listDesc,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16.0),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  email = _emailController.text;
                                });
                                _saveUserData();
                              },
                              icon: Image.asset('images/edit.png'),
                            ),
                          ),
                        ),
                        const Text(
                          'E-mail',
                          style: AppStyles.listDesc,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Container(
                    height: 200,
                    width: 150,
                    child: SquareButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));},
                        icon: 'images/homepage.png',
                        label: 'Home')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

