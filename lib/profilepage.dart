import 'package:flutter/material.dart';
import 'widgets.dart';
import 'styles.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
              ]
            )
        ),
      bottomNavigationBar: MyAppBar(),
    );
  }
}