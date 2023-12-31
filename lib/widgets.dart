import 'package:flutter/material.dart';
import 'styles.dart';
import 'profilepage.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Image.asset('images/account-user.png'),
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));}
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

class CircularButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String icon;

  CircularButton({
    required this.onPressed,
    required this.icon,
  });

  @override
  _CircularButtonState createState() => _CircularButtonState();
}

class _CircularButtonState extends State<CircularButton> {
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
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: Image.asset(
        widget.icon,
        scale: 0.5,
        width: 100.0, // Adjust width as needed
        height: 100.0, // Adjust height as needed
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


class ListItem extends StatefulWidget {
  final String text;
  final String desc;
  final String icon;
  final VoidCallback onPressed;

  ListItem({
    required this.text,
    required this.desc,
    required this.icon,
    required this.onPressed,
  });

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    style: AppStyles.listText,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _subtitleController,
                    style: AppStyles.listDesc,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle button press
                print('Button pressed');
                print('Title: ${_titleController.text}');
                print('Subtitle: ${_subtitleController.text}');
              },
              child: Image.asset(widget.icon),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }
}