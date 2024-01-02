import 'package:flutter/material.dart';
import 'widgets.dart';
import 'variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loadedUsername = prefs.getString('username') ?? '';
    String loadedEmail = prefs.getString('email') ?? '';

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
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('email', email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0, bottom: 50.0),
              child: Material(
                elevation: 8,
                shape: const CircleBorder(),
                child: Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor,
                  ),
                  child: Center(
                    child: Image.asset('images/account-large.png'),
                  ),
                ),
              ),
            ),
            const Text('Profile', style: AppStyles.backgroundText),
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
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Your average score is:',
                        style: AppStyles.scoreText,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '83.6%',
                        textAlign: TextAlign.center,
                        style: AppStyles.scorePoints,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: const MyAppBar(),
    );
  }
}
