import 'package:flutter/material.dart';
import 'variables.dart';
import 'profilepage.dart';
import 'homepage.dart';
import 'settingspage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

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
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));}
          ),
          IconButton(
            icon: Image.asset('images/back.png'),
            onPressed: () {Navigator.pop(context);},
          ),
          IconButton(
            icon: Image.asset('images/homepage.png'),
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));},
          ),
          IconButton(
            icon: Image.asset('images/settings.png'),
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));},
          ),
        ],
      ),
    );
  }
}

class CircularButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String icon;

  const CircularButton({super.key, 
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
        fixedSize: const Size(10, 10),
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

  const SquareButton({super.key, 
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
        fixedSize: const Size(10, 10),
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 14.0),
            child: Image.asset(
              widget.icon,
              scale: 0.5,
              width: 100.0, // Adjust width as needed
              height: 100.0, // Adjust height as needed
            ),
          ),
          const SizedBox(width: 15.0), // Add spacing between icon and text
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

  const ListItem({super.key, 
    required this.text,
    required this.desc,
    required this.icon,
    required this.onPressed,
  });

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

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
                  const SizedBox(height: 8),
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


class SwitchContainer extends StatefulWidget {
  final String title;
  final String description;
  final String switchVal;

  const SwitchContainer({
    Key? key,
    required this.title,
    required this.description,
    required this.switchVal,
  }) : super(key: key);

  @override
  _SwitchContainerState createState() => _SwitchContainerState();
}

class _SwitchContainerState extends State<SwitchContainer> {
  late bool switchValue = true;

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  Future<void> _loadSwitchValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switchValue = prefs.getBool(widget.switchVal) ?? true;
    });
  }

  Future<void> _saveSwitchValue(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.switchVal, value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          const Spacer(),
          Switch(
            activeColor: AppColors.mainColor,
            value: switchValue,
            onChanged: (value) {
              setState(() {
                switchValue = value;
              });
              _saveSwitchValue(value);
            },
          ),
        ],
      ),
    );
  }
}


class DropDownContainer extends StatefulWidget {
  final String title;
  final String description;
  final String switchVal;
  final List<String> dropdownItems;

  const DropDownContainer({
    Key? key,
    required this.title,
    required this.description,
    required this.switchVal,
    required this.dropdownItems,
  }) : super(key: key);

  @override
  _DropDownContainerState createState() => _DropDownContainerState();
}

class _DropDownContainerState extends State<DropDownContainer> {
  late String selectedItem = pitchList.first;

  @override
  void initState() {
    super.initState();
    _loadSelectedItem();
  }

  Future<void> _loadSelectedItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedItem = prefs.getString(widget.switchVal) ?? widget.dropdownItems.first;
    });
  }

  Future<void> _saveSelectedItem(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.switchVal, value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          const Spacer(),
          DropdownButton<String>(
            value: selectedItem,
            items: widget.dropdownItems.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedItem = value;
                });
                _saveSelectedItem(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
