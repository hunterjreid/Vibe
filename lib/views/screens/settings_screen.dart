import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = isDarkTheme == false ? lightTheme : darkTheme;
    print(isDarkTheme);

    if (isDarkTheme == null) {
      // Fallback theme in case of null value
      themeData = ThemeData.light();
    }

    BottomNavigationBarThemeData bottomNavigationBarTheme = ThemeData().bottomNavigationBarTheme;
    return MaterialApp(
      theme: themeData, // Apply dark theme
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to previous screen
            },
          ),
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
                showPopupDialog(context, 'Privacy Policy',
                    'At Vibe, we prioritize your privacy and want you to feel secure while using our services. We want to assure you that we do not store any of your personal information.\n\nWe believe that your data should be yours alone, and we respect your right to control and protect it. ');
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
