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
            title: Text('Dark Mode'),
            value: false, // Replace with your own logic to get/set the dark mode value
            onChanged: (value) {
              // TODO: Implement logic to toggle dark mode
            },
          ),
          ListTile(
            title: Text('Notification Settings'),
            onTap: () {
              // TODO: Navigate to notification settings page
            },
          ),
          ListTile(
            title: Text('Privacy Policy'),
            onTap: () {
              // TODO: Navigate to privacy policy page
            },
          ),
          ListTile(
            title: Text('About'),
            onTap: () {
              // TODO: Navigate to about page
            },
          ),
        ],
      ),
    );
  }
}
