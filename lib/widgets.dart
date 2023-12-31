import 'package:flutter/material.dart';
import 'styles.dart';


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


class SquareButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String icon;
  final String label;

  SquareButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  _SquareButtonState createState() => _SquareButtonState();
}

class _SquareButtonState extends State<SquareButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        elevation: isPressed ? 0 : 8,
        fixedSize: Size(10, 10),
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 14.0),
            child: Image.asset(
              widget.icon,
              scale: 0.5,
              width: 100.0, // Adjust width as needed
              height: 100.0, // Adjust height as needed
            ),
          ),
          SizedBox(width: 15.0), // Add spacing between icon and text
          Text(
            widget.label,
            style: AppStyles.mainButtonText
          ),
        ],
      ),
    );
  }
}