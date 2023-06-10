import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = isDarkTheme == false ? lightTheme : darkTheme;
    return MaterialApp(
      theme: themeData, // Apply dark theme
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Notifications'),
        ),
        body: Center(
          child: Text('This is the Notification Screen'),
        ),
      ),
    );
  }
}
