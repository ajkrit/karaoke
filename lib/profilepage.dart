import 'package:flutter/material.dart';
import 'widgets.dart';
import 'variables.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _textController = TextEditingController();

  String username = '';

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
                      child:
                        Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whiteColor,
                          ),
                          child: Center(
                            child: Image.asset('images/account-large.png'),
                          ),
                        )
                  ),
                ),
                const Text(
                  'Profile',
                  style: AppStyles.backgroundText
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10.0), // Set rounded borders
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _textController,
                              textAlign: TextAlign.left, // Align the text to the left
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16.0), // Add padding inside the TextField
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      username = _textController.text;
                                    });
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
                          borderRadius: BorderRadius.circular(10.0), // Set rounded borders
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _textController,
                              textAlign: TextAlign.left, // Align the text to the left
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16.0), // Add padding inside the TextField
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      username = _textController.text;
                                    });
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
                      width: 150.0, // Adjust width as needed
                      height: 150.0, // Adjust height as needed
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
                          SizedBox(height: 8.0), // Add some vertical spacing
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
              ]
            )
        ),
      bottomNavigationBar: const MyAppBar(),
    );
  }
}