import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('Incognito Mode'),
            value: false, // Replace with your own logic to get/set the incognito mode value
            onChanged: (value) {
              // TODO: Implement logic to toggle incognito mode
            },
          ),
          ListTile(
            title: Text('Notification Settings'),
            onTap: () {
              showPopupDialog(context, 'Notification Settings', 'This feature is coming soon!');
            },
          ),
          ListTile(
            title: Text('Privacy Policy'),
            onTap: () {
              showPopupDialog(
                  context, 'Privacy Policy', 'Your privacy is important to us. This is the privacy policy text.');
            },
          ),
          ListTile(
            title: Text('Version'),
            onTap: () {
              showPopupDialog(context, 'Version', 'App Version 1.0.0');
            },
          ),
        ],
      ),
    );
  }

  void showPopupDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
