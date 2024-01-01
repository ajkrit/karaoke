import 'package:flutter/material.dart';
import 'widgets.dart';
import 'variables.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100.0, bottom: 50.0),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppColors.whiteColor,
                  ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sounds',
                          style: AppStyles.listText,
                        ),
                        Text(
                            'Enables all sounds.',
                            style: AppStyles.listDesc
                        )
                      ]
                    ),
                    SizedBox(width: 170.0),
                    Switch(
                      activeColor: AppColors.mainColor,
                      value: switchValue,
                      onChanged: (value) {
                        setState(() {
                          switchValue = value;
                        });
                        // Handle the switch toggle event
                        // You can perform actions based on the switch state
                      },
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyAppBar(),
    );
  }
}
