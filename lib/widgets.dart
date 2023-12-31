import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundColor = Color(0xFFFDFBB9);
  static const Color mainColor = Color(0xFFD06ECC);
  static const Color whiteColor = Colors.white;
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Image.asset('images/account-user.png'),
            onPressed: () {
              // Handle notifications button press
            },
          ),
          IconButton(
            icon: Image.asset('images/back.png'),
            onPressed: () {
              // Handle search button press
            },
          ),
          IconButton(
            icon: Image.asset('images/homepage.png'),
            onPressed: () {
              // Handle settings button press
            },
          ),
          IconButton(
            icon: Image.asset('images/settings.png'),
            onPressed: () {
              // Handle profile button press
            },
          ),
        ],
      ),
    );
  }
}