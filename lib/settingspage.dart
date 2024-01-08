import 'package:flutter/material.dart';
import 'widgets.dart';
import 'variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _sounds = false;
  bool _notifications = false;

  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sounds = (prefs.getBool('sounds') ?? true);
      _notifications = (prefs.getBool('notifications') ?? true);
    });
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
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
                    child: Image.asset('images/settings-large.png'),
                  ),
                ),
              ),
            ),
            const Text(
              'Settings',
              style: AppStyles.backgroundText,
            ),
            const SizedBox(height: 15.0),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              child: SwitchContainer(title: 'Sounds', description: 'Enables all sounds (except tracks).', switchVal: 'sounds')
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                child: SwitchContainer(title: 'Vibrations', description: 'Enables vibrations.', switchVal: 'vibrations')
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                child: DropDownContainer(title: 'Pitch', description: 'Change pitch.', switchVal: 'pitch', dropdownItems: pitchList,)
            )
          ],
        ),
      ),
      bottomNavigationBar: const MyAppBar(),
    );
  }
}
