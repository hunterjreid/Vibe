import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool ignoreMode = false;
  bool soundEnabled = true;
  bool darkMode = false;
  bool notificationsEnabled = true;
  bool autoPlayEnabled = true;
  bool saveHistory = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options', style: TextStyle(
                      fontFamily: 'monaSans', // Apply monaSans font
                      fontSize: 28,
                      color: Colors.white,
                    ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Ignore Mode'),
              value: ignoreMode,
              onChanged: (value) {
                setState(() {
                  ignoreMode = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Sound'),
              value: soundEnabled,
              onChanged: (value) {
                setState(() {
                  soundEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Auto Play'),
              value: autoPlayEnabled,
              onChanged: (value) {
                setState(() {
                  autoPlayEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Save History'),
              value: saveHistory,
              onChanged: (value) {
                setState(() {
                  saveHistory = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
